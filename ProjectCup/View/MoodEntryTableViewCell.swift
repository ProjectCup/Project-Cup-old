//
//  MoodEntryTableViewCell.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 6/7/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit

class MoodEntryTableViewCell: UITableViewCell {
    
    let labelMoodTitle : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.backgroundColor = .yellow
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    let labelMoodDate : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.backgroundColor = .green
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let imageViewMoodColor : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.red
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    func configure(_ entry: MoodEntry) {
        imageViewMoodColor.backgroundColor = entry.mood.colorValue
        labelMoodTitle.text = entry.mood.stringValue
        labelMoodDate.text = entry.date.stringValue
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(labelMoodTitle)
        addSubview(labelMoodDate)
        addSubview(imageViewMoodColor)
        
        imageViewMoodColor.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8).isActive = true
        imageViewMoodColor.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageViewMoodColor.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageViewMoodColor.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        labelMoodTitle.leftAnchor.constraint(equalTo: self.imageViewMoodColor.rightAnchor).isActive = true
        labelMoodTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        labelMoodTitle.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        labelMoodTitle.bottomAnchor.constraint(equalTo: self.labelMoodDate.topAnchor).isActive = true
        labelMoodTitle.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelMoodTitle.heightAnchor.constraint(equalToConstant: 24).isActive = true

        
        labelMoodDate.leftAnchor.constraint(equalTo: self.imageViewMoodColor.rightAnchor).isActive = true
        labelMoodDate.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        labelMoodDate.topAnchor.constraint(equalTo: self.labelMoodTitle.bottomAnchor).isActive = true
        labelMoodDate.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        labelMoodDate.widthAnchor.constraint(equalToConstant: 100).isActive = true
        labelMoodDate.heightAnchor.constraint(equalToConstant: 24).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension Date {
    var stringValue: String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
}
