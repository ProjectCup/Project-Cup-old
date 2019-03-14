//
//  Content.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 3/13/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit

class ContentController: UIViewController{
    
    var article = ""
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.white
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 2000)
        
        return scroll
    }()
    
    let content: UILabel = {
        let ct = UILabel()
        ct.translatesAutoresizingMaskIntoConstraints = false
        ct.font = UIFont.preferredFont(forTextStyle: .headline)
        ct.backgroundColor = UIColor.white
        ct.numberOfLines = 0
        ct.text = "Content"
        
        return ct
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(article)
        content.text = article
        view.backgroundColor = UIColor.green
        view.addSubview(scrollView)
        setupScrollView()
    }
    
    
    func setupScrollView() {
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(content)
        
        content.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        content.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
    }
}
