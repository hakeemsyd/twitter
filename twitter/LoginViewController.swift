//
//  ViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/25/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTwitterLoginClick(_ sender: UIButton) {
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterflash://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got a token: " + requestToken.token);
            let u = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token ?? "")"
            let url = URL(string: u)
            UIApplication.shared.openURL(url!)
            
        }, failure: { (error: Error!) in
            print("error: \(error?.localizedDescription ?? "")")
        })
    }
}

