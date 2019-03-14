//
//  File.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 2/9/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ChangeController: UIViewController, UITextFieldDelegate {
    
    private let errorMessage = UILabel()

    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Confirm", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleEmailpw), for: .touchUpInside)
        
        return button
    }()
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            print("user logged in")
        }
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = UINavigationController(rootViewController: LoginController())
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleEmailpw() {


        if emailpwSegmentedControl.selectedSegmentIndex == 0 {
            handleEmail()
        } else {
            handlePW()
        }
    }
    
    
    
    func handleEmail() {
        print("email")
        guard let email = emailTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        if isValidEmail(testStr: email) == false {
            inputsContainerView.layer.borderWidth = 1.0
            inputsContainerView.layer.borderColor = UIColor.red.cgColor
            errorMessage.isHidden = false
            errorMessage.text = "Email is not valid"
            return
        }
        
        if emailTextField.text == confirmemailTextField.text {
            
            Auth.auth().currentUser?.updateEmail(to: email , completion: { (error) in
                if error != nil {
                    print(error!)
                    return
                }
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child(Auth.auth().currentUser!.uid)
                usersReference.updateChildValues(["email" : email ], withCompletionBlock: {(error, reference)   in
                    
                    if error == nil{
                        print(reference)
                    }else{
                        print(error?.localizedDescription)
                    }
                })
            })
        } else {
            inputsContainerView.layer.borderWidth = 1.0
            inputsContainerView.layer.borderColor = UIColor.red.cgColor
            errorMessage.isHidden = false
            errorMessage.text = "Emails don't match"
            print("emails dont match")
            return
        }

    }
        
    func handlePW () {
        print ("pw")
        // Need to add old password auth
        let newpassword = newpasswordTextField.text
        
        if newpasswordTextField.text == confirmpasswordTextField.text {
            
            Auth.auth().currentUser?.updatePassword(to: newpasswordTextField.text!, completion: { (error) in
                if error != nil {
                    print(error!)
                    return
                }
                let ref = Database.database().reference()
                let usersReference = ref.child("users").child(Auth.auth().currentUser!.uid)
                usersReference.updateChildValues(["password" : newpassword! ], withCompletionBlock: {(error, reference)   in
                    
                    if error == nil{
                        print(reference)
                    }else{
                        print(error?.localizedDescription)
                    }
                })
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
    
    func isValidEmail(testStr:String) -> Bool {
        
        print("validate emilId: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func setupErrorMessage() {
        
        errorMessage.translatesAutoresizingMaskIntoConstraints = false
        errorMessage.text = "Error"
        errorMessage.textColor = .red
        errorMessage.isHidden = true
        
        NSLayoutConstraint.activate([
            errorMessage.leadingAnchor.constraint(equalTo: inputsContainerView.leadingAnchor, constant: 5),
            errorMessage.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 10.0), errorMessage.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -10.0)
            ])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputsContainerView.layer.borderWidth = 0
        errorMessage.isHidden = true
    }
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "New Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.isHidden = true
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let confirmemailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.isHidden = true
        return tf
    }()
    
    
    let newpasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "New Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let newpasswordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
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
    
    let emailpwSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Email", "Password"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleEmailpwChange), for: .valueChanged)
        return sc
    }()
    
    
    
    @objc func handleEmailpwChange() {
        
        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = emailpwSegmentedControl.selectedSegmentIndex == 0 ? 150 : 150
        
        // change height of nameTextField
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: emailpwSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 0)
        emailTextFieldHeightAnchor?.isActive = true
        emailTextField.isHidden = emailpwSegmentedControl.selectedSegmentIndex == 1
        
        
        confirmemailTextFieldHeightAnchor?.isActive = false
        confirmemailTextFieldHeightAnchor = confirmemailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: emailpwSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 0)
        confirmemailTextFieldHeightAnchor?.isActive = true
        confirmemailTextField.isHidden = emailpwSegmentedControl.selectedSegmentIndex == 1
        
        newpasswordTextFieldHeightAnchor?.isActive = false
        newpasswordTextFieldHeightAnchor = newpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: emailpwSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/2)
        newpasswordTextFieldHeightAnchor?.isActive = true
        newpasswordTextField.isHidden = emailpwSegmentedControl.selectedSegmentIndex == 0
        
        
        confirmpasswordTextFieldHeightAnchor?.isActive = false
        confirmpasswordTextFieldHeightAnchor = confirmpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: emailpwSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/2)
        confirmpasswordTextFieldHeightAnchor?.isActive = true
        confirmpasswordTextField.isHidden = emailpwSegmentedControl.selectedSegmentIndex == 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 204, g: 235, b: 168)
        
        view.addSubview(inputsContainerView)
        view.addSubview(confirmButton)
        view.addSubview(emailpwSegmentedControl)
        view.addSubview(errorMessage)
        
        setupErrorMessage()
        setupInputsContainerView()
        setupConfirmButton()
        setupEmailpwSegmentedControl()
    }
    
    func setupEmailpwSegmentedControl() {
        //need x, y, width, height constraints
        emailpwSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailpwSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        emailpwSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        emailpwSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var confirmemailTextFieldHeightAnchor: NSLayoutConstraint?
    var newpasswordTextFieldHeightAnchor: NSLayoutConstraint?
    var confirmpasswordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(confirmemailTextField)
        inputsContainerView.addSubview(newpasswordTextField)
        inputsContainerView.addSubview(newpasswordSeparatorView)
        inputsContainerView.addSubview(confirmpasswordTextField)
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        confirmemailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        confirmemailTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        confirmemailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        
        confirmemailTextFieldHeightAnchor = confirmemailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        
        confirmemailTextFieldHeightAnchor?.isActive = true
        
        
        //need x, y, width, height constraints
        newpasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        newpasswordTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        newpasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        newpasswordTextFieldHeightAnchor = newpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        newpasswordTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        newpasswordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        newpasswordSeparatorView.topAnchor.constraint(equalTo: newpasswordTextField.bottomAnchor).isActive = true
        newpasswordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        newpasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        confirmpasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        confirmpasswordTextField.topAnchor.constraint(equalTo: newpasswordTextField.bottomAnchor).isActive = true
        
        confirmpasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        confirmpasswordTextFieldHeightAnchor = confirmpasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        confirmpasswordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupConfirmButton() {
        //need x, y, width, height constraints
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: errorMessage.bottomAnchor, constant: 12).isActive = true
        confirmButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
}
