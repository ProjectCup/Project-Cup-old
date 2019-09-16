//
//  AddMoodController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 6/5/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit
import Firebase

class AddMoodController: UIViewController {
    
    //MARK: Properties
    var mood: String?
    var journalText: String?
    var isEditingEntry = false
    var journalId: String?
    let moodController = MoodController()
    
    var buttonAmazing: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Amazing", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.tag = 0
        button.addTarget(self, action: #selector(pressMood(_:)), for: .touchUpInside)
        
        return button
    }()
    var buttonGood: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Good", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.tag = 1
        button.addTarget(self, action: #selector(pressMood(_:)), for: .touchUpInside)
        
        return button
    }()
    var buttonNeutral: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Neutral", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.tag = 2
        button.addTarget(self, action: #selector(pressMood(_:)), for: .touchUpInside)
        
        return button
    }()
    var buttonBad: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Bad", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.tag = 3
        button.addTarget(self, action: #selector(pressMood(_:)), for: .touchUpInside)
        
        return button
    }()
    var buttonTerrible: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Terrible", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.tag = 4
        button.addTarget(self, action: #selector(pressMood(_:)), for: .touchUpInside)
        
        return button
    }()
    
    var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.backgroundColor = UIColor.white
        dp.addTarget(self, action: #selector(datePickerDidChangeValue(_:)), for: .valueChanged)
        return dp
    }()
    
    var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type your story here"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    var dateinputField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Please select the date"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
       return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buttonAmazing)
        view.addSubview(buttonGood)
        view.addSubview(buttonNeutral)
        view.addSubview(buttonBad)
        view.addSubview(buttonTerrible)
        
        view.addSubview(textField)
        view.addSubview(dateinputField)
        dateinputField.inputView = datePicker
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        setNaviBarItems()
        settextField()
        setupButtons()
        setupDatePicker()
        updateMood()
        view.backgroundColor = UIColor.yellow
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func datePickerDidChangeValue(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateinputField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    func setupDatePicker() {
        datePicker.frame = CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width, height: 200)
        datePicker.datePickerMode = .dateAndTime
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
    }
    
    private func setupButtons(){
        //amazing
        buttonAmazing.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonAmazing.bottomAnchor.constraint(equalTo: buttonGood.topAnchor, constant: -12).isActive = true
        buttonAmazing.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonAmazing.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //good
        buttonGood.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonGood.bottomAnchor.constraint(equalTo: buttonNeutral.topAnchor, constant: -12).isActive = true
        buttonGood.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonGood.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //neutral
        buttonNeutral.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonNeutral.bottomAnchor.constraint(equalTo: buttonBad.topAnchor, constant: -12).isActive = true
        buttonNeutral.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonNeutral.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //bad
        buttonBad.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonBad.bottomAnchor.constraint(equalTo: buttonTerrible.topAnchor, constant: -12).isActive = true
        buttonBad.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonBad.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //terrible
        buttonTerrible.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonTerrible.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -12).isActive = true
        buttonTerrible.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        buttonTerrible.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    @objc func handledone() {

        guard let uid = Auth.auth().currentUser?.uid
            else {
                return
        }
        if isEditingEntry == false {
            let ref = Database.database().reference().child("journal").child(uid)
            let journalid = ref.childByAutoId()
            let values = ["journalText": textField.text!, "mood": mood!, "time": dateinputField.text!] as [String : Any]
            
            journalid.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        } else {
            let jnlid = journalId
            let ref = Database.database().reference().child("journal").child(uid).child(jnlid!)
            let values = ["journalText": textField.text!, "mood": mood!, "time": dateinputField.text!] as [String : Any]
            
            ref.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error ?? "")
                    return
                }
            }
        }

        navigationController?.popViewController(animated: true)
    }
    
    @objc func pressMood(_ button: UIButton) {
        switch button.tag {
        case 0:
            print("amazing")
            mood = "Amazing"
            return updateMood()
        case 1:
            print("good")
            mood = "Good"
            return updateMood()
        case 2:
            mood = "Neutral"
            return updateMood()
        case 3:
            mood = "Bad"
            return updateMood()
        case 4:
            mood = "Terrible"
            return updateMood()
        default:
            
            //NOTE: error handling
            print("unhandled button tag")
        }
    }
    
    private func updateMood() {
        let unselectedColor = UIColor.white
        switch mood {
        case .none:
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case "Amazing":
            buttonAmazing.backgroundColor = UIColor.green
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case "Good":
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = UIColor.blue
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case "Neutral":
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = UIColor.yellow
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case "Bad":
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = UIColor.orange
            buttonTerrible.backgroundColor = unselectedColor
        case "Terrible":
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = UIColor.red
        default:
            print("nothing")
        }
        
        
    }
    
    
    
    private func setNaviBarItems() {
        //right bar item
        
        let addmoodButton = UIButton(type: .system)
        addmoodButton.setImage(UIImage(named: "New chat"), for: .normal)
        addmoodButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        addmoodButton.addTarget(self, action: #selector(handledone), for: .touchUpInside)
        
        let addmoodItem = UIBarButtonItem(customView: addmoodButton)
        addmoodItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        addmoodItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.navigationItem.rightBarButtonItem = addmoodItem
        
        let cancelItem = navigationItem.backBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    var tfHeightAnchor: NSLayoutConstraint?
    var dfHeightAnchor: NSLayoutConstraint?
    func settextField() {
        textField.backgroundColor = UIColor.white
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        tfHeightAnchor = textField.heightAnchor.constraint(equalToConstant: 100)
        tfHeightAnchor?.isActive = true
        
        dateinputField.backgroundColor = UIColor.white
        dateinputField.leftAnchor.constraint(equalTo: textField.leftAnchor).isActive = true
        dateinputField.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        dateinputField.widthAnchor.constraint(equalTo: textField.widthAnchor).isActive = true
        dfHeightAnchor = dateinputField.heightAnchor.constraint(equalToConstant: 50)
        dfHeightAnchor?.isActive = true
    }
    
}

