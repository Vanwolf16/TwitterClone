//
//  Constants.swift
//  TwitterClone
//
//  Created by David Murillo on 6/15/21.
//

import Firebase
//Storagre
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
//Database
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("user")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")

//Database Follow and Following
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")

let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_TWEET_LIKES = DB_REF.child("tweet-likes")
let REF_NOTIFICATION = DB_REF.child("notifications")
