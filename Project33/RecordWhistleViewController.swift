//
//  RecordWhistleViewController.swift
//  Project33
//
//  Created by Charles Martin Reed on 8/28/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordWhistleViewController: UIViewController {
    
    //MARK:- Properties
    var recordButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    
    //creating our stack view
    var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //coding our layout
        view.backgroundColor = UIColor.gray
        
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackViewDistribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        //auto-layout constraints - stackView should stretch to the dimensions of the View containing it
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
    }

    //AVAudioSession and AVAudioRecorder
    //Session enables and tracks collective sound recordings. Ensures recording is possible.
    //Recorder is used to track individual recording sessions. Responsible for actually pulling data from mic and writing to disk.
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
