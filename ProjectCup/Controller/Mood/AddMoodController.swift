//
//  AddMoodController.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 6/5/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import UIKit

protocol savemoodDelegate {
    func savemood(mood: MoodEntry.Mood!, date: Date!, at: Int?, isEditingEntry: Bool!, moodStory: String?)
}

class AddMoodController: UIViewController {
    
    //MARK: Properties
    
    var delegate: savemoodDelegate?
    var date: Date!
    var mood: MoodEntry.Mood!
    var indexrow: Int?
    var moodStory: String?
    var isEditingEntry:Bool! = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        view.addSubview(buttonAmazing)
        view.addSubview(buttonGood)
        view.addSubview(buttonNeutral)
        view.addSubview(buttonBad)
        view.addSubview(buttonTerrible)
        
        view.addSubview(textField)
        view.addSubview(datePicker)
        
        setNaviBarItems()
        settextField()
        setupButtons()
        setupDatePicker()
        view.backgroundColor = UIColor.yellow
        
        }
    
    func updateUI() {
        updateMood(to: mood)
        datePicker.date = date
    }
    
    @objc func datePickerDidChangeValue(_ sender: UIDatePicker) {
        date = datePicker.date
    }
    
    private func updateMood(to newMood: MoodEntry.Mood) {
        let unselectedColor = UIColor.white
        switch newMood {
        case .none:
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case .amazing:
            buttonAmazing.backgroundColor = newMood.colorValue
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case .good:
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = newMood.colorValue
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case .neutral:
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = newMood.colorValue
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = unselectedColor
        case .bad:
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = newMood.colorValue
            buttonTerrible.backgroundColor = unselectedColor
        case .terrible:
            buttonAmazing.backgroundColor = unselectedColor
            buttonGood.backgroundColor = unselectedColor
            buttonNeutral.backgroundColor = unselectedColor
            buttonBad.backgroundColor = unselectedColor
            buttonTerrible.backgroundColor = newMood.colorValue
        }
        
        mood = newMood
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
    
    
    @objc func pressMood(_ button: UIButton) {
        switch button.tag {
        case 0:
            updateMood(to: .amazing)
        case 1:
            updateMood(to: .good)
        case 2:
            updateMood(to: .neutral)
        case 3:
            updateMood(to: .bad)
        case 4:
            updateMood(to: .terrible)
        default:
            
            //NOTE: error handling
            print("unhandled button tag")
        }
    }
    
    @objc func handledone() {
        let moodStory = textField.text
        delegate?.savemood(mood: mood, date: date, at: indexrow, isEditingEntry: isEditingEntry, moodStory: moodStory)
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
    
    
    func settextField() {
        
        textField.backgroundColor = UIColor.white
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        tfHeightAnchor = textField.heightAnchor.constraint(equalToConstant: 100)
        tfHeightAnchor?.isActive = true
        
    }

}
