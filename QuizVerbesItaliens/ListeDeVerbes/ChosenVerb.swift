//
//  IndexVerbArrayClass.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-04.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
class ChosenVerb {
    let infinitif: String
    let mode: String
    let temp: String
    let index: Int
    var arrayVerb: [[String]]
    let conjugatedVerb: Verb
    init (infinitif: String, mode: String, temp: String){
        self.infinitif = infinitif
        self.mode = mode
        self.temp = temp
        var arrayVerbTransit = [[String]]()
        if let plistPath = Bundle.main.path(forResource: "ItalianVerbsList", ofType: "plist"),
            let verbArray = NSArray(contentsOfFile: plistPath){
            arrayVerbTransit = verbArray as! [[String]]
        }
        arrayVerb = arrayVerbTransit
        var n = 0
        for array in arrayVerb {
            if (array[0].caseInsensitiveCompare(mode) == .orderedSame) && (array[1].caseInsensitiveCompare(temp) == .orderedSame) && (array[2].caseInsensitiveCompare(infinitif) == .orderedSame) {
                break
            }
            n = n + 1
        }
        index = n
        conjugatedVerb = Verb(n: n, verbArray: arrayVerb)
    }
}
