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
    var soundState = UserDefaults.standard.string(forKey: "soundState")
    var arrayVerbe: [[String]] = []
    var listeVerbe: [String] = []
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
            for verb in arrayVerbe {
                if !listeVerbe.contains(verb[2]){
                    listeVerbe.append(verb[2])
                }
            }
            
            func alpha (_ s1: String, s2: String) -> Bool {
                return s1.folding(options: .diacriticInsensitive, locale: .current) < s2.folding(options: .diacriticInsensitive, locale: .current)
            }
            listeVerbe = listeVerbe.sorted(by: alpha)
        }
        if !soundStateInitialized(soundState: "soundState"){
            soundState = "speaker.slash"
            UserDefaults.standard.setValue(soundState, forKey: "soundState")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true)
        let fonts = FontsAndConstraintsOptions()
        listeDesVerbes.font = fonts.smallItaliqueBoldFont
        quizDeBase.font = fonts.smallItaliqueBoldFont
        quizContextuel.font = fonts.smallItaliqueBoldFont
        statistiques.font = fonts.smallItaliqueBoldFont
        self.title = "Scegliere un'opzione".localized
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerbList"{
            let controller = segue.destination as! VerbListViewController
            controller.arrayVerbe = arrayVerbe
            controller.listeVerbe = listeVerbe
        }else if segue.identifier == "showQuizOption"{
            let controller = segue.destination as! QuizOptionsController
            controller.arrayVerb = arrayVerbe
        }else if segue.identifier == "showContextuelQuizOptionController"{
            let controller = segue.destination as! ContextuelQuizOptionController
            controller.arrayVerb = arrayVerbe
        }
        else if segue.identifier == "showStatistics"{
            let controller = segue.destination as! StatistiqueTableViewController
                controller.listeVerbe = listeVerbe
            
        }
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = UIColor(red: 27/255, green: 96/255, blue: 94/255, alpha: 1.0)
    }
    func soundStateInitialized(soundState: String) -> Bool {
        return UserDefaults.standard.object(forKey: soundState) != nil
    }
}
