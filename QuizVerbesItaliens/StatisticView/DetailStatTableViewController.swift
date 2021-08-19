//
//  FirstStatTableViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 2021-06-22.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit

class DetailStatTableViewController: UITableViewController {
    var listeVerbe: [String] = []
    var selectedMode = ""
    var selectedTemp = ""
    var resultArray = [[String]]()
    var forImprovementArray = [[[String]]]()
    var infinitveVerbsForImprovement = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let capitalisedMode = selectedMode.capitalizingFirstLetter()
        self.title = "\(capitalisedMode) \(selectedTemp)"
        fetchingData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return infinitveVerbsForImprovement.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return infinitveVerbsForImprovement[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forImprovementArray[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FirstStatTableViewCell
        if forImprovementArray != [] {
            var formatedText = "Corretto: %@".localized
            cell.rightAnswerLabel.text = String(format: formatedText, forImprovementArray[indexPath.section][indexPath.row][2])
            formatedText = "Con l'aiuto: %@".localized
            cell.rightwithHintLabel.text = String(format: formatedText, (forImprovementArray[indexPath.section][indexPath.row][1]))
            formatedText = "Sbaliato: %@".localized
            cell.wrongAnswerLabel.text = String(format: formatedText, (forImprovementArray[indexPath.section][indexPath.row][3]))
            formatedText = "Risultato:\n%@".localized
            cell.percentRightLabel.text = String(format: formatedText, (forImprovementArray[indexPath.section][indexPath.row][4]))

        }
        return cell
    }

    func fetchingData(){
        let resultArray = FetchResult.fetchingData(selectedMode: selectedMode, selectedTemp: selectedTemp, listeVerbe: listeVerbe)
        let tuppleOfArrays = FetchResult.resultPerVerb(resultArray: resultArray.1)
        forImprovementArray = tuppleOfArrays.0
        infinitveVerbsForImprovement = tuppleOfArrays.1
    }

}
