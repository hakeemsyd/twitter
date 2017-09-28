//
//  Tweet.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 9/25/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class Tweet {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User?
    
    init(dict: NSDictionary) {
        text = dict["text"] as? String
        retweetCount = (dict["retweet_count"] as? Int) ?? 0
        favoriteCount = (dict["favourites_count"] as? Int) ?? 0
        
        let timeStampStr = dict["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        if let timeStampStr = timeStampStr {
            timestamp = formatter.date(from: timeStampStr)
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

