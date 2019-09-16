import Foundation
import UIKit
import Firebase


class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue
        createTabBarController()
        checkIfUserIsLoggedIn()
        selectedIndex = 0
//        self.tabBarButtonZoomedOut()
    }
    
//    func setupaddButton() {
//    menuButton = UIButton(type: .custom)
//    menuButton.setImage(UIImage(named: "New chat"), for: .normal)
//    menuButton.tintColor = UIColor.blue
//    menuButton.backgroundColor = UIColor.white
//        
//    menuButton.translatesAutoresizingMaskIntoConstraints = false
//    menuButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
//    menuButton.heightAnchor.constraint(equalTo: menuButton.widthAnchor).isActive = true
//    
//    tabBar.addSubview(menuButton)
//    menuButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
//    menuButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
//    
//
//}
////        homeButton = UIButton(frame: CGRect(x: 10, y: 0, width: 45, height: 45))
////        var homeButtonFrame = homeButton.frame
////        homeButtonFrame.origin.x = view.bounds.width/2 - homeButtonFrame.size.width/2
////        homeButton.frame = homeButtonFrame
////        homeButton.layer.cornerRadius = homeButtonFrame.height/2
////        homeButton.setImage(UIImage(named: "New chat"), for: .normal)
////        homeButton.addTarget(self, action: #selector(TabBarController.homeButtonClicked(_:)), for: .touchUpInside)
////        self.tabBar.addSubview(homeButton)
////        self.tabBar.bringSubviewToFront(homeButton)
////        view.layoutIfNeeded()
    
    func createTabBarController() {
        
        
        let layout = UICollectionViewLayout()
        let homepageController = HomeController(collectionViewLayout: layout)
        let firstnavigationController = UINavigationController(rootViewController: homepageController)
        firstnavigationController.title = "Home"
        firstnavigationController.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "Home"), tag: 1)
        
        let moodController = MoodController()
        let secondnavigationController = UINavigationController(rootViewController: moodController)
        secondnavigationController.title = "Mood"
        secondnavigationController.tabBarItem = UITabBarItem.init(title: "Mood", image: UIImage(named: "Messages"), tag: 2)
        
        
        let messagesController = MessagesController()
        let thirdnavigationController = UINavigationController(rootViewController: messagesController)
        thirdnavigationController.title = "Messages"
        thirdnavigationController.tabBarItem = UITabBarItem.init(title: "Messages", image: UIImage(named: "Messages"), tag: 4)
        
        let settingController = SettingController()
        let fourthnavigationController = UINavigationController(rootViewController: settingController)
        fourthnavigationController.title = "Setting"
        fourthnavigationController.tabBarItem = UITabBarItem.init(title: "Setting", image: UIImage(named: "Setting"), tag: 5)

        
        
        viewControllers = [firstnavigationController, secondnavigationController, thirdnavigationController,fourthnavigationController]
//        for tabBarItem in tabBar.items! {
//            tabBarItem.title = ""
//            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        }
//        self.view.addSubview(tbController.view)
        
        
    }
    
    
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
