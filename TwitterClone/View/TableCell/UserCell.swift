//
//  UserCell.swift
//  TwitterClone
//
//  Created by David Murillo on 6/23/21.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    static var reuseIdentifer = "UserCell"
    
    var user:User?{
        didSet{configure()}
    }
    
    private let profileImageView:UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .twitterBlue
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    private let usernameLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let fullnameLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLbl,fullnameLbl])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor,paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let user = user else {return}
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        usernameLbl.text = user.username
        fullnameLbl.text = user.fullname
    }
    
}
