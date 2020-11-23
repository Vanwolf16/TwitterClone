//
//  FeedController.swift
//  TwitterClone
//
//  Created by David Murillo on 11/21/20.
//

import UIKit

class FeedController:UIViewController{
    //MARK: Properties
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:Helper
    func configureUI(){
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
    }
    
}
