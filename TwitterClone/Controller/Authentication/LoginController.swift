//
//  LoginController.swift
//  TwitterClone
//
//  Created by David Murillo on 6/14/21.
//

import UIKit

protocol AuthenticationDelegate:class{
    func authenticationComplete()
}


class LoginController: UIViewController {
    private var viewModel = LoginViewModel()
    
    //MARK:Properties
    private let logoImageView:UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
    
    private let emailTxtField = CustomTextField(placeholder: "Email")
    
    private let passwordTxtField:CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var emailContainerView:InputContainerView = {
        let image = #imageLiteral(resourceName: "mail")
        return InputContainerView(image: image, textField: emailTxtField)
    }()
    
    private lazy var passwordContainerView:InputContainerView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        return InputContainerView(image: image, textField: passwordTxtField)
    }()
    
    private let dontHaveAccountButton:UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up!", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    private let loginButton:UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.setHeight(height: 50)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    //MARK: Helper
    private func configureUI(){
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        //Logo
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view,topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        //Stack input and button
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:logoImageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 32,paddingBottom: 16,
                                     paddingRight: 32)
        
        emailTxtField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        passwordTxtField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        
    }

    func checkFormStatus(){
        if viewModel.formIsValid{
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:Selector
    @objc func handleLogIn(){
        guard let email = emailTxtField.text,let password = passwordTxtField.text
        else {return}
        AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("Log In Error: \(error.localizedDescription)")
                return
            }
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            guard let tab = window.rootViewController as? MainTabController
            else {return}
            //Setup the UI
            tab.authenicateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender:UITextField){
        if sender == emailTxtField{
            viewModel.email = sender.text
        }else{
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func keyboardWillShow(){
        print("Did Show")
        if view.frame.origin.y == 0{
            self.view.frame.origin.y -= 88
        }
        
    }
    
    @objc func keyboardWillHide(){
        print("No Show")
        if view.frame.origin.y != 0{
            view.frame.origin.y = 0
        }
    }
    
}
