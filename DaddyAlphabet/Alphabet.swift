//
//  Alphabet.swift
//  DaddyAlphabet
//
//  Created by Suresh Surelia on 10/11/15.
//  Copyright © 2015 Suresh Surelia. All rights reserved.
//

import Foundation
import UIKit

class Alphabet{
    var fileName:String
    var alphabetText:String
    var color:String

    init(fileName:String,alphabetText:String, color:String){
        self.fileName = fileName
        self.alphabetText = alphabetText
        self.color = color
    }
    
     struct PRE_DEFINED_FILENAME {
        static var initialized: Bool = false
        static var  myalphabetList:[Alphabet]?
        static func getMyAlphabetList()->[Alphabet]{
            if !initialized{
                print("INITIALIZING")
                myalphabetList = [
                    Alphabet(fileName: "Apple",alphabetText: "A", color: "CC3300"),
                    Alphabet(fileName: "Banana",alphabetText: "B", color: "FF6600"),
                    Alphabet(fileName: "Cake",alphabetText: "C", color: "FFFF99"),
                    Alphabet(fileName: "Donuts",alphabetText: "D", color: "99FFFF"),
                    Alphabet(fileName: "Egg",alphabetText: "E", color: "6699CC"),
                    Alphabet(fileName: "Fruits",alphabetText: "F", color: "FFCC99"),
                    Alphabet(fileName: "Grapes",alphabetText: "G", color: "FF0000"),
                    Alphabet(fileName: "Honey",alphabetText: "H", color: "FFFF33"),
                    Alphabet(fileName: "Icecream",alphabetText: "I", color: "9999FF"),
                    Alphabet(fileName: "Juice",alphabetText: "J", color: "FF0033"),
                    Alphabet(fileName: "Kiwi",alphabetText: "K", color: "6600FF"),
                    Alphabet(fileName: "Lemon",alphabetText: "L" , color: "FF0033"),
                    Alphabet(fileName: "Milk",alphabetText: "M" , color: "FFCCCC"),
                    Alphabet(fileName: "Nuts",alphabetText: "N", color: "99CCCC"),
                    Alphabet(fileName: "Orange",alphabetText: "O", color: "66FFCC"),
                    Alphabet(fileName: "Pizza",alphabetText: "P", color: "FFCC33"),
                    Alphabet(fileName: "Quinoa",alphabetText: "Q", color: "3399FF"),
                    Alphabet(fileName: "Rice",alphabetText: "R", color: "990033"),
                    Alphabet(fileName: "Sandwitch",alphabetText: "S", color: "FFFF99"),
                    Alphabet(fileName: "Tomato",alphabetText: "T", color: "0066FF"),
                    Alphabet(fileName: "Utensils",alphabetText: "U", color: "FF6699"),
                    Alphabet(fileName: "Vegetables",alphabetText: "V", color: "33CC33"),
                    Alphabet(fileName: "Watermellon",alphabetText: "W", color: "FF9966"),
                    Alphabet(fileName: "Xmascake",alphabetText: "X", color: "996633"),
                    Alphabet(fileName: "Yogurt",alphabetText: "Y", color: "CCFF99"),
                    Alphabet(fileName: "Zuchinni",alphabetText: "Z", color: "FFCCCC")
                ]
                initialized = true
            }
            return myalphabetList!
        }
    }
}

enum AlphabetDirection {
    case Left
    case Right
}

extension UIColor {
    
    convenience init(hexString: String) {
        // Trim leading '#' if needed
        var cleanedHexString = hexString
        if hexString.hasPrefix("#") {
            cleanedHexString = String(hexString.characters.dropFirst()) // Swift 2
        }
        // String -> UInt32
        var rgbValue: UInt32 = 0
        NSScanner(string: cleanedHexString).scanHexInt(&rgbValue)
        
        // UInt32 -> R,G,B
        let red = CGFloat((rgbValue >> 16) & 0xff) / 255.0
        let green = CGFloat((rgbValue >> 08) & 0xff) / 255.0
        let blue = CGFloat((rgbValue >> 00) & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}