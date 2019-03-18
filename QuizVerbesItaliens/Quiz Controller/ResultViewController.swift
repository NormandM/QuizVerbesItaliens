//
//  ResultViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-09.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import Charts


class ResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var resultat: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var termineButton: UIButton!
    @IBOutlet weak var scoreChart: PieChartView!
    var testCompltete = UserDefaults.standard.bool(forKey: "testCompltete")
    var totalProgress: Double = 0
    var goodResponse: Double = 0
    var badResponse = Double()
    var aideCount = Double()
    var wichQuiz = UnwindSegueChoice.toQuizViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goodResponse = Double(UserDefaults.standard.integer(forKey: "thisQuizGoodAnswer"))
        aideCount = Double(UserDefaults.standard.integer(forKey: "thisQuizHintAnswer"))
        badResponse = Double(UserDefaults.standard.integer(forKey: "thisQuizBadAnswer"))
        resultat.text = "\(Int(goodResponse + aideCount))/\(Int(totalProgress))"
        let result = Double(goodResponse + aideCount)/Double(totalProgress)
        let resultPercent = String(round(result*100)) + " %"
        if result == 1.0{
            message.text = "Perfetto! "
        }else if result < 1 && Double(result) >= 0.75 {
            message.text = "\(resultPercent) Molto bene!"
        }else if Double(result) >= 0.6 && Double(result) < 0.75 {
            message.text = "\(resultPercent) Bene!"
        }else if result >= 0 && Double(result) < 0.6 {
            message.text = "\(resultPercent) Prova di nuovo!"
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let fonts = FontsAndConstraintsOptions()
        titleLabel.font = fonts.largeBoldFont
        resultat.font = fonts.normalBoldFont
        message.font = fonts.normalItaliqueBoldFont
        termineButton.titleLabel?.font = fonts.normalFont
        termineButton.layer.cornerRadius = termineButton.frame.height/2
        setupChart()
    }
    func setupChart() {
        let entrieBon = goodResponse
        let entrieMal = badResponse
        let entrieAide = aideCount
        let pieChartSetUp = PieChartSetUp(entrieBon: entrieBon, entrieMal: entrieMal, entrieAide: entrieAide, pieChartView: scoreChart)
        scoreChart.data = pieChartSetUp.piechartData
    }
    
    // MARK: - Navigation
    @IBAction func termine(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        switch wichQuiz {
        case .toContexteViewController:
            performSegue(withIdentifier: wichQuiz.rawValue, sender: self)
        case .toQuizViewController:
            performSegue(withIdentifier: wichQuiz.rawValue, sender: self)
        }
    }

}
