//
//  User.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/25/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class User {
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenname: String?
    var profileImageUrl: URL?
    var coverImageUrl: URL?
    var tagline: String?
    
    var dictionary: NSDictionary?
    
    init(dict: NSDictionary) {
        self.dictionary = dict
        name = dict["name"] as? String
        screenname = dict["screen_name"] as? String
        let st = dict["profile_image_url_https"] as? String
        let profileUrlStr = st?.replacingOccurrences(of: "_normal", with: "_bigger")
        if let profileUrlStr = profileUrlStr {
            profileImageUrl = URL(string: profileUrlStr)
        }
        
        let banner = dict["profile_banner_url"] as? String
        if let banner = banner {
            coverImageUrl = URL(string: banner)
        }
    }
    
    static var _currentUser: User?
    
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey:
                "currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(dict: dictionary)
                }
            
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
