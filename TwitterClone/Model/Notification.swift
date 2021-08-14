//
//  Notification.swift
//  TwitterClone
//
//  Created by David Murillo on 7/22/21.
//

import Foundation

enum NotificationType:Int{
    case follow
    case like
    case replay
    case retweet
    case mention
}

struct Notification{
    var tweetID:String?
    var timestamp:Date!
    var user:User
    var tweet:Tweet?
    var type:NotificationType!
    
    init(user:User,dictionary:[String:AnyObject]) {
        self.user = user
        //self.tweet = tweet
        
        if let tweetID = dictionary["tweetID"] as? String{
            self.tweetID = tweetID
        }
        
        
        if let timestamp = dictionary["timestamp"] as? Double{
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int{
            self.type = NotificationType(rawValue: type)
        }
        
    }
    
}
