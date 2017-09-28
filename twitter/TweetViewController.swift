//
//  TweetViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/27/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var tweetText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onCancelTweet(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
