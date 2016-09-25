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
    
//    @IBOutlet weak var switchValue: UISwitch!
//
//    @IBAction func switchAction(sender: AnyObject) {
//        if textCase == true {
//            textCase = false
//        }else
//        {
//            textCase = true
//        }
//        switchValue.hidden = true
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelText.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        imageBackground.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RightViewController.handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RightViewController.handleSwipes(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RightViewController.handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(RightViewController.handleSwipes(_:)))
        let tapEvent = UITapGestureRecognizer(target:self,action: #selector(RightViewController.handleTapes(_:)))
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(RightViewController.wasDragged(_:)))
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(RightViewController.handleLongPressGesture(_:)))
        longPressGR.minimumPressDuration = 1.0
        longPressGR.numberOfTouchesRequired = 2

        
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
        if textCase == true {
            self.labelText.text = alphabetList[swipeCount].alphabetText.uppercaseString
        }else
        {
            self.labelText.text = alphabetList[swipeCount].alphabetText.lowercaseString
        }
        
        self.labelText.backgroundColor = UIColor(hexString: alphabetList[swipeCount].color)
        self.imageBackground.image = UIImage(named: "\(alphabetList[swipeCount].fileName).jpeg")

        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(2000 * Double(NSEC_PER_MSEC)))
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        dispatch_after(when,dispatch_get_main_queue()) { () -> Void in
            self.labelText.hidden = true
            self.imageBackground.hidden = false
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

        }

//        filePathURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(alphabetList[swipeCount].fileName, ofType: "m4a")!)
        directoryURL()
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
                swipeCount += 1
                self.performSegueWithIdentifier(leftSegue, sender: self)
                return
            }else
            {
                swipeCount -= 1
                self.performSegueWithIdentifier(leftSegue, sender: self)
            }
        }
        
        if((sender.direction == .Right || sender.direction == .Up) && (swipeCount > 0 && swipeCount <= 25)){
            if (directionToIncrease == .Right){
                swipeCount += 1
                self.performSegueWithIdentifier(leftSegue, sender: self)
                return
            }else
            {
                swipeCount -= 1
                self.performSegueWithIdentifier(leftSegue, sender: self)
            }
        }
    }
    
    func handleTapes(sender:UITapGestureRecognizer){
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
                if(swipeCount == 25){
                    if (directionToIncrease == .Left){
                        swipeCount = 0
                        self.performSegueWithIdentifier(leftSegue, sender: self)
                        return
                    }
                }
                
                if(swipeCount > 0 && swipeCount <= 25){
                    if (directionToIncrease == .Left){
                        swipeCount += 1
                        self.performSegueWithIdentifier(leftSegue, sender: self)
                        return
                    }else
                    {
                        swipeCount -= 1
                        self.performSegueWithIdentifier(leftSegue, sender: self)
                    }
                }
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                print("Right Drag")
                
                if(swipeCount == 25){
                    if (directionToIncrease == .Right){
                        swipeCount = 0
                        self.performSegueWithIdentifier(leftSegue, sender: self)
                        return
                    }
                }
                
                if(swipeCount > 0 && swipeCount <= 25){
                    if (directionToIncrease == .Right){
                        swipeCount += 1
                        self.performSegueWithIdentifier(leftSegue, sender: self)
                        return
                    }else
                    {
                        swipeCount -= 1
                        self.performSegueWithIdentifier(leftSegue, sender: self)
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
            self.performSegueWithIdentifier(rightViewRecording, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        destinationSegue = rightSegue
        
        if let lap = audioPlayer {
            lap.stop()
        }else {
            print("No audioplayer available!")
        }
        
        if (segue.identifier == leftSegue) {
            segue.destinationViewController as! LeftViewController
            setSwipe(swipeCount,passedDirectionToIncrease: directionToIncrease)
        }
    }
}
