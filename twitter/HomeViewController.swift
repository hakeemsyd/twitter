//
//  HomeViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/26/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var userTweets: [Tweet] = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.userTweets = tweets
            for tweet in tweets {
               print(tweet)
            }
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
