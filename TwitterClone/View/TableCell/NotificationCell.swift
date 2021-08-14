//
//  NotificationCell.swift
//  TwitterClone
//
//  Created by David Murillo on 7/22/21.
//

import UIKit

protocol NotificationCellDelegate:AnyObject{
    func didTapProfileImage(_ cell:NotificationCell)
    func didTapFollow(_ cell:NotificationCell)
}

class NotificationCell: UITableViewCell {

    weak var delegate:NotificationCellDelegate?
    
    var notification:Notification?{
        didSet{configure()}
    }
    
    //MARK:Properties
    private lazy var profileImageView:UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        iv.isUserInteractionEnabled = true
        
        //Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let notificationLbl:UILabel = {
       let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Some test Notification"
        return label
    }()
    
    private lazy var followBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [profileImageView,notificationLbl])
        stack.spacing = 8
        stack.alignment = .center
        
        contentView.addSubview(stack)
        stack.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        stack.anchor(right:rightAnchor,paddingRight: 12)
        
        addSubview(followBtn)
        followBtn.centerY(inView: self)
        followBtn.setDimensions(width: 92, height: 32)
        followBtn.layer.cornerRadius = 32 / 2
        followBtn.anchor(right:rightAnchor,paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:Selector
    @objc func handleProfileImageTapped(){
        delegate?.didTapProfileImage(self)
    }
    
    @objc func handleFollow(){
        delegate?.didTapFollow(self)
    }
    
    func configure(){
        guard let notification = notification else {return}
        let viewModel = NotificationViewModel(notification: notification)
        
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLbl.attributedText = viewModel.notificationText
        
        followBtn.isHidden = viewModel.shouldHideFollowButton
        followBtn.setTitle(viewModel.followButtonText, for: .normal)
    }
    
}
