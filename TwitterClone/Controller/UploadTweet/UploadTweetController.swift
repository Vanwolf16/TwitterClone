//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by David Murillo on 6/17/21.
//

import UIKit
import SDWebImage



class UploadTweetController: UIViewController {
    
    private let user:User
    private let config:UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    init(user:User,config:UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Properties
    
    private lazy var actionButton:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView:UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        return iv
    }()
    
    private lazy var replayLbl:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch config {
        case .tweet:
            print("Tweet")
        case .replay(let tweet):
            print("Replay to: \(tweet.caption)")
        }
        
    }
    
    //MARK:API
    
    //MARK: Helper
    func configureUI(){
        view.backgroundColor = .white
       configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replayLbl,imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
       stack.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,
                     paddingTop: 16,paddingLeft: 16,paddingRight: 16)
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        
        //ViewModel Set Up
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeholderLbl.text = viewModel.placeholderText
        replayLbl.isHidden = !viewModel.shouldShowReplayLbl
        guard let replayText = viewModel.replayTxt else {return}
        replayLbl.text = replayText
        
    }
    
    
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    //MARK:Selector
    
    @objc func handleUploadTweet(){
        guard let caption = captionTextView.text else {return}
        TweetService.shared.uploadTweet(caption: caption, type: config) {[weak self] error, ref in
            if let error = error{
                print("ERROR: Data didn't upload: \(error.localizedDescription)")
                return
            }
            
            if case .replay(let tweet) = self?.config{
                NotificationService.shared.uploadNotification(type: .replay,tweet: tweet)
            }
            
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}
