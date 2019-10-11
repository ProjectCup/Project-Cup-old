//
//  HomeController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 3/2/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var articles = ["1", "2"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setupCollectionView()
        
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: "cellId")
        
        setNaviBaritems()
//        getArticle()

    }
    
    private func setNaviBaritems() {
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "cupv1"))
        
//        let settingButton = UIButton(type: .system)
//        settingButton.setImage(UIImage(named: "Setting"), for: .normal)
//        settingButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        settingButton.addTarget(self, action: #selector(gotoSetting), for: .touchUpInside)
//
//        let settingBarItem = UIBarButtonItem(customView: settingButton)
//        settingBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        settingBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
//        self.navigationItem.leftBarButtonItem = settingBarItem

    }
    

    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView?.setCollectionViewLayout(layout, animated: false)
        
        collectionView?.backgroundColor = UIColor.white

        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)

    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! HomeCell
        cell.image = UIImage(named: articles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = ContentController()
        content.article = articles[indexPath.row]
        
        self.navigationController?.pushViewController(content, animated: true)
    }
    
//    @objc func gotoSetting(){
//        let settingController = SettingController()
//        let navController = UINavigationController(rootViewController: settingController)
//        present(navController, animated: true, completion: nil)
//    }
    
//    func getArticle() {
//        let ref = Database.database().reference().child("Article").child("article")
//        ref.observe(.childAdded, with: { snapshot in
//                let dictionary = snapshot.value as? String
//            self.articles.append(dictionary!)
//
//            })
//
//    }
    
}
