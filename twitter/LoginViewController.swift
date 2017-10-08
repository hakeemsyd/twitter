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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func onTwitterLoginClick(_ sender: UIButton) {
        TwitterClient.sharedInstance.login(success: { 
            print("I have loggedIn")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.handleUserAuthentication()
        }) { (error: Error) in
            print("\(error.localizedDescription)")
        }
    }
}

