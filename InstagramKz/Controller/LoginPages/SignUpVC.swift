//
//  SignUpVC.swift
//  InstagramKz
//
//  Created by rau4o on 8/10/19.
//  Copyright © 2019 rau4o. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imageSelected = false
    
    let plusPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    let alreadyHaveAnAccount: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureViewComponents()
        
        view.addSubview(alreadyHaveAnAccount)
        alreadyHaveAnAccount.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //selected image
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        
        //set imageSelected to true
        imageSelected = true
        
        //configure photoPlus button with selected image
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        plusPhotoBtn.layer.borderWidth = 2
        plusPhotoBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectProfilePhoto() {
        //configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        //present
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        
        //properties
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            //handle error
            if let error = error {
                print("failed to create user",error.localizedDescription)
                return
            }
            //set profile image
            guard let profileImage = self.plusPhotoBtn.imageView?.image else {return}
            
            //upload data
            guard let uploadData = profileImage.jpegData(compressionQuality: 0.3) else {return}
            
            let filename = UUID().uuidString
            
            // UPDATE: - In order to get download URL must add filename to storage ref like this
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("Faild faild fiald fials ",error.localizedDescription)
                    return
                }
                // UPDATE: - Firebase 5 must now retrieve download url
                storageRef.downloadURL(completion: { (downloadUrl, error) in
                    guard let profileImageUrl = downloadUrl?.absoluteString else{
                        print("profile image is nil")
                        return
                    }
                    
                    //user id
                    guard let uid = authResult?.user.uid else {return}
                    
                    let dictionaryValues = ["name": fullname,
                                            "username": username,
                                            "profileImageUrl": profileImageUrl]
                    
                    let values = [uid: dictionaryValues]
                    
                    //save user in database
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print("error big",error.localizedDescription)
                        }
                        print("Success")
                    })
                })
            })
        }
    }
    
    @objc func formValidation() {
        
        guard
            emailTextField.hasText,
            passwordTextField.hasText,
            fullNameTextField.hasText,
            usernameTextField.hasText,
            imageSelected == true else {
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    func configureViewComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,fullNameTextField,usernameTextField,passwordTextField,signUpButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
    }
    
}

