//
//  SoundResponse.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-13.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundResponse {
    class func goodSound() {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "Incoming Text 01", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    class func badSound() {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "Error Warning", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
}
