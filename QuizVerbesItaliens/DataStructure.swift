//
//  DataStructure.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 15-12-26.
//  Copyright © 2015 Normand Martin. All rights reserved.
//

import Foundation
import UIKit
struct ListedeVerbe {
    
    let infinitif: [String]
    let tempsVerbe: [String]
    let personneVerbe: [String]
    let dictVerbes: [String: [String:[String: String]]]

    init(verbeDictionary: NSDictionary) {
        dictVerbes = verbeDictionary["verbe"] as! [String: [String:[String: String]]]
        
        infinitif = verbeDictionary["verbe"]?.allKeys as! [String]
        
        tempsVerbe = verbeDictionary["verbe"]?["essere"]??.allKeys as! [String]
        
        personneVerbe = verbeDictionary["verbe"]?["essere"]??["Indicativo Futuro semplice"]??.allKeys as! [String]

            }

}
