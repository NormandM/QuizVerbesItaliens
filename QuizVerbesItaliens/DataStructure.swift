//
//  DataStructure.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-02.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import Foundation
import CoreData

//MARK: Verbe structure
struct VerbeItalien{
    let verbe: String
    let mode: String
    let temps: String
    let premier: String
    let deuxieme: String
    let troisieme: String
    let quatrieme: String
    let cinquieme: String
    let sixieme: String
    var verbeChoisi = [String]()
    let n: Int
    init(verbArray: [[String]], n: Int){
        self.n = n
        verbeChoisi = verbArray[n]
        mode = verbeChoisi[0]
        temps = verbeChoisi[1]
        verbe = verbeChoisi[2]
        premier = verbeChoisi[3]
        deuxieme = verbeChoisi[4]
        troisieme = verbeChoisi[5]
        quatrieme = verbeChoisi[6]
        cinquieme = verbeChoisi[7]
        sixieme = verbeChoisi[8]
    }
}
struct VerbeTrie {
    let verbe: String
    let mode: String
    let temps: String
    let verbeConjugue: String
    let personne: String
    let n: Int
    init(allInfoList: [[String]], n: Int){
        self.n = n
        mode = allInfoList[n][0]
        temps = allInfoList[n][1]
        verbe = allInfoList[n][2]
        verbeConjugue = allInfoList[n][3]
        personne = allInfoList[n][4]
    }
}
//////////////////////////////
//// MARK: Struct to assign the right pronom
//////////////////////////////
struct Personne{
    let verbArray: VerbeItalien
    var first: String{
             if verbArray.mode == "Congiuntivo"{
                return "che io"
             }else if verbArray.mode == "Imperativo"{
                return ""
                
             }else{
                return "io"
            }
    }
    var second: String{
        if verbArray.mode == "Congiuntivo"{
            return "che tu"
        }else if verbArray.mode == "Imperativo"{
            return"(tu)"
        }else{
            return "tu"
        }
    }
    var third: String {
        if verbArray.mode == "Congiuntivo"{
            return "che lui, lei"
        }else if verbArray.mode == "Imperativo"{
            return"(lui, lei)"
        }else{
            return "lui, lei"
        }
    }
    var fourth: String{
        if verbArray.mode == "Congiuntivo"{
            return "che noi"
        }else if verbArray.mode == "Imperativo"{
            return"(noi)"
        }else{
            return "noi"
        }
    }
    var fifth: String{
        if verbArray.mode == "Congiuntivo"{
            return "che voi"
        }else if verbArray.mode == "Imperativo"{
            return"(voi)"
        }else{
            return "voi"
        }
    }
    var sixth: String {
        if verbArray.mode == "Congiuntivo"{
            return "che loro"
        }else if verbArray.mode == "Imperativo"{
            return"(loro)"
        }else{
            return "loro"
        }
    }

}
struct PersonneTrie {
    let verbeTrie: VerbeTrie
    var first: String{
        var firstReturn = ""
        if verbeTrie.personne == "1" {
            if verbeTrie.mode == "Congiuntivo"{
                    firstReturn = "che io"
            }else if verbeTrie.mode == "Imperativo"{
                    firstReturn = ""
            }else {firstReturn = "io"}
        }
        return firstReturn
    }
    var second: String{
        var secondReturn = ""
        if verbeTrie.personne == "2" {
            if verbeTrie.mode == "Congiuntivo"{
                secondReturn = "che tu"
            }else if verbeTrie.mode == "Imperativo"{
                secondReturn = "(tu)"
            }else{
                secondReturn = "tu"
            }
        }
        return secondReturn
    }
    var third: String {
        var thirdReturn = ""
        if verbeTrie.personne == "3" {
            if verbeTrie.mode == "Congiuntivo"{
                thirdReturn = "che lui, lei"
            }else if verbeTrie.mode == "Imperativo"{
                thirdReturn = "(lui, lei)"
            }else{
                thirdReturn = "lui, lei"
            }
        }
        return thirdReturn
    }
    var fourth: String{
        var fourthReturn = ""
        if verbeTrie.personne == "4" {
            if verbeTrie.mode == "Congiuntivo"{
                fourthReturn = "che noi"
            }else if verbeTrie.mode == "Imperativo"{
                fourthReturn = "(noi)"
            }else{
                fourthReturn = "noi"
            }
        }
        return fourthReturn
    }
    var fifth: String{
        var fifthReturn = ""
        if verbeTrie.personne == "5" {
            if verbeTrie.mode == "Congiuntivo"{
                fifthReturn = "che voi"
            }else if verbeTrie.mode == "Imperativo"{
                fifthReturn = "(voi)"
            }else{
                fifthReturn = "voi"
            }
        }
        return fifthReturn
    }
    var sixth: String {
        var sixthReturn = ""
        if verbeTrie.personne == "6" {
            if verbeTrie.mode == "Congiuntivo"{
                sixthReturn = "che loro"
            }else if verbeTrie.mode == "Imperativo"{
                sixthReturn = "(loro)"
            }else{
                sixthReturn = "loro"
            }
        }
        return sixthReturn
    }
    
    
}

/////////////////////////////////////
// MARK: CoreData data controller, persistent store etc
/////////////////////////////////////
open class DataController: NSObject {
    
    static let sharedInstance = DataController()
    
    fileprivate override init() {}
    
    fileprivate lazy var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[(urls.endIndex - 1)]
    }()
    
    fileprivate lazy var managerObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "VerbesFrancais", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managerObjectModel)
        let url = self.applicationDocumentDirectory.appendingPathComponent("VerbesFrancais.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            let userInfo: [String: AnyObject] = [NSLocalizedDescriptionKey: "Failed to initialized the application's saved data" as AnyObject, NSLocalizedFailureReasonErrorKey: "There was an error creating or loading the application's saved data" as AnyObject, NSUnderlyingErrorKey: error as NSError]
            let wrappedError = NSError(domain: "Normand", code: 9999, userInfo: userInfo)
            abort()
        }
        return coordinator
    }()
    
    open lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    open func saveContext() {
        if managedObjectContext.hasChanges{
            do {
                try managedObjectContext.save()
            } catch let error as NSError{
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
////////////////////////////////
// MARK: helper function to capitalisez first letter of string
///////////////////////////////
class Helper {
    func capitalize(word: String) -> (String) {
        let firstLetter =  String(word.prefix(1)).capitalized
        let otherLetters = String(word.dropFirst())
        return(firstLetter + otherLetters)
    }
}

