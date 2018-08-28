//
//  ViewController.swift
//  Project33
//
//  Created by Charles Martin Reed on 8/28/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding buttons for adding whistle and back button to nav
        title = "What's the Whistle?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        
    }
    
    @objc func addWhistle() {
        //present the view that allows players to record their whistle
        let vc = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}

