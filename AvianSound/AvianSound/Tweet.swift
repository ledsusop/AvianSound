//
//  Tweet.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    var id: Int!
    var inReplyToStatusId: Int?
    var inReplyToUserIdStr: String?
    var inReplyToScreenName: String?
    
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        inReplyToStatusId = (dictionary["in_reply_to_status_id"] as? Int) ?? 0
        inReplyToUserIdStr = (dictionary["in_reply_to_user_id_str"] as? String)
        inReplyToScreenName = (dictionary["in_reply_to_screen_name"] as? String)
        
        if let timeStampString = dictionary["created_at"] as? String{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            timeStamp = formatter.dateFromString(timeStampString)
        }
        
        if let userDictionary = dictionary["user"] as? NSDictionary{
            user = User(dictionary: userDictionary)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
