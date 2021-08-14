//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by David Murillo on 6/22/21.
//

import UIKit

protocol ProfileHeaderDelegate:AnyObject {
    func handleDismissal()
    func handleEditProfileFollow(_ header:ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    weak var delegate:ProfileHeaderDelegate?
    
    var user:User?{
        didSet{configure()}
    }
    
    static var reuseHeaderID = "ProfileHeader"
    //MARK:Properties
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView:UIView = {
       let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top:view.topAnchor,left: view.leftAnchor,
                          paddingTop: 42,paddingLeft: 16)
        backButton.setDimensions(width: 40, height: 40)
        return view
    }()
    
    private lazy var backButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView:UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editProfileFollowBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
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
    
    private let bioLbl:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio it will span big"
        return label
    }()
    
    private let underlineView:UIView = {
       let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLbl:UILabel = {
       let label = UILabel()
        label.text = "0 Following"
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let followersLbl:UILabel = {
       let label = UILabel()
        label.text = "2 Follower"
        
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowerTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    //MARK:Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Get User Data
        
        addSubview(containerView)
        containerView.anchor(top:topAnchor,left: leftAnchor,right: rightAnchor,height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top:containerView.bottomAnchor,left: leftAnchor,paddingTop: -24,paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowBtn)
        editProfileFollowBtn.anchor(top:containerView.bottomAnchor,right: rightAnchor,paddingTop: 12,paddingRight: 12)
        editProfileFollowBtn.setDimensions(width: 100, height: 36)
        editProfileFollowBtn.layer.cornerRadius = 36 / 2
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLbl,usernameLbl,bioLbl])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        
        addSubview(userDetailStack)
        userDetailStack.anchor(top:profileImageView.bottomAnchor,left: leftAnchor,
                               right: rightAnchor,paddingTop: 8,paddingLeft: 12,paddingRight: 12)
        
        
        let followStack = UIStackView(arrangedSubviews: [followingLbl,followersLbl])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top:userDetailStack.bottomAnchor,left: leftAnchor,paddingTop: 8
        ,paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.delegate = self
        filterBar.anchor(left:leftAnchor,bottom: bottomAnchor,right: rightAnchor,height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left:leftAnchor,bottom: bottomAnchor,width: frame.width / 3,height: 2)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:Helper
    func configure(){
        guard let user = user else {return}
        let viewModel = ProfileHeaderViewModel(user: user)
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        
        followingLbl.attributedText = viewModel.followingString
        followersLbl.attributedText = viewModel.followersString
        
        editProfileFollowBtn.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        fullnameLbl.text = user.fullname
        usernameLbl.text = "@" + user.username.lowercased()
        
    }
    //MARK:Selector
    @objc func handleDismissal(){
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileFollow(){
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingTapped(){
        
    }
    
    @objc func handleFollowerTapped(){
        
    }
    
}
//MARK: ProfileFilterDelegate
extension ProfileHeader:ProfileFilterViewDelegate{
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell
        else {return}
        
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
        
    }
    
    
}
