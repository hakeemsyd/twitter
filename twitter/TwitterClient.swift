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
    
    func getTweet(id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = [
            "id": id
        ]
        
        get("1.1/statuses/show.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dict = response as! NSDictionary
            let tweet = Tweet(dict: dict)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func homeTimeline(lastTweetId: Int, maxCount: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var params: NSDictionary? = nil
        if lastTweetId > 0 {
            params = [
                "count": maxCount,
                "since_id": lastTweetId
            ]
        }
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
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
            success(u)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
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
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(Notification(name: NSNotification.Name.init(User.userDidLogoutNotification)))
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    func tweet(text: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let params: NSDictionary = [
            "status": text
        ]
        
        self.post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func fav(tweetId: Int, val: Bool, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var endpoint: String = "1.1/favorites/create.json"
        if(!val) {
            endpoint = "1.1/favorites/destroy.json"
        }
        
        let params: NSDictionary = [
            "id": tweetId
        ]
        self.post(endpoint, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let d = response as? NSDictionary
            let tweet = Tweet(dict: d!)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
}
