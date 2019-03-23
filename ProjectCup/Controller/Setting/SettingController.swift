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
import MessageUI

class SettingController : UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
//    private lazy var setting: [SettingCellModel] = {
//        let setting = SettingCellModel.loadsettingModels()
//        return setting
//    }()
        
    let tableView = UITableView()
    
    var LogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 171, g: 234, b: 190)
        button.setTitle("Logout", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.backgroundColor = UIColor.green
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        let footerView = UIView()
        footerView.addSubview(LogoutButton)
        tableView.tableFooterView = footerView
        
        
        setupTableViews()
        setupLogoutButton()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return 4
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
        if 0 == indexPath.section {
            if 0 == indexPath.row {
                cell.textLabel?.text = "Change Email/Password"
            } else if 1 == indexPath.row {
                cell.textLabel?.text = "Delete All Data"
            } else if 2 == indexPath.row {
                cell.textLabel?.text = "Terms and Conditions"
            } else {
                cell.textLabel?.text = "Frequently Asked Questions"
            }
                
        } else if 1 == indexPath.section {
            if 0 == indexPath.row {
                cell.textLabel?.text = "Refer A Friend"
            } else if 1 == indexPath.row {
                cell.textLabel?.text = "Rate"
            } else {
                cell.textLabel?.text = "Feedback"
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if 0 == indexPath.section {
            if 0 == indexPath.row {
                let changeVC = ChangeController()
                navigationController?.pushViewController(changeVC, animated: true)
                print("Change PW")
            } else if 1 == indexPath.row {
                let deleteVC = DeleteController()
                navigationController?.pushViewController(deleteVC, animated: true)
                print("Delete")
            } else if 2 == indexPath.row {
                let termVC = TermsController()
                navigationController?.pushViewController(termVC, animated: true)
                print ("Terms and Conditions")
            } else {
                let faqVC = FAQController()
                navigationController?.pushViewController(faqVC, animated: true)
                print ("Questions")
            }
        } else if 1 == indexPath.section {
            if 0 == indexPath.row {
                refer((Any).self)
                print ("refer")
            } else if 1 == indexPath.row {
                self.gotoAppStore()
                print ("Rate")
            } else {
                feedback()
                print ("Feedback")
            }
        }
    }
    
    func gotoAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/id..."
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:]) { (opened) in
            if(opened) {
                print ("Opened")
            } else {
                print ("Go App Store Failed")
            }
        }
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
        self.finishLogout()
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func refer(_ sender: Any) {
        
        let text = "Let's join"
        let objectstoshare:[Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: objectstoshare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.setValue("Let's join", forKey: "subject")
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func feedback() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let feedbackVC = MFMailComposeViewController()
        feedbackVC.mailComposeDelegate = self
        feedbackVC.setToRecipients(["xyystartup@gmail.com"])
        feedbackVC.setSubject("Hello")
        feedbackVC.setMessageBody("", isHTML: false)
        
        self.present(feedbackVC, animated: true, completion: nil)
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
    func finishLogout() {
        //change locally the login status of the user
        UserDefaults.standard.set(false, forKey: "status")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingController = SwipingController(collectionViewLayout: layout)
        present(swipingController, animated: true, completion: nil)
                
    }

}



