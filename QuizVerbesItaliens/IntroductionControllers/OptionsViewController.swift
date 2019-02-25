//
//  OptionsViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-02.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import StoreKit
class OptionsViewController: UIViewController {
    @IBOutlet weak var listeDesVerbes: UILabel!
    @IBOutlet weak var quizDeBase: UILabel!
    @IBOutlet weak var quizContextuel: UILabel!
    @IBOutlet weak var statistiques: UILabel!
    var arrayVerbe: [[String]] = []
    let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(0, forKey: "thisQuizHintAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizGoodAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizBadAnswer")
        if currentCount >= 10 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(0, forKey: "launchCount")
            }
        }
        
        if let plistPath = Bundle.main.path(forResource: "ItalianVerbsList", ofType: "plist"),
            let verbArray = NSArray(contentsOfFile: plistPath){
            arrayVerbe = verbArray as! [[String]]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true)
        let fonts = FontsAndConstraintsOptions()
        listeDesVerbes.font = fonts.smallItaliqueBoldFont
        quizDeBase.font = fonts.smallItaliqueBoldFont
        quizContextuel.font = fonts.smallItaliqueBoldFont
        statistiques.font = fonts.smallItaliqueBoldFont
       self.title = "Scegliere un'opzione"
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerbList"{
            let controller = segue.destination as! VerbListViewController
            controller.arrayVerbe = arrayVerbe
        }else if segue.identifier == "showQuizOption"{
            let controller = segue.destination as! QuizOptionsController
            controller.arrayVerb = arrayVerbe
        }else if segue.identifier == "showContextuelQuizOptionController"{
            let controller = segue.destination as! ContextuelQuizOptionController
            controller.arrayVerb = arrayVerbe
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
