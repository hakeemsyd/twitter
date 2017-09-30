//
//  Tweet.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/25/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class Tweet {
    var id: Int?
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User?
    var retweetUser: User?
    var favourited: Bool?
    
    init(dict: NSDictionary) {
        text = dict["text"] as? String
        retweetCount = (dict["retweet_count"] as? Int) ?? 0
        favoriteCount = (dict["favorite_count"] as? Int) ?? 0
        favourited = dict["favourited"] as? Bool ?? false
        
        let timeStampStr = dict["created_at"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timeStampStr = timeStampStr {
            timestamp = formatter.date(from: timeStampStr)! as NSDate
        }
        
        let idStr = dict["id"] as? Int
        if let idStr = idStr {
            id = idStr as Int
        }
        
        let retweetDict = dict["retweeted_status"] as? NSDictionary
        if let retweetDict = retweetDict {
            retweetUser = User(dict: retweetDict["user"] as! NSDictionary)
        }
        
        user = User(dict: dict["user"] as! NSDictionary)
    }
    
    class func tweetsWithArray(dicts: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dict in dicts {
            let tweet =  Tweet(dict: dict)
            tweets.append(tweet)
        }
        return tweets
    }
    
}

