//
//  FlipboardViewController.swift
//  ProjectCup
//
//  Created by Sailung Yeung on 6/11/19.
//  Copyright © 2019 xyy. All rights reserved.
//


import UIKit
import ViewAnimator
import Firebase
import Hero

var user_name: String = ""

struct user_question {
    var questionString: String?
    var selectedAnswerIndex: [String]?
}

var questions: [user_question] = [user_question(questionString: "Hi \(user_name), please select the topic you want to talk about", selectedAnswerIndex: []), user_question(questionString: "\(user_name), how do you feel right now?", selectedAnswerIndex: []), user_question(questionString: "\(user_name), are you working with mental health professionals?", selectedAnswerIndex: [])]

class FlipboardViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    private var items = [String?]()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private var counter = 0
    
    let resultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi " + user_name + ", please select the topic you want to talk about"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    var ForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Next", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(Forward), for: .touchUpInside)

        return button
    }()
    @objc func Forward() {
        switch counter {
        case 1:
            getCellSelection()
            counter = counter + 1
            resultsLabel.text = questions[counter].questionString
            loadList(arr: ["Yes","No"])
        case 2:
            getCellSelection()
            let regController = RegisterController()
            regController.userAnswer = getAnswers()
            regController.userName = user_name
            clearAnswers()
            present(regController, animated: true)
        default:
            getCellSelection()
            counter = counter + 1
            collectionView?.allowsMultipleSelection = false
            resultsLabel.text = questions[counter].questionString
            loadList(arr: ["thrilled","good", "so-so", "bad","toasted"])
        }
    }
    
    private func getCellSelection(){
        self.collectionView?.orderedVisibleCells.forEach{ cell in
            let c = cell as! MultiCollectionViewCell
            if cell.isSelected{
                questions[counter].selectedAnswerIndex?.append(c.choiceLabel.text!)
            }
        }
    }
    
    var BackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Back", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(Back), for: .touchUpInside)
        return button
    }()
        
    @objc func Back() {
        switch counter {
        case 1:
            clearAnswers()
            counter = counter - 1
            resultsLabel.text = questions[counter].questionString
            collectionView?.allowsMultipleSelection = true
            getChoices()
        case 2:
            clearAnswers()
            counter = counter - 1
            resultsLabel.text = questions[counter].questionString
            loadList(arr: ["thrilled","good", "so-so", "bad","toasted"])
        default:
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(MultiCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.allowsMultipleSelection = true
        getChoices()
        
        resultsLabel.hero.id = "batMan"
        view.addSubview(resultsLabel)
        view.addSubview(ForwardButton)
        view.addSubview(BackButton)
        ForwardButton.hero.id = "background"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultsLabel.frame.size = CGSize(width: 300, height: 100)
        resultsLabel.center = CGPoint(x: view.bounds.midX, y: 130)
        ForwardButton.frame.size = CGSize(width: 350, height: 50)
        ForwardButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 175)
        BackButton.frame.size = CGSize(width: 350, height: 50)
        BackButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 250)
    }
    
    
    private func getChoices(){
        let ref = Database.database().reference()
        ref.child("choices").observeSingleEvent(of: .value, with: {(snapshot) in
            let choices = snapshot.value as! String
            let array = choices.components(separatedBy: " ")
            self.items = array
            self.loadList(arr: array)
        }){(error) in
            print(error.localizedDescription)
        }
        
    }
    
    fileprivate func getAnswers() -> [[String]]{
        var answerList : [[String]] = []
        for q in questions{
            answerList.append(q.selectedAnswerIndex!)
        }
        return answerList
    }
    
    fileprivate func clearAnswers(){
        for i in 0..<questions.count{
            questions[i].selectedAnswerIndex?.removeAll()
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
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch counter {
        case 1:
            return CGSize(width: 300, height: 50)
        case 2:
            return CGSize(width: 300, height: 100)
        default:
            return CGSize(width: 95, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 150.0,left: 30.0,bottom: 50.0,right: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

}

class MultiCollectionViewCell: UICollectionViewCell{
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(choiceLabel)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 2.0
    }
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 4.0 : 2.0
            self.backgroundColor = isSelected ? .red : .white
            self.choiceLabel.textColor = isSelected ? .white : .red
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    let choiceLabel: UILabel = {
        let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        labelView.textColor = .red
        labelView.textAlignment = .center
        labelView.font = UIFont(name: "AmericanTypewriter", size: 15)
        return labelView
    }()
    
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}



class buttonView: UIViewController{
    
    let nameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Please Enter Your name here"
        field.textAlignment = .center
        field.clearsOnBeginEditing = true
        return field
    }()
    
    var ActivateButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Ready !", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        view.backgroundColor = .white
        
        nameField.hero.id = "batMan"
        view.addSubview(nameField)
        view.addSubview(ActivateButton)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameField.frame.size = CGSize(width: 300, height: 80)
        nameField.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 90)
        ActivateButton.frame.size = CGSize(width: 170, height: 60)
        ActivateButton.center = CGPoint(x: view.bounds.midX, y:view.bounds.midY)
    }
    
    
    @objc func onTap() {
        guard let name = nameField.text, !name.isEmpty else{
            print("The name field is Empty")
            return
        }
        user_name = name
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let vc2 = FlipboardViewController(collectionViewLayout: layout)
        vc2.hero.isEnabled = true
        present(vc2, animated: true, completion: nil)
    }
}
