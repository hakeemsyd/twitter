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
        TwitterClient.sharedInstance.login(success: { 
            print("I have loggedIn")
            //self.performSegue(withIdentifier: "loginSegue", sender: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.handleUserAuthentication()
        }) { (error: Error) in
            print("\(error.localizedDescription)")
        }
    }
}

