//
//  UILAbelExtensionForVoice.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 2022-10-28.
//  Copyright © 2022 Normand Martin. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
extension UILabel {
    func clickLabel(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(labelClicked))
        addGestureRecognizer(gesture)
    }
    @objc func labelClicked() {
        if self.textColor == .red {
            self.textColor = .black
        }else{
            self.textColor = .red
        }
        var impSentence = String()
        if let realText = self.text {
            let firstCharacter = realText.first
            if firstCharacter == "(" {
                impSentence = realText.components(separatedBy: ")").dropFirst().joined(separator: " ")
                if realText.components(separatedBy: ",").first == "lui"{
                    impSentence = realText.components(separatedBy: ",").dropFirst().joined(separator: " ")
                }
                
            }else{
                impSentence = realText
            }
        }
        let synthVM = SynthViewModel()
        synthVM.speak(text: impSentence)
    }
    func speak(text: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(utterance)
    }
}


