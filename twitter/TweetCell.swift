//
//  TweetCell.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/28/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetUserName: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var aliasView: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    var tweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postTextView.isScrollEnabled = false
        postTextView.isEditable = false
        postTextView.resignFirstResponder()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
