//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by David Murillo on 6/22/21.
//

import UIKit

enum ProfileFilterOptions:Int,CaseIterable {
    case tweets
    case replies
    case likes
    
    var description:String{
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
    
}

struct ProfileHeaderViewModel {
    private let user:User
    
    
    var followersString:NSAttributedString?{
        return attributedText(withValue: user.stats?.followers ?? 0, text: " followers")
    }
    
    var followingString:NSAttributedString?{
        return attributedText(withValue: user.stats?.following ?? 0, text: " following")
    }
    
    //For the User button
    var actionButtonTitle:String{
        if user.isCurrentUser{
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser{
            return "Follow"
        }
        
        if user.isFollowed{
            return "Following"
        }
        return "Loading..."
    }
    
    init(user:User) {
        self.user = user
    }
    
    
    fileprivate func attributedText(withValue value:Int,text:String) -> NSAttributedString{
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
    
}
