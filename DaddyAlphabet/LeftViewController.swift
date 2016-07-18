//
//  LeftViewController.swift
//  DaddyAlphabet
//
//  Created by Suresh Surelia on 10/10/15.
//  Copyright © 2015 Suresh Surelia. All rights reserved.
//

import UIKit
import AVFoundation


var audioPlayer: AVAudioPlayer!
var filePathURL: NSURL!
var swipeCount = 0
var directionToIncrease = AlphabetDirection.Left
var alphabetList = Alphabet.PRE_DEFINED_FILENAME.getMyAlphabetList()
let leftSegue = "leftSegue"
let rightSegue = "rightSegue"
let rightViewRecording = "rightViewRecording"
let leftViewRecording = "leftViewRecording"
var destinationSegue = ""



func playAudio() {
    let fileManager = NSFileManager.defaultManager()
    
    if fileManager.fileExistsAtPath(filePathURL.path!) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            audioPlayer.enableRate = true
            audioPlayer.volume = 1.0
            print("successfully started the audio player")
        }catch {
            print("Exiting program, couldn't create audio player")
        }
        
        if let lap = audioPlayer {
            lap.stop()
            lap.prepareToPlay()
            lap.currentTime = 0.0
            lap.play()
        }else {
            print("No audioplayer available!")
        }
    }else {
        print("no file exist to play")
    }
   }

func setSwipe(passedSwipeCount: Int, passedDirectionToIncrease :AlphabetDirection) {
    swipeCount = passedSwipeCount
    directionToIncrease = passedDirectionToIncrease
    print("passed swipe count \(swipeCount) direction to increase is \(passedDirectionToIncrease)")
}

func directoryURL(fileName: String) -> NSURL? {
    let fileManager = NSFileManager.defaultManager()
    let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    let documentDirectory = urls[0] as NSURL
    let soundURL = documentDirectory.URLByAppendingPathComponent(fileName + ".m4a")
    return soundURL
}


class LeftViewController: UIViewController {
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelText.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        imageBackground.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)

        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LeftViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LeftViewController.handleSwipes(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LeftViewController.handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(LeftViewController.handleSwipes(_:)))
        let tapEvent = UITapGestureRecognizer(target:self,action: #selector(LeftViewController.handleTapes(_:)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(LeftViewController.wasDragged(_:)))
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(LeftViewController.handleLongPressGesture(_:)))
        longPressGR.minimumPressDuration = 1.0
        longPressGR.numberOfTouchesRequired = 1
        
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(tapEvent)
        imageBackground.userInteractionEnabled = true
        imageBackground.addGestureRecognizer(dragGesture)
        imageBackground.addGestureRecognizer(longPressGR)


        self.imageBackground.hidden = true
        self.labelText.hidden = false
        
        self.labelText.text = alphabetList[swipeCount].alphabetText
        self.labelText.backgroundColor = UIColor(hexString: alphabetList[swipeCount].color)
        self.imageBackground.image = UIImage(named: "\(alphabetList[swipeCount].fileName).jpeg")
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(2000 * Double(NSEC_PER_MSEC)))
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        dispatch_after(when,dispatch_get_main_queue()) { () -> Void in
            self.labelText.hidden = true
            self.imageBackground.hidden = false
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        
        filePathURL = directoryURL(alphabetList[swipeCount].fileName)
        playAudio()
    }

    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if((sender.direction == .Left || sender.direction == .Down) && (swipeCount == 0)){
            directionToIncrease = AlphabetDirection.Left
            swipeCount += 1
            self.performSegueWithIdentifier(rightSegue, sender: self)
            return
        }
        
        if((sender.direction == .Right || sender.direction == .Up) && (swipeCount == 0)){
            directionToIncrease = AlphabetDirection.Right
            swipeCount += 1
            self.performSegueWithIdentifier(rightSegue, sender: self)
            return
        }
        
        if((sender.direction == .Left || sender.direction == .Down) && (swipeCount > 0 && swipeCount <= 25)){
            if (directionToIncrease == .Left){
                swipeCount += 1
                self.performSegueWithIdentifier(rightSegue, sender: self)
                return
            }else
            {
                swipeCount -= 1
                self.performSegueWithIdentifier(rightSegue, sender: self)
            }
        }
        
        if((sender.direction == .Right || sender.direction == .Up) && (swipeCount > 0 && swipeCount <= 25)){
            if (directionToIncrease == .Right){
                swipeCount += 1
                self.performSegueWithIdentifier(rightSegue, sender: self)
                return
            }else
            {
                swipeCount -= 1
                self.performSegueWithIdentifier(rightSegue, sender: self)
            }
        }
    }
    
    func handleTapes(sender:UITapGestureRecognizer) {
        if(sender.state == .Ended){
            playAudio()
        }
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(100 / abs(xFromCenter), 1)
        
        
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if label.center.x < 100 {
                
                print("Left Drag")
                if(swipeCount == 0){
                    directionToIncrease = AlphabetDirection.Left
                    swipeCount += 1
                    self.performSegueWithIdentifier(rightSegue, sender: self)
                    return
                }
                
                if(swipeCount > 0 && swipeCount <= 25){
                    if (directionToIncrease == .Left){
                        swipeCount += 1
                        self.performSegueWithIdentifier(rightSegue, sender: self)
                        return
                    }else
                    {
                        swipeCount -= 1
                        self.performSegueWithIdentifier(rightSegue, sender: self)
                    }
                }
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                print("Right Drag")
                
                if(swipeCount == 0){
                    directionToIncrease = AlphabetDirection.Right
                    swipeCount += 1
                    self.performSegueWithIdentifier(rightSegue, sender: self)
                    return
                }
                
                if(swipeCount > 0 && swipeCount <= 25){
                    if (directionToIncrease == .Right){
                        swipeCount += 1
                        self.performSegueWithIdentifier(rightSegue, sender: self)
                        return
                    }else
                    {
                        swipeCount -= 1
                        self.performSegueWithIdentifier(rightSegue, sender: self)
                    }
                }
            }
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, 1, 1)
            
            label.transform = stretch
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
    }
    
    func handleLongPressGesture(sender:UITapGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Began){
            if let lap = audioPlayer {
                lap.stop()
            }
            self.performSegueWithIdentifier(leftViewRecording, sender: self)
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        destinationSegue = leftSegue
        
        if let lap = audioPlayer {
            lap.stop()
        }else {
            print("No audioplayer available!")
        }
        
        if (segue.identifier == rightSegue) {
            segue.destinationViewController as! RightViewController
            setSwipe(swipeCount,passedDirectionToIncrease: directionToIncrease)
        }
        
    }


}
