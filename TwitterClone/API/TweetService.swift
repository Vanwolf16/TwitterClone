//
//  TweetService.swift
//  TwitterClone
//
//  Created by David Murillo on 6/17/21.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption:String,type:UploadTweetConfiguration,completion:@escaping(Error?,DatabaseReference) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["uid":uid,"timestamp":Int(NSDate().timeIntervalSince1970),
                      "likes":0,
                      "retweets":0,
        "caption":caption] as [String:Any]
        
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { error, ref in
                guard let tweetID = ref.key else {return}
                if let error = error{
                    print("Error to upload Tweet: \(error)")
                    return
                }
                
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID:1], withCompletionBlock: completion)
                
            }
        case .replay(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
        
        
    }
    
    func fetchTweets(completion:@escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let tweetID = snapshot.key
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
        
    }
    
    //For User
    func fetchTweets(forUser user:User,completion:@escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                guard let uid = dictionary["uid"] as? String else {return}
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
                
            }
        }
    }
    
    //fetch one tweet
    func fetchTweet(withTweetID tweetID:String,completion:@escaping(Tweet) -> Void){
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
            
        }
    }
    
    func fetchReplies(forTweet tweet:Tweet,completion:@escaping([Tweet]) -> ()){
        var tweets = [Tweet]()
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let tweetID = snapshot.key
            
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
            
        }
    }
    
    //MARK:Liking and Unliking Tweet
    func likeTweet(tweet:Tweet,completion:@escaping(DatabaseCompletion)){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didLike{
            //Unlike
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { err, ref in
                if let error = err{
                    print(error.localizedDescription)
                    return
                }
                
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
                
            }
        }else{
            //Like the Tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID:1]) { err, ref in
                if let error = err{
                    print("User Like don't work \(error.localizedDescription)")
                    return
                }
                
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid:1], withCompletionBlock: completion)
                
            }
        }
        
    }//end of this function
    
    func checkIfUserLikeTweet(_ tweet:Tweet,completion:@escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
