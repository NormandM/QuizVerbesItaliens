//
//  FetchRequestForVerb.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 2021-06-20.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import Foundation
import CoreData

struct FetchRequestForVerb{
    static func evaluate(modeVerb: String, tempsVerb: String, verbInfinitif: String) -> ([Int],[String]){
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: ItemVerbe.identifier )
            let predicateVerbInfinitif = NSPredicate(format: "verbeInfinitif = %@",  verbInfinitif )
            let predicateTemps = NSPredicate(format: "tempsVerbe = %@",  tempsVerb )
            let predicateMode = NSPredicate(format: "modeVerbe = %@",  modeVerb )
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateTemps, predicateMode, predicateVerbInfinitif])
            request.predicate = andPredicate
            return request
        }()
        var itemVerbArray: [ItemVerbe]?
        var bonneReponse = Int()
        var bonnReponseTemp = Int()
        var mauvaiseReponse = Int()
        var bonnereponseString = String()
        var bonneReponseTempString = String()
        var mauveReponseString = String()
        var result = [String]()
        do {
            itemVerbArray = try managedObjectContext.fetch(fetchRequest) as? [ItemVerbe]
        }catch  let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
            if let itemVerbArray = itemVerbArray {
                if itemVerbArray != [] {
                let item = itemVerbArray[0]
                bonneReponse = Int(item.bonneReponse)
                bonnReponseTemp = Int(item.bonneReponseTemps)
                mauvaiseReponse = Int(item.mauvaiseReponse)
                bonnereponseString = String(bonneReponse)
                bonneReponseTempString = String(bonnReponseTemp)
                mauveReponseString = String(mauvaiseReponse)
                }
            }

        result = [verbInfinitif, bonneReponseTempString, bonnereponseString, mauveReponseString]
        return ([bonnReponseTemp, bonneReponse, mauvaiseReponse], result)
    }

}
