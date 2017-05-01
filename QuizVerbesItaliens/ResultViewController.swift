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
    
    
    var goodResponse: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        testCompltete = true
        UserDefaults.standard.set(self.testCompltete, forKey: "testCompltete")
        resultat.text = "\(goodResponse)/10"
        // Do any additional setup after loading the view.
        if goodResponse == 10{
            message.text = "Perfetto! "
        }else if goodResponse == 9 ||  goodResponse == 8 || goodResponse == 7{
            message.text = "Ottimo!"
        }else{
            message.text = "Riprovare!"
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToQuizController" {
            let controller = segue.destination as! QuizController
            controller.testCompltete = testCompltete
        }
    }

    
    @IBAction func termine(_ sender: Any) {
        performSegue(withIdentifier: "unwindToQuizController", sender: self)
        
        self.dismiss(animated: true, completion: nil)
        
    }




}
