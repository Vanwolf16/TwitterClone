//
//  TweetCell.swift
//  TwitterClone
//
//  Created by David Murillo on 6/20/21.
//

import UIKit

protocol TweetCellDelegate:AnyObject {
    func handleProfileImageTapped(_ cell:TweetCell)
    func handleReplayTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell:TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    weak var delegate:TweetCellDelegate?
    
    var tweet:Tweet?{
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
    
    private let captionLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Some Caption Tweet"
        return label
    }()
    
    private let infoLbl = UILabel()
    
    //MARK:ButtonLayout
    
    private lazy var commentButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top:topAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 8)
        
        
        let stack = UIStackView(arrangedSubviews: [infoLbl,captionLbl])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top:profileImageView.topAnchor,left: profileImageView.rightAnchor,right: rightAnchor,
                     paddingLeft: 12,paddingRight: 12)
        infoLbl.font = UIFont.systemFont(ofSize: 14)
        infoLbl.text = "David Murillo @Vanwolf"
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left:leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 1)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom:bottomAnchor,paddingBottom: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:Selector
    @objc func handleProfileImageTapped(){
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped(){
        delegate?.handleReplayTapped(self)
    }
    
    @objc func handleRetweetTapped(){
        print("Retweet")
    }
    
    @objc func handleLikeTapped(){
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped(){
        print("Share")
    }
    
    func configure(){
        guard let tweet = tweet else {return}
        let viewModel = TweetViewModel(tweet: tweet)
        captionLbl.text = tweet.caption
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLbl.attributedText = viewModel.userInfoTxt
        
        
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
    }
    
}
