//
//  FeedController.swift
//  TwitterClone
//
//  Created by David Murillo on 6/14/21.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Cell"


class FeedController: UICollectionViewController {
    var user:User?{
        didSet{
            configureLeftBarButton()
        }
    }
    
    var tweets = [Tweet](){
        didSet{collectionView.reloadData()}
    }
    
    //MARK:Properties
    
    
    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
        
    }
    
    //MARK:API
    func fetchTweets(){
        TweetService.shared.fetchTweets {[weak self] tweets in
            self?.tweets = tweets
            self?.checkIfUserLikedTweets(tweets)
        }
    }
    
    func checkIfUserLikedTweets(_ tweets:[Tweet]){
        for(index,tweet) in tweets.enumerated(){
            TweetService.shared.checkIfUserLikeTweet(tweet) { didLike in
                guard didLike == true else {return}
                self.tweets[index].didLike = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:Helper
    func configureUI(){
       // view.backgroundColor = .white
        setUpCollectionView()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        configureLeftBarButton()
        
    }
    
    func setUpCollectionView(){
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    func configureLeftBarButton(){
        guard let user = user else {return}
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.sd_setImage(with: URL(string: user.profileImageUrl))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
}

//MARK: Delegate & Datasource
extension FeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension FeedController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 70)
    }
}

extension FeedController:TweetCellDelegate{
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        
        TweetService.shared.likeTweet(tweet: tweet) { err, ref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            //Notifiaction for Likes
            guard !tweet.didLike else {return}
            NotificationService.shared.uploadNotification(type: .like,tweet: tweet)
        }
        
    }
    
    func handleReplayTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        let controller = UploadTweetController(user: tweet.user, config: .replay(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
