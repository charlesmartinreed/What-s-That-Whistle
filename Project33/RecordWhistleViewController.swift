//
//  RecordWhistleViewController.swift
//  Project33
//
//  Created by Charles Martin Reed on 8/28/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import AVFoundation

//AVAudioSession and AVAudioRecorder
//Session enables and tracks collective sound recordings. Ensures recording is possible.
//Recorder is used to track individual recording sessions. Responsible for actually pulling data from mic and writing to disk.

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK:- Properties
    var recordButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    
    var playButton: UIButton!
    var whistlePlayer: AVAudioPlayer!
    
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
        
        //setting up the UI and recording session
        title = "Record your whistle"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
        
        //grab the built-in system audio session
        recordingSession = AVAudioSession.sharedInstance()
        
        //ask for permission and try to present the interface if granted
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {
                [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
        
    }
    
    //MARK:- Recording UIs
    func loadRecordingUI() {
        //creating our record button
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        recordButton.setTitle("Tap to Record", for: .normal)
        //using dynamic type for sizing our strings in an accessibility friendly way, per the user's size settings when available
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        //adding to arrangedSubview array allows stack view to automatically layout our UI
        stackView.addArrangedSubview(recordButton)
        
        //creating our play button
        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", for: .normal)
        
        //don't show the button to user AND don't let it take up space in the stack
        //we'll hide the play button when recording and show it when finished recording successfully
        playButton.isHidden = true
        playButton.alpha = 0
        
        playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        stackView.addArrangedSubview(playButton)
    }
    
    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        failLabel.text = "Recording failed: please ensure the app has access to your microphone."
        failLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(failLabel)
    }
    
    
    //MARK:- Saving and retrieving recordings
    //class func so we can call them on class, not instances
    class func getDocumentsDirectory() -> URL {
        //this is where we'll save our recordings
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
    //MARK:- Triggering and manipulating recordings
    //iOS needs to know where to to save the recording, WHEN CREATING the AVAudioRecorder object because iOS streams audio to file as it goes
    //decide on format, bit-rate, channel number and quality. Using AAC, 12KHz, 1 for number of input channels because iPhones only have mono input, high AAC quality.
    //set view controller as delegate of recording to find out when recording stops and if it was successful.
    //recording ceases during system events like an incoming call, but not necessarily if your app goes into background
    
    @objc func recordTapped() {
        //call startRecording or finishRecording, depending upon the app state
        if whistleRecorder == nil {
            
            if !playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                }
            }
            
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @objc func playTapped() {
        //grabs the whistle URL, creates an AVAudioPlayer in do/try/catch and plays it. If there's an error loading sound, show an alert
        let audioURL = RecordWhistleViewController.getWhistleURL()
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
            whistlePlayer.play()
        } catch {
            let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing back your whistle; please try re-recording", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    @objc func nextTapped() {
        //present the select genre view controller
        let vc = SelectGenreViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func startRecording() {
        
        //make view have red background to indicate recording
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
       
        //change title of the record button to say "Tap to Stop"
        recordButton.setTitle("Tap to Stop", for: .normal)
        
        //Use getWhistleURL to find where to save the whistle
        let audioURL = RecordWhistleViewController.getWhistleURL()
        print(audioURL)
        
        //Create a settings dictionary describing format, sample rate, channels and quality
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        //Create AVAudioRecorder object point at our whistleURL, set self as delegate, then call record method
        //can throw an error, we need a do/catch
        do {
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        //make view background color green to indicate recording is done
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        //destroy the AVAudioRecording object by setting to nil AFTER stopping
        whistleRecorder.stop()
        whistleRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            
            if playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = false
                    self.playButton.alpha = 1
                }
            }
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            
            let ac = UIAlertController(title: "Recording failed", message: "There was a problem with your whistle; please try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    //MARK:- AVAudioRecorder delegate method
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
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
