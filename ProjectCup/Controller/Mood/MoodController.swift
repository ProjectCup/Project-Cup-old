//
//  MoodController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 4/17/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit


class MoodController: UIViewController{

    var entries: [MoodEntry] = []
    let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
    let cellId = "cellId"

    func setupTableViews() {

        tableView.register(MoodEntryTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)

    }

    func createEntry(mood: MoodEntry.Mood, date: Date, moodStory: String?) {
        let newEntry = MoodEntry(mood: mood, date: date, moodStory: moodStory)
        entries.insert(newEntry, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }

    func updateEntry(mood: MoodEntry.Mood, date: Date, at index: Int, moodStory: String?) {
        entries[index].mood = mood
        entries[index].date = date
        entries[index].moodStory = moodStory
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func deleteEntry(at index: Int) {
        entries.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    @objc func newmood() {
        let addmoodController = AddMoodController()
        addmoodController.mood = MoodEntry.Mood.none
        addmoodController.date = Date()
        addmoodController.hidesBottomBarWhenPushed = true
        addmoodController.delegate = self
        navigationController?.pushViewController(addmoodController, animated: true)
    }
//    @objc func savemood() {
//
//        let addmoodController = AddMoodController()
//        let newMood: MoodEntry.Mood = addmoodController.mood
//        let newDate: Date = addmoodController.date
//        if addmoodController.isEditingEntry {
//            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
//                return
//            }
//            updateEntry(mood: newMood, date: newDate, at: selectedIndexPath.row)
//        } else {
//            createEntry(mood: newMood, date: newDate)
//        }
//        navigationController?.popViewController(animated: true)
//
//    }

    //MARK: Override functions

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        let goodEntry = MoodEntry(mood: .good, date: Date(), moodStory: "1")
        let badEntry = MoodEntry(mood: .bad, date: Date(), moodStory: "2")
        let neutralEntry = MoodEntry(mood: .neutral, date: Date(), moodStory: "3")

        entries = [goodEntry, badEntry, neutralEntry]
        tableView.reloadData()

        //
        navigationItem.title = ("Mood")
        setNaviBarItems()
        setupTableViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
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

}

extension MoodController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MoodEntryTableViewCell

        let entry = entries[indexPath.row]
        cell.configure(entry)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = entries[indexPath.row]
        print("Selected mood was \(selectedEntry.mood.stringValue)")

        let addmoodController = AddMoodController()
        addmoodController.mood = selectedEntry.mood
        addmoodController.date = selectedEntry.date
        addmoodController.textField.text = selectedEntry.moodStory
        addmoodController.indexrow = indexPath.row
        addmoodController.isEditingEntry = true
        addmoodController.hidesBottomBarWhenPushed = true
        addmoodController.delegate = self
        navigationController?.pushViewController(addmoodController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteEntry(at: indexPath.row)
        default:
            break
        }
    }
}

extension MoodController: savemoodDelegate {
    func savemood(mood: MoodEntry.Mood!, date: Date!, at: Int?, isEditingEntry: Bool!, moodStory: String?) {
        
        let newMood: MoodEntry.Mood = mood
        let newDate: Date = date
        let newStory: String? = moodStory
        if isEditingEntry == true {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            updateEntry(mood: newMood, date: newDate, at: selectedIndexPath.row, moodStory: newStory)
        } else {
            createEntry(mood: newMood, date: newDate, moodStory: newStory)
        }
        navigationController?.popViewController(animated: true)
    }
}



