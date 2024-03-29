//
//  TweetController.swift
//  TwitterClone
//
//  Created by David Murillo on 7/16/21.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let reuseTweetHeader = "TweetHeader"

class TweetController: UICollectionViewController {

    //MARK:Properties
    private let tweet:Tweet
    private var actionSheetLauncher:ActionSheetLauncher!
    
    private var replies = [Tweet](){
        didSet{collectionView.reloadData()}
    }
    
    //MARK:Lifecycle
    
    init(tweet:Tweet){
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    //MARK:API
    func fetchReplies(){
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }
    
    //MARK:Helper
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseTweetHeader)
        
    }
    
    //MARK:Selector
}
//MARK:Delegate and Datasource
extension TweetController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseTweetHeader, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
    
}
//MARK:TweetController FlowLayout Delegate
extension TweetController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}

extension TweetController:TweetHeaderDelegate{
    func showActionSheet() {
        if tweet.user.isCurrentUser{
            actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
            actionSheetLauncher.delegate = self
            actionSheetLauncher.show()
            
        }else{
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.actionSheetLauncher = ActionSheetLauncher(user: user)
                self.actionSheetLauncher.delegate = self
                self.actionSheetLauncher.show()
            }
        }
    }
    
    
}


extension TweetController:ActionSheetLauncherDelegate{
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { err, ref in
                print("Did Follow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                print("unfollow user \(user.username)")
            }
        case .report:
            print("Report Tweet")
        case .delete:
            print("Delete Tweet")
        }
    }
    
    
}
