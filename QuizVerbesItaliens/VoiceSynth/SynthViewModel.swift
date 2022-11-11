//
//  SynthViewModel.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 2022-10-28.
//  Copyright © 2022 Normand Martin. All rights reserved.
//

import Foundation
import AVFoundation
class SynthViewModel: NSObject {
    private var speechSynthesizer = AVSpeechSynthesizer()
    override init() {
        super.init()
        self.speechSynthesizer.delegate = self
    }
    func speak(text: String) {
        let voice = AVSpeechSynthesisVoice(language: "Italian")
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
      //  utterance.rate = AVSpeechUtteranceMinimumSpeechRate
        utterance.rate = 0.4
        speechSynthesizer.speak(utterance)
    }
}

extension SynthViewModel: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("started")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("paused")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("finished")
        let notificationCenter = NotificationCenter.default
        let voiceStopped = Notification.Name("voiceStopped")
        notificationCenter.post(name: voiceStopped, object: nil, userInfo: nil)
    }
}
