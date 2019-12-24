//
//  ChangePref.swift
//  ProjectCup
//
//  Created by Sailung Yeung on 10/11/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import ViewAnimator
import Firebase


class ChangePrefViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    private var items = [String?]()
    private var choiceList: [String] = []
    

    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "DUMMY_TAG"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    var ConfirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Confirm", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(Confirm), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
        collectionView?.backgroundColor = .white
        collectionView?.register(MultiCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.allowsMultipleSelection = true
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        checkIfUserIsLoggedIn()
        view.addSubview(resultsLabel)
        view.addSubview(ConfirmButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultsLabel.frame.size = CGSize(width: 300, height: 100)
        resultsLabel.center = CGPoint(x: view.bounds.midX, y: 130)
        ConfirmButton.frame.size = CGSize(width: 350, height: 50)
        ConfirmButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 175)
    }
    
    private func getChoices(uid: String){
        let ref = Database.database().reference()
        ref.child("choices").observeSingleEvent(of: .value, with: {(snapshot) in
            let choices = snapshot.value as! String
            let array = choices.components(separatedBy: " ")
            self.items = array
            self.loadList(arr: array)
        }){(error) in
            print(error.localizedDescription)
        }
        ref.child("user-categories").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let selected = snapshot.value as? [String: AnyObject]{
                let userChoices = UserChoices(dictionary: selected)
                self.collectionView?.orderedVisibleCells.forEach{ cell in
                    let c = cell as! MultiCollectionViewCell
                    if userChoices.words.contains(c.choiceLabel.text!) {
                        let indexPath = IndexPath(indexes: [0, self.items.index(of: c.choiceLabel.text!)!])
                        self.collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: [])
                    }
                }
            }


        }){(error) in
            print(error.localizedDescription)
        }
    }
    
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                //for some reason uid = nil
                return
            }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User(dictionary: dictionary)
                    self.resultsLabel.text = "Hi " + user.name! + ", please select the topic you want to talk about"
                    self.getChoices(uid: uid)
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout() {
        
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
    
    @objc func Confirm() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        getCellSelection()
        ref.child("user-categories").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            if let selected = snapshot.value as? [String: AnyObject]{
                let userChoices = UserChoices(dictionary: selected)
                print(userChoices.words)
                for changes in userChoices.words {
                    let choiceReference = ref.child("categories").child(changes!).child(uid!)
                    choiceReference.removeValue()
                    let journalReference = ref.child("user-categories").child(uid!).child(changes!)
                    journalReference.removeValue()
                }
                print(self.choiceList)
                for choice in self.choiceList {
                    let choiceReference = ref.child("categories").child(choice).child(uid!)
                    choiceReference.setValue(1)
                    let journalReference = ref.child("user-categories").child(uid!).child(choice)
                    journalReference.setValue(1)
                 }
                self.choiceList.removeAll()
                self.getChoices(uid: uid!)
                self.showSimpleAlert()
            }
            
        }){(error) in
            print(error.localizedDescription)
        }

        return
    }
    
    private func showSimpleAlert() {
        let alert = UIAlertController(title: "Success!", message: "Your topic preference has been changed successfully!",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func getCellSelection(){
        self.collectionView?.orderedVisibleCells.forEach{ cell in
            let c = cell as! MultiCollectionViewCell
            if cell.isSelected{
                choiceList.append(c.choiceLabel.text!)
            }
        }
    }
    
    private func loadList(arr: [String]){
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
        items = arr
        collectionView?.reloadData()
        collectionView?.performBatchUpdates({
            UIView.animate(views: self.collectionView!.orderedVisibleCells,
                           animations: [zoomAnimation, rotateAnimation], completion: nil)
        }, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)as! MultiCollectionViewCell
        cell.choiceLabel.text = items[indexPath.row]
        cell.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 150.0,left: 30.0,bottom: 50.0,right: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
