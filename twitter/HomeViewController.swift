//
//  HomeViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/26/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo

enum Update {
    case RESET, APPEND
}
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let MAX_TWEETS = 20
    var isMoreDataLoading = false
    @IBOutlet weak var retweetedIcon: UIImageView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var userTweets: [Tweet] = [Tweet]()
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // pull to refresh
        refreshControl.addTarget(self, action: #selector(onUserInitiatedRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        //update()
        
        //infinite scroll
        // infinite scroll
        let tableFooterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.tableView.tableFooterView = tableFooterView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        update(mode: Update.RESET)
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
        if(userTweets.count - indexPath.row <= MAX_TWEETS && !self.isMoreDataLoading){
            self.isMoreDataLoading = true;
            loadingView.startAnimating()
            update(mode: Update.APPEND)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as? TweetCell
        let t = userTweets[indexPath.row]
        cell?.tweet = t
        cell?.update()
        return cell!
    }

    func onUserInitiatedRefresh(_ refreshControl: UIRefreshControl) {
        
        update(mode: Update.RESET)
    }
    
    private func update(mode: Update) {
        var lasttweeId = -1
        if userTweets.count > 0 && mode ==  Update.APPEND {
            lasttweeId = (userTweets.last?.id)!
        }
        
        TwitterClient.sharedInstance.homeTimeline(lastTweetId: lasttweeId, maxCount: MAX_TWEETS, success: { (tweets: [Tweet]) in
            if mode == Update.RESET {
                self.userTweets = tweets
            } else if mode == Update.APPEND {
                self.userTweets += tweets
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.isMoreDataLoading = false
            self.loadingView.stopAnimating()
            
        }) { (error: Error) in
            self.refreshControl.endRefreshing()
            self.loadingView.stopAnimating()
            self.isMoreDataLoading = false
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
