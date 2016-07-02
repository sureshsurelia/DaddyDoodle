//
//  RightViewController.swift
//  DaddyAlphabet
//
//  Created by Suresh Surelia on 10/10/15.
//  Copyright © 2015 Suresh Surelia. All rights reserved.
//

import UIKit
import AVFoundation


class RightViewController: UIViewController{
    
    @IBOutlet weak var imageBackground: UIImageView!
    
    @IBOutlet weak var labelText: UILabel!
    

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

    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        if((sender.direction == .Left || sender.direction == .Down) && (swipeCount == 25)){
            if (directionToIncrease == .Left){
                swipeCount = 0
                self.performSegueWithIdentifier(leftSegue, sender: self)
                return
            }
        }
        
        if((sender.direction == .Right || sender.direction == .Up) && (swipeCount == 25)){
            if (directionToIncrease == .Right){
                swipeCount = 0
                self.performSegueWithIdentifier(leftSegue, sender: self)
                return
            }
        }
        
        if((sender.direction == .Left || sender.direction == .Down) && (swipeCount > 0 && swipeCount <= 25)){
            if (directionToIncrease == .Left){
                swipeCount++
                self.performSegueWithIdentifier(leftSegue, sender: self)
                return
            }else
            {
                swipeCount--
                self.performSegueWithIdentifier(leftSegue, sender: self)
            }
        }
        
        if((sender.direction == .Right || sender.direction == .Up) && (swipeCount > 0 && swipeCount <= 25)){
            if (directionToIncrease == .Right){
                swipeCount++
                self.performSegueWithIdentifier(leftSegue, sender: self)
                return
            }else
            {
                swipeCount--
                self.performSegueWithIdentifier(leftSegue, sender: self)
            }
        }
    }
    
    func handleTapes(sender:UITapGestureRecognizer){
        if(sender.state == .Ended){
            playAudio()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        audioPlayer.stop()
        if (segue.identifier == leftSegue) {
            segue.destinationViewController as! LeftViewController
            setSwipe(swipeCount,passedDirectionToIncrease: directionToIncrease)
        }
    }
}
