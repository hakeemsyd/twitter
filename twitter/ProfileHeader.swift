//
//  ProfileHeader.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 10/7/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class ProfileHeader: UITableViewCell {
    
    var user: User! {
        didSet {
            if user != nil {
                update()
            }
        }
    }
    
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        if user != nil {
            update()
        }
    }
    
    func update() {
        Helper.loadPhoto(withUrl: user.coverImageUrl!, into: coverPhoto)
        Helper.loadPhoto(withUrl: user.profileImageUrl!, into: profilePicture)
        userName.text = user.name
        displayName.text = "@\(user.screenname ?? "")"
        tweetsCount.text = "14"
        followingCount.text = "14"
        followerCount.text = "14"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
