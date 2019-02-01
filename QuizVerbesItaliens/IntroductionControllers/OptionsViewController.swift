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
    var arrayVerbe: [[String]] = []
    let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Scegliere una opzione"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerbList"{
            let controller = segue.destination as! VerbListViewController
            controller.arrayVerbe = arrayVerbe
        }else if segue.identifier == "showQuizOption"{
            let controller = segue.destination as! QuizOptionsController
            controller.arrayVerbe = arrayVerbe
        }else if segue.identifier == "showContextuelQuizOptionController"{
            let controller = segue.destination as! ContextuelQuizOptionController
            controller.arrayVerbe = arrayVerbe
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}
