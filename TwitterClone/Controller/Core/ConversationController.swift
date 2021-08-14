//
//  ConversationController.swift
//  TwitterClone
//
//  Created by David Murillo on 6/14/21.
//

import UIKit

class ConversationController: UIViewController {

    //MARK:Properties
    
    
    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:Helper
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Conversation"
    }
}
