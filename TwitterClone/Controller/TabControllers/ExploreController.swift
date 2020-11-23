//
//  ExploreController.swift
//  TwitterClone
//
//  Created by David Murillo on 11/21/20.
//

import UIKit

class ExploreController:UIViewController{
    //MARK: Properties
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:Helper
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
    }
    
}
