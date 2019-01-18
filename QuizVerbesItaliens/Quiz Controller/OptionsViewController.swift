//
//  OptionsViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-02.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    var arrayVerbe: [[String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scegliere una opzione"
        if let plistPath = Bundle.main.path(forResource: "ItalianVerbsList", ofType: "plist"),
            let verbArray = NSArray(contentsOfFile: plistPath){
            arrayVerbe = verbArray as! [[String]]
        }
//        if let plistPath = Bundle.main.path(forResource: "ContextuelItalien", ofType: "plist"),
//            let verbArrayContextuel = NSArray(contentsOfFile: plistPath){
//            let arrayVerbeContextuel = verbArrayContextuel as! [[String]]
//            var verbInfinitfArray = [String]()
//            var verbInfintifQuizArray = [String]()
//            for verb in arrayVerbe {
//                if !verbInfintifQuizArray.contains(verb[2]){
//                    verbInfintifQuizArray.append(verb[2])
//                }
//            }
//            for verb in arrayVerbeContextuel {
//                if !verbInfinitfArray.contains(verb[4]) && !verbInfintifQuizArray.contains(verb[4]){
//                    verbInfinitfArray.append(verb[4])
//                }
//            }
//            for verb in verbInfinitfArray {
//                print(verb)
//            }
//        }

        
        self.navigationItem.setHidesBackButton(true, animated:true)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerbList"{
            let controller = segue.destination as! VerbListViewController
            controller.arrayVerbe = arrayVerbe
        }else if segue.identifier == "showQuizOption"{
            let controller = segue.destination as! QuizOptionsController
            controller.arrayVerbe = arrayVerbe
        }

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

    }

    
}
