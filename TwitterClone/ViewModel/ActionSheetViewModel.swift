//
//  ActionSheetViewModel.swift
//  TwitterClone
//
//  Created by David Murillo on 7/19/21.
//

import UIKit

enum ActionSheetOptions{
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description:String{
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "UnFollow @\(user.username)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
    
}
 

struct ActionSheetViewModel{
    private let user:User
    
    var options:[ActionSheetOptions]{
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser{
            results.append(.delete)
        }else{
            let followOptions:ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOptions)
        }
        results.append(.report)
        
        return results
    }
    
    init(user:User) {
        self.user = user
    }
    
}
