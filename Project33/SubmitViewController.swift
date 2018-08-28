//
//  SubmitViewController.swift
//  Project33
//
//  Created by Charles Martin Reed on 8/28/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import CloudKit

class SubmitViewController: UIViewController {

    //MARK:- PROPERTIES
    var genre: String!
    var comments: String!
    
    var stackView: UIStackView!
    var status: UILabel!
    var spinner: UIActivityIndicatorView!
    
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = UIColor.gray
        
        //create a stackview that is pinned left, right and centered vertically
        stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //create our status label to indicate iCloud connection status
        status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Submitting..."
        status.textColor = UIColor.white
        status.font = UIFont.preferredFont(forTextStyle: .title1)
        status.numberOfLines = 0
        status.textAlignment = .center
        
        //visual indicator of progress
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        
        //add the label and spinner to our stack
        stackView.addArrangedSubview(status)
        stackView.addArrangedSubview(spinner)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //we need to remove the back button so that the user can't submit multiple times
        title = "You're all set"
        navigationItem.hidesBackButton = true
    }

    
    //MARK:- CloudKit submission methods
    override func viewDidAppear(_ animated: Bool) {
        //start submission process
        super.viewDidAppear(animated)
        
        doSubmission()
    }
    
    func doSubmission() {
        
    }
    
    @objc func doneTapped() {
        //head back to the root view
        //_ silences the "unused result" error since the method actually returns the original view controller though we don't need it.
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
