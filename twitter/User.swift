//
//  User.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/25/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class User {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    
    init(dict: NSDictionary) {
        name = dict["name"] as? String
        screenname = dict["screen_name"] as? String
        let profileUrlStr = dict["profile_image_url_https"] as? String
        if let profileUrlStr = profileUrlStr {
            profileUrl = URL(string: profileUrlStr)
        }
        
    }
}
