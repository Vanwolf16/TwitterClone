//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by David Murillo on 6/21/21.
//

import UIKit

struct TweetViewModel {
    let tweet:Tweet
    let user:User
    
    var profileImageUrl:URL?{
        return URL(string:user.profileImageUrl)
    }
    
    var usernameTxt:String {return "@\(user.username)"}
    
    var headerTimeStamp:String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ∙ MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetAttributedString:NSAttributedString?{
        return attributedText(withValue: tweet.retweetCount, text: " Retweet")
    }
    
    var likesAttributedString:NSAttributedString?{
        return attributedText(withValue: tweet.likes, text: " Likes")
    }
    
    var userInfoTxt:NSAttributedString{
        let title = NSMutableAttributedString(string: user.fullname, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: "  @\(user.username.lowercased()) ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        
        //Time
        title.append(NSAttributedString(string: " . \(timestamp) ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),.foregroundColor:UIColor.lightGray]))
        
        return title
    }
    
    var timestamp:String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour,.day,.weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
        
    }
    
    init(tweet:Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
   
    fileprivate func attributedText(withValue value:Int,text:String) -> NSAttributedString{
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
    }
    
    //Resizing Cell
    func size(forWidth width:CGFloat) -> CGSize{
        let measurementLbl = UILabel()
        measurementLbl.text = tweet.caption
        measurementLbl.numberOfLines = 0
        measurementLbl.lineBreakMode = .byWordWrapping
        measurementLbl.translatesAutoresizingMaskIntoConstraints = false
        measurementLbl.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLbl.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
   
    //MARK:Like ViewModel
    var likeButtonTintColor:UIColor{return tweet.didLike ? .red : .lightGray}
    
    var likeButtonImage:UIImage{
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    
}
