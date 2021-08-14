//
//  UserService.swift
//  TwitterClone
//
//  Created by David Murillo on 6/16/21.
//

import UIKit
import Firebase

typealias DatabaseCompletion = ((Error?,DatabaseReference) -> Void)

struct UserService{
    static let shared = UserService()
    //One User just the Client
    func fetchUser(uid:String,completion:@escaping(User) -> Void){
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    //For ExploreControllers
    func fetchUsers(completion:@escaping([User]) -> Void){
        var users = [User]()
        
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
        
    }
    
    //Follow and Following Method
    
    func followUser(uid:String,completion:@escaping(Error?,DatabaseReference) -> ()){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid:1]) { err, ref in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid:1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid:String,completion:@escaping(DatabaseCompletion)){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { error, ref in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
        
    }
    
    func checkIfUserIsFollowed(uid:String,completion:@escaping (Bool) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid:String,completion:@escaping(UserRelationStats) -> Void){
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(followers: followers, following: following)
                completion(stats)
            }
            
        }
    }
    
}