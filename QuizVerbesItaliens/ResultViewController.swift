//
//  ResultViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-09.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultat: UILabel!
    @IBOutlet weak var message: UILabel!
    var testCompltete = UserDefaults.standard.bool(forKey: "testCompltete")
    var totalProgress: Int = 0
    var goodResponse: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        testCompltete = true
        UserDefaults.standard.set(self.testCompltete, forKey: "testCompltete")
        resultat.text = "\(goodResponse)/\(totalProgress)"
        let result = Double(goodResponse)/Double(totalProgress)
        let resultPercent = String(round(result*100)) + " %"
        
        // Do any additional setup after loading the view.
        if result == 1.0{
            message.text = "Perfetto! "
        }else if result < 1 && Double(result) >= 0.75{
            message.text = "\(resultPercent) Ottimo!"
        }else  if Double(result) >= 0.6 && Double(result) < 0.75{
            message.text = "\(resultPercent) Bene!"
        }else{
            message.text = "\(resultPercent) Riprovare!"
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToQuizController" {
            let controller = segue.destination as! QuizController
            controller.testCompltete = testCompltete
        }
    }
    
    
    @IBAction func termine(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
