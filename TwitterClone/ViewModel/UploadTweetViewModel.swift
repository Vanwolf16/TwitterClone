//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by David Murillo on 7/17/21.
//

import Foundation

enum UploadTweetConfiguration{
    case tweet
    case replay(Tweet)
}

struct UploadTweetViewModel{
    let actionButtonTitle:String
    let placeholderText:String
    var shouldShowReplayLbl:Bool
    var replayTxt:String?
    
    init(config:UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's Happening"
            shouldShowReplayLbl = false
            break
        case .replay(let tweet):
            actionButtonTitle = "Replay"
            placeholderText = "Tweet Your Replay"
            shouldShowReplayLbl = true
            replayTxt = "Replaying to @\(tweet.user.username)"
            break
        default:
            print("Error")
            break
        }
    }
    
}
