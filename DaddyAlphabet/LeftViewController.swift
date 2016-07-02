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


func playAudio() {
    
    do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL)
        audioPlayer.enableRate = true
        print("successfully started the audio player")
    }catch {
        assertionFailure("Exiting program, couldn't create recorder")
    }
    
    if let lap = audioPlayer {
        lap.stop()
        lap.prepareToPlay()
        lap.currentTime = 0.0
        lap.play()
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }else {
        print("No audioplayer available!")
    }
}

func setSwipe(passedSwipeCount: Int, passedDirectionToIncrease :AlphabetDirection) {
    swipeCount = passedSwipeCount
    directionToIncrease = passedDirectionToIncrease
    print("passed swipe count \(swipeCount) direction to increase is \(passedDirectionToIncrease)")
}



class LeftViewController: UIViewController {
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let tapEvent = UITapGestureRecognizer(target:self,action: Selector("handleTapes:"))

        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(tapEvent)

        self.imageBackground.hidden = true
        self.labelText.hidden = false
        
        self.labelText.text = alphabetList[swipeCount].alphabetText
        self.labelText.backgroundColor = UIColor(hexString: alphabetList[swipeCount].color)
        self.imageBackground.image = UIImage(named: "\(alphabetList[swipeCount].fileName).jpeg")
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(1000 * Double(NSEC_PER_MSEC)))
        
        dispatch_after(when,dispatch_get_main_queue()) { () -> Void in
            self.labelText.hidden = true
            self.imageBackground.hidden = false
        }

        
        filePathURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(alphabetList[swipeCount].fileName, ofType: "m4a")!)
        playAudio()

    }

    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if((sender.direction == .Left || sender.direction == .Down) && (swipeCount == 0)){
            directionToIncrease = AlphabetDirection.Left
            swipeCount++
            self.performSegueWithIdentifier(rightSegue, sender: self)
            return
        }
        
        if((sender.direction == .Right || sender.direction == .Up) && (swipeCount == 0)){
            directionToIncrease = AlphabetDirection.Right
            swipeCount++
            self.performSegueWithIdentifier(rightSegue, sender: self)
            return
        }
        
        if((sender.direction == .Left || sender.direction == .Down) && (swipeCount > 0 && swipeCount <= 25)){
            if (directionToIncrease == .Left){
                swipeCount++
                self.performSegueWithIdentifier(rightSegue, sender: self)
                return
            }else
            {
                swipeCount--
                self.performSegueWithIdentifier(rightSegue, sender: self)
            }
        }
        
        if((sender.direction == .Right || sender.direction == .Up) && (swipeCount > 0 && swipeCount <= 25)){
            if (directionToIncrease == .Right){
                swipeCount++
                self.performSegueWithIdentifier(rightSegue, sender: self)
                return
            }else
            {
                swipeCount--
                self.performSegueWithIdentifier(rightSegue, sender: self)
            }
        }
    }
    
    func handleTapes(sender:UITapGestureRecognizer) {
        if(sender.state == .Ended){
            playAudio()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        audioPlayer.stop()
        if (segue.identifier == rightSegue) {
            segue.destinationViewController as! RightViewController
            setSwipe(swipeCount,passedDirectionToIncrease: directionToIncrease)
        }
    }


}
