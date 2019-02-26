//
//  MainNavigationController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 2/4/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if isLoggedIn() {
            //assume user is logged in
            let messagesController = MessagesController()
            viewControllers = [messagesController]
        } else {
            perform(#selector(showIntroPages), with: nil, afterDelay: 0.01)
        }
        
    }
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showIntroPages(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let swipingController = SwipingController(collectionViewLayout: layout)
        setNavigationBarHidden(true, animated: false)
        viewControllers = [swipingController]
    }
    
}

