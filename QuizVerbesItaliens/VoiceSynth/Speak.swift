//
//  Speak.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 2022-10-30.
//  Copyright © 2022 Normand Martin. All rights reserved.
//

import UIKit
import AVFoundation
class Speak {
    static func text(text: String){
        let synthVM = SynthViewModel()
        var impSentence = String()
        let firstCharacter = text.first
        if firstCharacter == "(" {
            impSentence = text.components(separatedBy: ")").dropFirst().joined(separator: " ")
            if text.components(separatedBy: ",").first == "lui"{
                impSentence = impSentence.components(separatedBy: ",").dropFirst().joined(separator: " ")
            }
        }else{
           impSentence = text
        }
        synthVM.speak(text: impSentence)
    }
    func speak(text: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(utterance)
    }
    
}
