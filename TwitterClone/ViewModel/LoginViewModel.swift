//
//  LoginViewModel.swift
//  TwitterClone
//
//  Created by David Murillo on 6/15/21.
//

import UIKit

struct LoginViewModel{
    var email:String?
    var password:String?
    //make sure it is not empty
    var formIsValid:Bool{
        return email?.isEmpty == false &&
            password?.isEmpty == false
    }
    
}
