//
//  User.swift
//  TwitterClone
//
//  Created by David Murillo on 6/16/21.
//

import UIKit
import Firebase

struct User {
    let fullname:String
    let email:String
    let username:String
    let profileImageUrl:String
    let uid:String
    
    var isFollowed = false
    
    var isCurrentUser:Bool {return Auth.auth().currentUser?.uid == uid}
    
    var stats:UserRelationStats?
    
    init(uid:String,dictionary:[String:Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
    
}

struct UserRelationStats{
    var followers:Int
    var following:Int
}
