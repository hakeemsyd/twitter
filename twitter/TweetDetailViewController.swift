//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/28/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var favButtonView: UIButton!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetUserName: UILabel!
    @IBOutlet weak var retweetButtonView: UIButton!
    var tweetId: Int = 0
    @IBOutlet weak var numFavView: UILabel!
    @IBOutlet weak var numRetweetsView: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var aliasView: UILabel!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onFavorite(_ sender: Any) {
        TwitterClient.sharedInstance.fav(tweetId: tweetId, val: !(tweet?.favourited)!,success: { (tweet: Tweet) in
            self.tweetId = tweet.id!
            self.update()
        }) { (error: Error) in
            print("\(error.localizedDescription)")
        }
    }
    @IBAction func onRetweet(_ sender: UIButton) {
        TwitterClient.sharedInstance.retweet(tweetId: tweetId, val: !(tweet?.retweeted)!, success: { (tweet: Tweet) in
            //self.tweetId = tweet.id!
            self.update()
        }) { (error: Error) in
            print("\(error.localizedDescription)")
        }
    }

    @IBAction func onReply(_ sender: UIButton) {
    }
    
    private func update(){
        if(tweetId > 0) {
            TwitterClient.sharedInstance.getTweet(id: tweetId, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.tweetTextView.text = tweet.text
                self.aliasView.text = tweet.user?.screenname
                self.nameView.text = tweet.user?.name
                self.numRetweetsView.text = "\(tweet.retweetCount) RETWEETS"
                self.numFavView.text = "\(tweet.favoriteCount) FAVORITES"
                self.favButtonView.setImage(tweet.getFavIcon(), for: [])
                self.retweetButtonView.setImage(tweet.getRetweetedIcon(), for: [])
                Helper.loadPhoto(withUrl: (tweet.user?.profileImageUrl)!, into: self.profileImage)
                
               if let rUser = tweet.retweetUser {
                    self.retweetUserName.text = "\(rUser.screenname ?? "") Retweeted"
                    self.retweetUserName.isHidden = false
                    self.retweetIcon.isHidden = false
                } else {
                    self.retweetUserName.isHidden = true
                    self.retweetIcon.isHidden = true
                }
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
