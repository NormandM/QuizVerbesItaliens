//
//  VerbInfinitif.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-05.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
struct VerbInfinitif {
    var verbList: [String]
    init (arrayVerb: [[String]]) {
        var list = [String]()
        for array in arrayVerb {
            if !list.contains(array[2]) {
                list.append(array[2])
            }
        }
        verbList = list
    }
}
