//
//  testNewMessageContronller.swift
//  ProjectCup
//
//  Created by younith on 1/22/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import Firebase

class testNewMessageController: UIViewController {
    
    var OptionAButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("School", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        
        return button
    }()
    
    var OptionBButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Family", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        
        return button
    }()
    
    var OptionCButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Relationship", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleMatch), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleMatch() {
        
        // MATCH MATCH MATCH
    }
    
    let questionLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CupLogo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        view.backgroundColor = UIColor.gray
        
        view.addSubview(questionLabel)
        view.addSubview(OptionAButton)
        view.addSubview(OptionBButton)
        view.addSubview(OptionCButton)
        
        setupQuestionLabel()
        setupOptionAButton()
        setupOptionBButton()
        setupOptionCButton()
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupQuestionLabel() {
        //need x, y, width, height constraints
        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        questionLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupOptionAButton() {
        //need x, y, width, height constraints
        OptionAButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        OptionAButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 12).isActive = true
        OptionAButton.widthAnchor.constraint(equalTo: questionLabel.widthAnchor).isActive = true
        OptionAButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupOptionBButton() {
        
        OptionBButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        OptionBButton.topAnchor.constraint(equalTo: OptionAButton.bottomAnchor, constant: 12).isActive = true
        OptionBButton.widthAnchor.constraint(equalTo: OptionAButton.widthAnchor).isActive = true
        OptionBButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupOptionCButton() {
        
        OptionCButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        OptionCButton.topAnchor.constraint(equalTo: OptionBButton.bottomAnchor, constant: 12).isActive = true
        OptionCButton.widthAnchor.constraint(equalTo: OptionBButton.widthAnchor).isActive = true
        OptionCButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
