//
//  QuizQuestion.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-07.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
struct QuizQuestion {
    let mode: String
    let temp: String
    let infinitif: String
    let person: String
    let conjugatedVerb: String
    var indexIncrement: Int
    init(verbSelectionRandom: [[String]], index: Int){
        mode = verbSelectionRandom[index][0]
        temp = verbSelectionRandom[index][1]
        infinitif = verbSelectionRandom[index][2]
        person = verbSelectionRandom[index][4]
        conjugatedVerb = verbSelectionRandom[index][3]
        indexIncrement = index + 1
        if indexIncrement == verbSelectionRandom.count {indexIncrement = 0 }
    }
}
