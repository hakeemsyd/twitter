//
//  MenuViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 10/6/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let menu = ["Profile", "Timeline", "Mentions"]
    var vcs: [UIViewController] = []
    private var profileVC: UIViewController!
    private var timeLineVC: UIViewController!
    private var mentionsVC: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileVC = ProfileViewController()
        timeLineVC = storyboard.instantiateViewController(withIdentifier: "homeViewController")
        //tweetVC = storyboard.instantiateViewController(withIdentifier: "postViewController")
        mentionsVC = MentionsViewController()
        
        vcs.append(profileVC)
        vcs.append(timeLineVC)
        vcs.append(mentionsVC)
        hamburgerViewController.contentViewController = vcs[0]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        hamburgerViewController.contentViewController = vcs[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        cell.menuLabel.text = menu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return vcs.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   }
}
