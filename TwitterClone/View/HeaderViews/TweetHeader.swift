//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by David Murillo on 7/16/21.
//

import UIKit

protocol TweetHeaderDelegate:AnyObject{
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    //MARK: Properties
    
    var tweet:Tweet?{
        didSet{configure()}
    }
    
    weak var delegate:TweetHeaderDelegate?
    
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
    
    private let fullnameLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "David Murillo"
        return label
    }()
    
    private let usernameLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@Van"
        return label
    }()
    
    private let captionLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Some Caption Tweet"
        return label
    }()
    
    private let dateLbl:UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6:33AM - 1/28/2020"
        return label
    }()
    
    private lazy var optionsBtn:UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetsLbl:UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private lazy var likeLbl:UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var statsView:UIView = {
       let view = UIView()
        
        let divider1 = UIView()
        divider1.backgroundColor = .lightGray
        view.addSubview(divider1)
        divider1.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,
                        paddingLeft: 8,height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLbl,likeLbl])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left:view.leftAnchor,paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .lightGray
        view.addSubview(divider2)
        divider2.anchor(left:view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,
                        paddingLeft: 8,height: 1.0)
        
        return view
    }()
    
    //Buttons
    private lazy var commentButton:UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton:UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton:UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton:UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK:Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLbl,usernameLbl])
        labelStack.axis = .vertical
        labelStack.spacing = 5
       
        let stack = UIStackView(arrangedSubviews: [profileImageView,labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top:topAnchor,left: leftAnchor,paddingTop: 16,paddingLeft: 16)
        
        addSubview(captionLbl)
        captionLbl.anchor(top:stack.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 20,paddingLeft: 16,paddingRight: 16)
        
        
        addSubview(dateLbl)
        dateLbl.anchor(top:captionLbl.bottomAnchor,left: leftAnchor,paddingTop: 20,paddingLeft: 16)
        
        addSubview(optionsBtn)
        optionsBtn.centerY(inView: stack)
        optionsBtn.anchor(right:rightAnchor,paddingRight: 9)
        
        addSubview(statsView)
        statsView.anchor(top:dateLbl.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 20,height: 40)
        
        //Button Layout
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actionStack.spacing = 72
       
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom:bottomAnchor,paddingBottom: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:Helper
    func createButton(withImageName imageName:String) -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configure(){
        guard let tweet = tweet else {return}
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLbl.text = tweet.caption
        fullnameLbl.text = tweet.user.fullname
        usernameLbl.text = viewModel.usernameTxt
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLbl.text = viewModel.headerTimeStamp
        retweetsLbl.attributedText = viewModel.retweetAttributedString
        likeLbl.attributedText = viewModel.likesAttributedString
        
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
    }
    
    //MARK:Selector
    @objc func handleCommentTapped(){
        
    }
    
    @objc func handleRetweetTapped(){
        
    }
    
    @objc func handleLikeTapped(){
        
    }
    
    @objc func handleShareTapped(){
        
    }
    
    @objc func handleProfileImageTapped(){
        //delegate?.handleProfileImageTapped(self)
        print("Show User Profile")
    }
    
    @objc func showActionSheet(){
        delegate?.showActionSheet()
    }
    
}
