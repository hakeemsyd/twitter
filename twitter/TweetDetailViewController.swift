//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/28/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweetId: Int = 0
    @IBOutlet weak var numFavView: UILabel!
    @IBOutlet weak var numRetweetsView: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var aliasView: UILabel!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onFavorite(_ sender: Any) {
    }
    @IBAction func onRetweet(_ sender: UIButton) {
    }

    @IBAction func onReply(_ sender: UIButton) {
    }
    
    private func update(){
        if(tweetId > 0) {
            TwitterClient.sharedInstance.getTweet(id: tweetId, success: { (tweet: Tweet) in
                self.tweetTextView.text = tweet.text
                self.aliasView.text = tweet.user?.screenname
                self.nameView.text = tweet.user?.name
                self.numRetweetsView.text = "\(tweet.retweetCount) RETWEETS"
                self.numFavView.text = "\(tweet.favoriteCount) FAVORITES"
                Helper.loadPhoto(withUrl: (tweet.user?.profileImageUrl)!, into: self.profileImage)
            }, failure: { (error: Error) in
                
            })
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
