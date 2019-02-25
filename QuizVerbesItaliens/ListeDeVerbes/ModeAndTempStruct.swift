//
//  ModeAndTempStruct.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-04.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
struct ModeAndTemp {
    let mode: [String] = ["INDICATIVO", "CONGIUNTIVO", "CONDIZIONALE", "IMPERATIVO"]
    let temp: [[String]] = [["Presente", "Imperfetto", "Passato prossimo", "Futuro semplice", "Passato remoto", "Trapassato prossimo", "Futuro anteriore", "Trapassato remoto"], ["Presente", "Passato", "Imperfetto", "Trapassato"], ["Presente", "Passato"], ["Presente"]]
}
