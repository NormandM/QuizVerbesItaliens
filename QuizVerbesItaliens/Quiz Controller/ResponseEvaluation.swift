//
//  ResponseEvaluation.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-09.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
import CoreData
struct ResponseEvaluation {
    static func evaluate(modeVerb: String, tempsVerb: String,  infinitif: String, userResponse: String, rightAnswer: String, rightHintWasSelected: Bool) -> QuizResult{
        let dataController = DataController.sharedInstance
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: ItemVerbe.identifier )
            let predicateTemps = NSPredicate(format: "tempsVerbe = %@",  tempsVerb )
            let predicateMode = NSPredicate(format: "modeVerbe = %@",  modeVerb )
            let predicateInfinitif = NSPredicate(format: "verbeInfinitif = %@",  infinitif )
            let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateTemps, predicateMode, predicateInfinitif])
            request.predicate = andPredicate
            return request
        }()
        var quizResultString = String()
        var itemVerbe: ItemVerbe!
        var itemVerbArray: [ItemVerbe]?
        do {
            itemVerbArray = try managedObjectContext.fetch(fetchRequest) as? [ItemVerbe]
        }catch  let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        
        if itemVerbArray == [] {
            itemVerbe = NSEntityDescription.insertNewObject(forEntityName: "ItemVerbe", into: dataController.managedObjectContext) as? ItemVerbe

            itemVerbe.setValue(tempsVerb, forKey: "tempsVerbe")
            itemVerbe.setValue(modeVerb, forKey: "modeVerbe")
            itemVerbe.setValue(infinitif, forKey: "verbeInfinitif")
            itemVerbArray?.append(itemVerbe)
        }else{

            itemVerbe = itemVerbArray!.first
        }
        let itemVerbeUpdate = itemVerbe as NSManagedObject
        if  itemVerbe.modeVerbe?.caseInsensitiveCompare(modeVerb) == .orderedSame &&  itemVerbe.tempsVerbe?.caseInsensitiveCompare(tempsVerb) == .orderedSame && userResponse.caseInsensitiveCompare(rightAnswer) == .orderedSame{
            if rightHintWasSelected {
                itemVerbe.bonneReponseTemps = itemVerbe.bonneReponseTemps + 1
                itemVerbeUpdate.setValue(itemVerbe.bonneReponseTemps, forKey: "bonneReponseTemps")
                let thisQuizHintAnswer = UserDefaults.standard.integer(forKey: "thisQuizHintAnswer")
                UserDefaults.standard.set(thisQuizHintAnswer + 1, forKey: "thisQuizHintAnswer")
                print("thisQuizHintAnswer: \(UserDefaults.standard.integer(forKey: "thisQuizHintAnswer"))")
                quizResultString = QuizResult.help.rawValue
            }else{
                itemVerbe.bonneReponse = itemVerbe.bonneReponse + 1
                itemVerbeUpdate.setValue(itemVerbe.bonneReponse, forKey: "bonneReponse")
                let thisQuizGoodAnswer = UserDefaults.standard.integer(forKey: "thisQuizGoodAnswer")
                print(thisQuizGoodAnswer)
                UserDefaults.standard.set(thisQuizGoodAnswer + 1, forKey: "thisQuizGoodAnswer")
                print("thisQuizGoodAnswer: \(UserDefaults.standard.integer(forKey: "thisQuizGoodAnswer"))")
                quizResultString = QuizResult.good.rawValue
            }
        }else{
            itemVerbe.mauvaiseReponse = itemVerbe.mauvaiseReponse + 1
            itemVerbeUpdate.setValue(itemVerbe.mauvaiseReponse, forKey: "mauvaiseReponse")
            let thisQuizBadAnswer = UserDefaults.standard.integer(forKey: "thisQuizBadAnswer")
            UserDefaults.standard.set(thisQuizBadAnswer + 1, forKey: "thisQuizBadAnswer")
            print("thisQuizBadAnswer: \(UserDefaults.standard.integer(forKey: "thisQuizBadAnswer"))")
            quizResultString = QuizResult.bad.rawValue
        }
        itemVerbeUpdate.setValue(infinitif, forKey: "verbeInfinitif")
        dataController.saveContext()
        return QuizResult(rawValue: quizResultString)!
    }
    
}
enum QuizResult: String {
    case good
    case bad
    case help
}
