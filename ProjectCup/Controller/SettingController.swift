//
//  SettingController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 1/27/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    var LogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Logout", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    var settingcells = ["Change Passwords", "Delete all data", "Language", "Frequently asked questions", "Refer a friend", "Rate", "Feedback"]
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        let footerView = UIView()
        footerView.addSubview(LogoutButton)
        tableView.tableFooterView = footerView
        
        
        setupTableViews()
        setupLogoutButton()
        checkIfUserIsLoggedIn()
    }

    
    func setupTableViews() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        
        view.addSubview(tableView)
        view.addSubview(LogoutButton)
        
        tableView.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: LogoutButton.topAnchor, constant: 100).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
    func setupLogoutButton() {
        //need x, y, width, height constraints
        LogoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LogoutButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 12).isActive = true
        LogoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        LogoutButton.widthAnchor.constraint(equalTo: tableView.widthAnchor, constant: -24).isActive = true
        LogoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            }, withCancel: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingcells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = settingcells[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(CellController(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }


}

