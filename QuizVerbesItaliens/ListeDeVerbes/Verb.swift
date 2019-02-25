//
//  VerbStruct.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-04.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
struct Verb {
    let verbInfinitif: String
    let firstPersonVerb: String
    let secondPersonVerb: String
    let thirdPersonVerb: String
    let fourthPersonVerb: String
    let fifthPersonVerb: String
    let sixthPersonVerb: String
    let mode: String
    let temp: String
    init(n: Int, verbArray: [[String]]) {
        mode = verbArray[n][0]
        temp = verbArray[n][1]
        verbInfinitif = verbArray[n][2]
        firstPersonVerb = verbArray[n][3]
        secondPersonVerb = verbArray[n][4]
        thirdPersonVerb = verbArray[n][5]
        fourthPersonVerb = verbArray[n][6]
        fifthPersonVerb = verbArray[n][7]
        sixthPersonVerb = verbArray[n][8]
    }
}
