//
//  ProfileHeader.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 10/7/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class ProfileHeader: UITableViewCell {
    
    var color: UIColor!
    var user: User! {
        didSet {
            if user != nil {
                update()
            }
        }
    }
    
    @IBOutlet weak var coverPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        if user != nil {
            update()
        }
        // Initialization code
    }
    
    func update() {
        Helper.loadPhoto(withUrl: user.coverImageUrl!, into: coverPhoto)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
