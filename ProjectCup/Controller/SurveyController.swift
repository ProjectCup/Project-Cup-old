//
//  SurveyController.swift
//  ProjectCup
//
//  Created by Sailung Yeung on 2/3/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

struct Question {
    var questionString: String?
    var answers: [String]?
    var selectedAnswerIndex: Int?
}

var questionsList: [Question] = [Question(questionString: "How do you feel right now?", answers: ["Sad", "Angery","Happy", "Lonely"], selectedAnswerIndex: nil), Question(questionString: "What are you thinking right now?", answers: ["I don't konw", "I love/hate school", "I love/hate my work", "I need to talk with someone"], selectedAnswerIndex: nil), Question(questionString: "Are you working with mental health professionals?", answers: ["Yes", "No", "I prefer no to tell"], selectedAnswerIndex: nil)]

class SurveyController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentPosition = navigationController?.viewControllers.index(of:self) ?? 0
        navigationItem.title = "Question \(currentPosition + 1)/\(questionsList.count)"
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor(r: 171, g: 234, b: 190)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.register(AnswerCell.self, forCellReuseIdentifier: cellId)
        tableView.register(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let index = navigationController?.viewControllers.index(of:self){
            let question = questionsList[index]
            if let count = question.answers?.count{
                return count
            }
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AnswerCell
        if let index = navigationController?.viewControllers.index(of:self){
            let question = questionsList[index]
            cell.nameLabel.text = question.answers?[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! QuestionHeader
        if let index = navigationController?.viewControllers.index(of:self){
            let question = questionsList[index]
            header.nameLabel.text = question.questionString
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = navigationController?.viewControllers.index(of:self){
            questionsList[index].selectedAnswerIndex = indexPath.item
            
            if index < questionsList.count - 1{
                let questionController = SurveyController()
                navigationController?.pushViewController(questionController, animated: true)
            }else{
                let controller = ResultsController()
                navigationController?.pushViewController(controller, animated: true)
                
            }
        }
    }
}

class ResultsController: UIViewController{
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you for filling out this survey"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ResultsController.done))
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(resultsLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : resultsLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : resultsLabel]))
        
    }
    
    @objc func done(){
//        navigationController?.popToRootViewController(animated: true)
//                let ref = Database.database().reference()
//                let usersReference = ref.child("users").child(uid)
//                let messagesController = UINavigationController(rootViewController: MessagesController())
//
//                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
//
//                    if err != nil {
//                        print(err!)
//                        return
//                    }
//
//                    self.present(messagesController, animated: true, completion: nil)
//                })
        
        print("done")
    }
    
}


class QuestionHeader: UITableViewHeaderFooterView{
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Question"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
    }
}


class AnswerCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Answer"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews(){
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
    }
}
