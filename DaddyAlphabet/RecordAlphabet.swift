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
    
    @IBAction func Cancel(sender: AnyObject) {
        if let ar = audioRecorder {
            ar.stop()
            ar.deleteRecording()
        }
        revertAudioFile()
        finishRecording(success: true)
    }
    
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
                self.backupAudioFile()
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
    
    func backupAudioFile() {
        let tempDirectoryURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
        
        // Create a destination URL.
        tmpPathURL = tempDirectoryURL.URLByAppendingPathComponent(alphabetList[swipeCount].fileName + ".m4a")
        if NSFileManager.defaultManager().fileExistsAtPath(tmpPathURL.path!) {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(tmpPathURL)
            } catch let error {
                NSLog("Unable to copy from tmp file or delete the tmp file: \(error)")
            }
        }
        
        // Copy the file.
        do {
            try NSFileManager.defaultManager().copyItemAtURL(filePathURL, toURL: tmpPathURL)
        } catch let error {
            NSLog("Unable to copy file: \(error)")
        }
        
    }
    
    func revertAudioFile() {
        // Copy the file.
        do {
            try NSFileManager.defaultManager().copyItemAtURL(tmpPathURL, toURL: filePathURL)
            try NSFileManager.defaultManager().removeItemAtURL(tmpPathURL)
        } catch let error {
            NSLog("Unable to copy from tmp file or delete the tmp file: \(error)")
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
