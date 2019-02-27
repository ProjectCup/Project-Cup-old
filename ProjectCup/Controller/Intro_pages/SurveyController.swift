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

var questionsList: [Question] = [Question(questionString: "How do you feel right now?", answers: ["Very good", "Good","Moderate", "Bad", "Very Bad"], selectedAnswerIndex: nil), Question(questionString: "What would you like to talk about today?", answers: ["School", "Work", "Family", "Friends", "Relationships", "Anything" ], selectedAnswerIndex: nil), Question(questionString: "Are you working with mental health professionals?", answers: ["Yes", "No", "I prefer no to say"], selectedAnswerIndex: nil)]

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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self,  action: #selector(goback))
        
        tableView.register(AnswerCell.self, forCellReuseIdentifier: cellId)
        tableView.register(QuestionHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.sectionHeaderHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    @objc func goback() {
        dismiss(animated: true, completion: nil)
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
        label.text = "Please Enter Your Name Here"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let nameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Name"
        field.clearsOnBeginEditing = true
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ResultsController.done))
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(resultsLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : resultsLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : resultsLabel]))
        
        view.addSubview(nameField)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-90-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameField]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-160-[v0]-160-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameField]))
        
    }
    
    @objc func done(){
        guard let name = nameField.text, !name.isEmpty else{
            print("The name field is Empty")
            return
        }
        
        let regController = RegisterController()
        regController.userAnswer = getAnswers()
        regController.userName = name
        navigationController?.pushViewController(regController, animated: true)
        
    }
    
    fileprivate func getAnswers() -> [Int]{
        
        var answerList : [Int] = []
        
        for q in questionsList{
            answerList.append(q.selectedAnswerIndex!)
        }
        
        return answerList
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
