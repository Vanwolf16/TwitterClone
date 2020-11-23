//
//  NotificationController.swift
//  TwitterClone
//
//  Created by David Murillo on 11/21/20.
//

import UIKit

class NotificationController:UIViewController{
    //MARK: Properties
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:Helper
    //MARK:Helper
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
    }
    
}
