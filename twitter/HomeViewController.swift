//
//  HomeViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/26/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var retweetedIcon: UIImageView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var userTweets: [Tweet] = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // pull to refresh
        refreshControl.addTarget(self, action: #selector(onUserInitiatedRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 @IBAction func onLogoutClicked(_ sender: UIBarButtonItem) {
    TwitterClient.sharedInstance.logout()
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as? TweetCell
        let t = userTweets[indexPath.row]
        let url = t.user?.profileImageUrl
        Helper.loadPhoto(withUrl: url!, into: (cell?.profileImageView)!)
        cell?.postTextView.text = t.text
        cell?.nameView.text = t.user?.name
        cell?.aliasView.text = "@\(t.user?.screenname ?? "")"
        cell?.tweet = t
        cell?.timeView.text = t.timestamp?.timeAgo()
        if let rUser = t.retweetUser {
              cell?.retweetUserName.text = "\(rUser.screenname ?? "") Retweeted"
            cell?.retweetUserName.isHidden = false
            cell?.retweetIcon.isHidden = false
        } else {
            cell?.retweetUserName.isHidden = true
            cell?.retweetIcon.isHidden = true
        }
        return cell!
    }

    func onUserInitiatedRefresh(_ refreshControl: UIRefreshControl) {
        update()
    }
    
    private func update() {
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) in
            self.userTweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            for tweet in tweets {
                print(tweet)
            }
        }) { (error: Error) in
            self.refreshControl.endRefreshing()
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewTweetSegue") {
             let destinationViewController = segue.destination as! TweetDetailViewController
             let s = sender as! TweetCell
             destinationViewController.tweetId = (s.tweet?.id)!
        } else if (segue.identifier == "tweetSegue"){
        
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
