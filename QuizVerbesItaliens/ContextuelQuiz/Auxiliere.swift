//
//  GetDictAuxiliere.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-12-29.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import Foundation
class Auxiliere {
    class func getDict() -> [String: [String]]{
        var dicAvoirEtre = [String: [String]]()
        if let plistPath = Bundle.main.path(forResource: "DictAvoirEtre", ofType: "plist"){
            dicAvoirEtre = NSDictionary(contentsOfFile: plistPath) as! [String: [String]]
        }
        return dicAvoirEtre
    }
}
