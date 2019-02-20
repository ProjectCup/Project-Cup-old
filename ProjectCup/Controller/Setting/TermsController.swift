//
//  TermView.swift
//  ProjectCup
//
//  Created by Jiatao Xu on 2/3/19.
//  Copyright © 2019 xyy. All rights reserved.
//

import Foundation
import UIKit

class TermsController: UIViewController {
  
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor.blue
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 2000)
        
        return scroll
    }()
    let textView: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.preferredFont(forTextStyle: .headline)
        text.backgroundColor = .lightGray
        text.numberOfLines = 0
        text.text = "Maibbbbbbbbb Here is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................text......................1112321354687631324168765q41321a32f16ds13f21sd6 f54as65g132x1z3f5ws4afHere is some default text......................kengdieeeeeeeeeeeee"
        
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Terms and Conditions"
        
        view.addSubview(scrollView)
        setupScrollView()
    }
    
    
    
    
    func setupScrollView() {
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        textView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10).isActive = true
    }
    
}

