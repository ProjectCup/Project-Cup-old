//
//  MoodController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 4/17/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MoodController: UIViewController{
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
    let cellId = "cellId"
    var journals = [MoodJournal]()
    var journalsDictionary = [String: MoodJournal]()
    
    
    func setupTableViews() {
        
        tableView.register(MoodEntryTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        //
        navigationItem.title = ("Mood")
        setNaviBarItems()
        setupTableViews()
        observerJournal()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func observerJournal() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("Journal").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let jnlId = snapshot.key
//            if let journalId = snapshot.value as? [String: AnyObject] {
//                let jnl = MoodJournal(dictionary: journalId)
//                jnl.journalId = snapshot.key
//                self.journals.append(jnl)
//            }
            
            let journalReference = Database.database().reference().child("Journal").child(uid).child(jnlId)
            
            journalReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let journal = MoodJournal(dictionary: dictionary)
                    journal.setValuesForKeys(dictionary)
                    journal.journalId = jnlId
                    self.journals.append(journal)
//                    if let mood = journal.mood{
//                        self.journalsDictionary[mood] = journal
//                        self.journals = Array(self.journalsDictionary.values)
//                    }
                    self.timer?.invalidate()
                    print("we just canceled our timer")
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    print("schedule a table reload in 0.1 sec")

                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadTable() {
//        self.journals = Array(self.journalsDictionary.values)

        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    @objc func newmood() {
        let addmoodController = AddMoodController()
        addmoodController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addmoodController, animated: true)
    }
    
    private func setNaviBarItems() {
        //right bar item
        
        let addmoodButton = UIButton(type: .system)
        addmoodButton.setImage(UIImage(named: "New chat"), for: .normal)
        addmoodButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        addmoodButton.addTarget(self, action: #selector(newmood), for: .touchUpInside)
        
        let addmoodItem = UIBarButtonItem(customView: addmoodButton)
        addmoodItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        addmoodItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.rightBarButtonItem = addmoodItem
    }
    
    func deleteEntry(at index: Int) {
        journals.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension MoodController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(journals.count)
        return journals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MoodEntryTableViewCell
        let journal = journals[indexPath.row]
        cell.moodjournal = journal
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = journals[indexPath.row]
        print("Selected mood was \(selectedEntry.mood)")
        
        let addmoodController = AddMoodController()
        addmoodController.textField.text = selectedEntry.journal
        addmoodController.mood = selectedEntry.mood
        addmoodController.journalId = selectedEntry.journalId
        addmoodController.dateinputField.text = selectedEntry.time
        addmoodController.hidesBottomBarWhenPushed = true
        addmoodController.isEditingEntry = true
        navigationController?.pushViewController(addmoodController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            let journal = journals[indexPath.row]
            let ref = Database.database().reference().child("Journal").child(uid)
            ref.observe(.childAdded, with: { (snapshot) in
                let journalId = journal.journalId
                let journalReference = Database.database().reference().child("Journal").child(uid).child(journalId!)
                journalReference.removeValue(completionBlock: { (error, ref) in
                    
                    if error != nil {
                        print("Failed to delete journal:", error!)
                        return
                    }
                    self.attemptReloadOfTable()
                })
            }, withCancel: nil)
            deleteEntry(at: indexPath.row)
        default:
            break
        }
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
}
