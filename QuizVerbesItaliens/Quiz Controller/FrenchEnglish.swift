//
//  FrenchEnglish.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 17-11-08.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import Foundation
class FrenchToEnglish {
    
    func getDict() -> [String: String]{
        var dicFrenchEnglish = [String: String]()
        if let plistPath = Bundle.main.path(forResource: "ItalianToEnglish".localized, ofType: "plist"){
            dicFrenchEnglish = NSDictionary(contentsOfFile: plistPath) as! [String: String]
        }
        for (verb) in dicFrenchEnglish {
            print("\(verb.key),\(verb.value)")
        }
        return dicFrenchEnglish
    }
}
