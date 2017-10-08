//
//  TweetCell.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/28/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetButtonView: UIButton!
    @IBOutlet weak var favButtonView: UIButton!
    @IBOutlet weak var retweetUserName: UILabel!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var aliasView: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    var tweet: Tweet?
    
    var onOpenProfile: ((User) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postTextView.isScrollEnabled = false
        postTextView.isEditable = false
        postTextView.resignFirstResponder()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfPicTap))
        profileImageView.addGestureRecognizer(tapGesture)
        
        if tweet != nil {
            update()
        }
    }
    
    func update() {
        let url = tweet?.user?.profileImageUrl
        Helper.loadPhoto(withUrl: url!, into: (profileImageView)!)
        postTextView.text = tweet?.text
        nameView.text = tweet?.user?.name
        aliasView.text = "@\(tweet?.user?.screenname ?? "")"
        timeView.text = tweet?.timestamp?.timeAgo()
        if let rUser = tweet?.retweetUser {
            retweetUserName.text = "\(rUser.screenname ?? "") Retweeted"
            retweetUserName.isHidden = false
            retweetIcon.isHidden = false
        } else {
            retweetUserName.isHidden = true
            retweetIcon.isHidden = true
        }
        
        favButtonView.setImage(tweet?.getFavIcon(), for: [])
        retweetButtonView.setImage(tweet?.getRetweetedIcon(), for: [])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func handleProfPicTap(_ sender: UITapGestureRecognizer) {
        print("profile pic tapped")
        onOpenProfile!((tweet?.user)!)
    }

}
