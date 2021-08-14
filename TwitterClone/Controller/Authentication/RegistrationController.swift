//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by David Murillo on 6/14/21.
//

import UIKit

class RegistrationController: UIViewController,UINavigationControllerDelegate{

    private var profileImage:UIImage?
    
    private let plusPhotoBtn:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let userNameField = CustomTextField(placeholder: "Username")
    private let fullNameField = CustomTextField(placeholder: "FullName")
    
    private let emailTxtField = CustomTextField(placeholder: "Email")
    
    private let passwordTxtField:CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var emailContainerView:InputContainerView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        return InputContainerView(image: image, textField: emailTxtField)
    }()
    
    private lazy var passwordContainerView:InputContainerView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        return InputContainerView(image: image, textField: passwordTxtField)
    }()
    
    private lazy var fullContainerView:InputContainerView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameField)
    }()
    
    private lazy var usernameContainerView:InputContainerView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: userNameField)
    }()
    
    private let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(handleSignUpRegister), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton:UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log In!", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObserver()
    }
    
    //MARK: Helper
    func configureUI(){
       // self.configureGradientLayer()
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        
        //PlusPhoto
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.centerX(inView: view)
        plusPhotoBtn.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        plusPhotoBtn.setDimensions(width: 200, height: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,fullContainerView,usernameContainerView,signUpButton])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:plusPhotoBtn.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left:view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 32,paddingBottom: 16,
                                     paddingRight: 32)
        
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Selector
   @objc func handleSelectPhoto(){
        let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    present(imagePickerController, animated: true, completion: nil)
   }
    
    @objc func handleSignUp(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUpRegister(){
        guard let profileImage = profileImage else {
            print("Please select image")
            return
        }
        
        guard let email = emailTxtField.text, let password = passwordTxtField.text,
              let fullname = fullNameField.text,let username = userNameField.text else {return}
        
        let crendtials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: crendtials) { error, ref in
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            guard let tab = window.rootViewController as? MainTabController
            else {return}
            //Setup the UI
            tab.authenicateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
        
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
//MARK: ImagePickerControllerDelegate
extension RegistrationController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoBtn.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoBtn.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        plusPhotoBtn.layer.borderWidth = 3.0
        plusPhotoBtn.layer.cornerRadius = 200 / 2
        plusPhotoBtn.imageView?.contentMode = .scaleAspectFill
        
        
        dismiss(animated: true, completion: nil)
    }
}



