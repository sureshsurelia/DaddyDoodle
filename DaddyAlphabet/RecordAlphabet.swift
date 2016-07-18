//
//  RecordAlphabet.swift
//  DaddyAlphabet
//
//  Created by Sapna Sharma on 7/14/16.
//  Copyright © 2016 Suresh Surelia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAlphabet: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!


    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    
    @IBAction func recordAudio(sender: AnyObject) {
        stopButton.hidden = false
        stopButton.enabled = true
        recordButton.enabled = false
        if let ar = audioRecorder {
            ar.recordForDuration(5)
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        if let ar = audioRecorder {
            ar.stop()
        }
        finishRecording(success: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVAudioSession.sharedInstance().requestRecordPermission { (granted: Bool)-> Void in
            if granted {
                self.setSessionPlayAndRecord()
                self.setupRecorder()
            } else {
                print("permission to record not granted")
            }
        }
    }
    
    func finishRecording(success success: Bool) {
        audioRecorder = nil
        recordingSession = nil

        if !success {
            print("Recording failed")
        }
        if destinationSegue == leftSegue {
            self.performSegueWithIdentifier("toLeftView", sender: self)
        }
        if destinationSegue == rightSegue {
            self.performSegueWithIdentifier("toRightView", sender: self)
        }
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func setupRecorder() {
        let recordSettings = [AVSampleRateKey : 12000.0,
                              AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                              AVNumberOfChannelsKey : 1 as NSNumber,
                              AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: filePathURL, settings: recordSettings )
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch let error as NSError {
            audioRecorder = nil
            print( error.localizedDescription)
        }
        
    }
    
    func setSessionPlayAndRecord() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
        } catch let error as NSError {
            recordingSession = nil
            print( error.localizedDescription)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
