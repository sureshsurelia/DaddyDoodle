//
//  MyAudioPlayer.swift
//  DaddyAlphabet
//
//  Created by Suresh Surelia on 10/12/15.
//  Copyright © 2015 Suresh Surelia. All rights reserved.
//

import Foundation
import AVFoundation



class MyAudioPlayer{
    var audioPlayer: AVAudioPlayer!
    
    func playAudio(audiofileName: String) {
        let filePathURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(audiofileName, ofType: "m4a")!)
        print("hello")
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL)
            audioPlayer.enableRate = true
            print("successfully started the audio player")
            playMyAudio()
        }catch {
            assertionFailure("Exiting program, couldn't create recorder")
        }
    }
    
    func playMyAudio(){
        if let ap = audioPlayer {
            ap.stop()
            ap.prepareToPlay()
            ap.currentTime = 0.0
            ap.play()
        }else {
            print("No audioplayer available!")
        }
    }
    
}