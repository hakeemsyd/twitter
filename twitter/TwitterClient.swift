//
//  TwitterClient.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/26/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "65qAjjDv66sdNFBNTGOZ4DCIT", consumerSecret: "rLiDaoYWjQay9sied53yV2BxUFmv0DFbyHrMkPpKNMrwgIP55H")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dict = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dicts: dict)
            for tweet in tweets {
                print("Tweet: \(tweet.text ?? "")")
            }
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dict = response as! NSDictionary
            let u = User(dict: dict)
            print(u.name!)
            print(u.profileUrl?.absoluteString ?? "")
            success(u)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        })
    }

    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> () ) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterflash://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            let u = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token ?? "")"
            let url = URL(string: u)
            UIApplication.shared.openURL(url!)
            
        }, failure: { (error: Error!) in
            print("error: \(error?.localizedDescription ?? "")")
            self.loginFailure?(error)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
}
