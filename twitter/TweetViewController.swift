//
//  TweetViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/27/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    let MAX_TWEET_CHARS = 5
    @IBOutlet weak var currCharsAvailableView: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var tweetText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetText.text = ""
        currCharsAvailableView.text = "\(MAX_TWEET_CHARS)"
        
        tweetText.delegate = self
        Helper.loadPhoto(withUrl: (User.currentUser?.profileImageUrl)!, into: profileImageView)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTweet(_ sender: UIBarButtonItem) {
        if let txt = tweetText.text {
            if(!txt.isEmpty && txt.characters.count < 140) {
                TwitterClient.sharedInstance.tweet(text: txt, success: {
                    print("Tweet posted")
                    self.dismiss(animated: true, completion: nil)
                }, failure: { (error: Error) in
                    print("Failed to post: \(error.localizedDescription)")
                    self.showPostFailureError(error: error)
                })
            } else {
                showTweetCountError(count: txt.characters.count)
            }
        }
    }
    
    @IBAction func onCancelTweet(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showTweetCountError(count: Int) {
        print("Text cannot be longer then 140, you entered \(count)")
    }
    
    private func showPostFailureError(error: Error) {
        print("Not sure what to do. Post failed")
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        let currText = tweetText.text
        let avail =  MAX_TWEET_CHARS - (currText?.characters.count)!
        currCharsAvailableView.text = "\(avail)"
        if avail == 0 {
            //let index = currText?.index(before: String.Index)
            //let newText = currText?.substring(to: index)
            if let currText = currText {
                //textView.text = currText.substring(to: currText.index(before: currText.endIndex - MAX_TWEET_CHARS ))
            }

        }
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
