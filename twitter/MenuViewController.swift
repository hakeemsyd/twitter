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
    private var profileVC: HomeViewController!
    private var timeLineVC: HomeViewController!
    private var mentionsVC: HomeViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        profileVC = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        profileVC.mode = Mode.PROFILE
        
        timeLineVC = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        timeLineVC.mode = Mode.HOME
        
        mentionsVC = storyboard.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        mentionsVC.mode = Mode.MENTIONS
        
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

    func navigateToProfile(user: User) {
        profileVC.user = user
        hamburgerViewController.contentViewController = profileVC
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   }
}
