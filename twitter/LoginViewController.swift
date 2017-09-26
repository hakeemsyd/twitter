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
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "65qAjjDv66sdNFBNTGOZ4DCIT", consumerSecret: "rLiDaoYWjQay9sied53yV2BxUFmv0DFbyHrMkPpKNMrwgIP55H")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: { (credentials: BDBOAuth1Credential!) in
            print("I got a token");
        }, failure: { (error: Error!) in
            print("error: \(error?.localizedDescription ?? "")")
        })
    }
}

