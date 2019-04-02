//
//  MainPageController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 3/1/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TabBarController: UITabBarController {
    
//    let tbController = UITabBarController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = UIColor.blue
        createTabBarController()
        checkIfUserIsLoggedIn()

    }
    
    func createTabBarController() {
        
        
        let layout = UICollectionViewLayout()
        let homepageController = HomeController(collectionViewLayout: layout)
        let firstnavigationController = UINavigationController(rootViewController: homepageController)
        firstnavigationController.title = "Home"
        firstnavigationController.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "Home"), tag: 1)

        
        let messagesController = MessagesController()
        let secondnavigationController = UINavigationController(rootViewController: messagesController)
        secondnavigationController.title = "Messages"
        secondnavigationController.tabBarItem = UITabBarItem.init(title: "Messages", image: UIImage(named: "Messages"), tag: 2)

        
        
        viewControllers = [firstnavigationController, secondnavigationController]
//        self.view.addSubview(tbController.view)
        
        
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//        self.view.addGestureRecognizer(swipeRight)
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
//    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
//        if gesture.direction == .left {
//            if (self.tabBarController?.selectedIndex)! < 2 { // set your total tabs here
//                self.tabBarController?.selectedIndex += 1
//            }
//        } else if gesture.direction == .right {
//            if (self.tabBarController?.selectedIndex)! > 0 {
//                self.tabBarController?.selectedIndex -= 1
//            }
//        }
//    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            //nothing
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
}
