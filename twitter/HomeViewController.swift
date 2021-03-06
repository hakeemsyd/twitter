//
//  HomeViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/26/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo

enum Mode {
    case PROFILE, HOME, MENTIONS, SOMEONES_PROFILE
}

enum Update {
    case RESET, APPEND
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let MAX_TWEETS = 5
    
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var mode: Mode = Mode.PROFILE
    var isMoreDataLoading = false
    var refreshControl: UIRefreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var userTweets: [Tweet] = [Tweet]()
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var user: User = User.currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        if( mode == Mode.PROFILE || mode == Mode.SOMEONES_PROFILE) {
            setupHeader()
        }
    
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
        if mode == Mode.SOMEONES_PROFILE {
            //close this view
            dismiss(animated: true, completion: nil)
            return
        }
        
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
        cell?.onOpenProfile = { (user: User) in
            print("\(user.name ?? "")")
            self.handleProfPicTap(user: user)
        }
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
        
        TwitterClient.sharedInstance.timeline(userId: (user.id)!, mode: self.mode, lastTweetId: lasttweeId, maxCount: MAX_TWEETS, success: { (tweets: [Tweet]) in
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "viewTweetSegue") {
             let destinationViewController = segue.destination as! TweetDetailViewController
             let s = sender as! TweetCell
             destinationViewController.tweetId = (s.tweet?.id)!
        } else if (segue.identifier == "tweetSegue"){
        
        }
    }

    private func setupHeader() {
        let header = tableView.dequeueReusableCell(withIdentifier: "profileHeader") as! ProfileHeader
        header.user = user
        tableView.tableHeaderView = header
        
        if mode == Mode.SOMEONES_PROFILE {
            logoutButton.title = "close"
            tweetButton.isEnabled = false
        } else {
            logoutButton.title = "Log Out"
            tweetButton.isEnabled = true
        }
    }
    
    private func handleProfPicTap(user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        profileVC.user = user;
        profileVC.mode = Mode.SOMEONES_PROFILE
        self.present(profileVC, animated: true, completion: nil)
    }
}
