//
//  RegisterController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 1/19/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class RegisterController: UIViewController, UITextFieldDelegate {
    
    private let errorMessage = UILabel()

    
    var userAnswer : [[String]] = []
    var userName : String = ""
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    var RegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Sign Up", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25

        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        return button
    }()
    
    var BackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Back", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        return button
    }()

    @objc func goBack() {
        let vc = buttonView()
        present(vc, animated: true, completion: nil)
    }
    
    func setupErrorMessage() {
        
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        errorMessage.text = "Error"
        errorMessage.textColor = .red
        errorMessage.isHidden = true
        
        NSLayoutConstraint.activate([
            errorMessage.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 5),
            errorMessage.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 10.0), errorMessage.bottomAnchor.constraint(equalTo: RegisterButton.topAnchor, constant: -10.0)
            ])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputsContainerView.layer.borderWidth = 0
        errorMessage.isHidden = true
    }
    
    
    @objc func handleRegister() {
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text
            else {
            print("Form is not valid")
            return
        }
        
        if isValidEmail(testStr: email) == false {
            errorMessage.isHidden = false
            errorMessage.text = "Email is not valid"
            return
        }
        
        if passwordTextField.text == confirmpasswordTextField.text {

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            let values = ["name": self.userName, "email": email, "password": password] as [String : Any]
            //successfully authenticated user
            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])

        })
            
        } else {
            inputsContainerView.layer.borderWidth = 1.0
            inputsContainerView.layer.borderColor = UIColor.red.cgColor
            errorMessage.isHidden = false
            errorMessage.text = "Passwords don't match"
            print("pws dont match")
            return
        }
    }
    
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            let timestamp = Int(Date().timeIntervalSince1970)
            let usersJournal = ref.child("journal").child(uid).child("\(timestamp)")
            let journalValues = ["Answer1": self.userAnswer[0], "Answer2": self.userAnswer[1], "Answer3": self.userAnswer[2]] as [String: Any]
            usersJournal.updateChildValues(journalValues, withCompletionBlock: {(err, ref) in
                if err != nil{
                    print(err!)
                    return
                }
                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in

                    if err != nil {
                        print(err!)
                        return
                    }

                    self.finishRegister()
                })
                for choice in self.userAnswer[0] {
                    let choiceReference = ref.child("answers").child(choice).child(uid)
                    choiceReference.setValue(1)
                }
            })
        }
    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func finishRegister() {
        let tabbarController = TabBarController()
        present(tabbarController, animated: true, completion: nil)
        
        UserDefaults.standard.setIsLoggedIn(value: true)
        }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let confirmpasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CUP logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(profileImageView)
        view.addSubview(inputsContainerView)
        view.addSubview(RegisterButton)
        view.addSubview(BackButton)
        view.addSubview(errorMessage)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmpasswordTextField.delegate = self
        
        setupProfileImageView()
        setupInputsContainerView()
        setupRegisterButton()
        setupBackButton()
        setupErrorMessage()

    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var confirmpasswordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
//        inputsContainerView.addSubview(nameTextField)
//        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(confirmpasswordTextField)
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        confirmpasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        confirmpasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        
        confirmpasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        confirmpasswordTextFieldHeightAnchor = confirmpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        confirmpasswordTextFieldHeightAnchor?.isActive = true
    }
    
    
    func setupRegisterButton() {
        
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.topAnchor.constraint(equalTo: errorMessage.bottomAnchor, constant: 12).isActive = true
        RegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupBackButton() {
        
        BackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        BackButton.topAnchor.constraint(equalTo: RegisterButton.bottomAnchor, constant: 12).isActive = true
        BackButton.widthAnchor.constraint(equalTo: RegisterButton.widthAnchor).isActive = true
        BackButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
