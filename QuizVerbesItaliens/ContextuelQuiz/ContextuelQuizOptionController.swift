//
//  ContextuelQuizOptionController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-11-15.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class ContextuelQuizOptionController: UITableViewController {
    let modeAndTemp = ModeAndTemp()
    var arrayVerb = [[String]]()
    lazy var modes = modeAndTemp.mode
    lazy var temps = modeAndTemp.temp
    var selectedTimeVerbes = NSMutableSet()
    var arraySelectionTempsEtMode = [[String]]()
    var verbInfinitif = [String]()
    var difficulté = DifficultyLevel.FACILE
    let fontsAndConstraints = FontsAndConstraintsOptions()
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        header.textLabel!.textColor = UIColor.white //make the text white
        header.textLabel?.font = fontsAndConstraints.normalBoldFont
        header.alpha = 1.0 //make the header transparent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Scegliere i tempi".localized
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return modes[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return modes.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temps[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = temps[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font =  fontsAndConstraints.normalItaliqueBoldFont
        configure(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    func configure(_ cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        if selectedTimeVerbes.contains(indexPath) {
            // selected
            cell.accessoryType = .checkmark
        }
        else {
            // not selected
            cell.accessoryType = .none
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedTimeVerbes.contains(indexPath) {
            // deselect
            selectedTimeVerbes.remove(indexPath)
            let cell2 = tableView.cellForRow(at: indexPath)!
            var textArray = [String]()
            if let text = cell2.textLabel?.text{
                textArray = [text, modes[indexPath.section]]
            }
            if let n = arraySelectionTempsEtMode.firstIndex(of: textArray){
                arraySelectionTempsEtMode.remove(at: n)
            }
        }
        else {
            // select
            selectedTimeVerbes.add(indexPath)
            arraySelectionTempsEtMode.append([temps[indexPath.section][indexPath.row], modes[indexPath.section]])
        }
        let cell = tableView.cellForRow(at: indexPath)!
        configure(cell, forRowAtIndexPath: indexPath)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContextuelQuiz"{
            verbInfinitif = ["Tous les verbes"]
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = UIColor(red: 27/255, green: 96/255, blue: 94/255, alpha: 1.0)
            let controller = segue.destination as! ContextuelQuizViewController
            controller.modeEtTemps = arraySelectionTempsEtMode
            controller.difficulté = difficulté
            controller.arrayVerb = arrayVerb
        }
    }
    func showAlert () {
        let alertController = UIAlertController(title: "È necessario scegliere almeno un tempo verbale".localized, message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = tableView.rectForHeader(inSection: 1)
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func OK(_ sender: UIBarButtonItem) {
        var i = 0
        i = arraySelectionTempsEtMode.count
        if i == 0{
            showAlert()
        }else{
            difficulté = DifficultyLevel.DIFFICILE
            performSegue(withIdentifier: "showContextuelQuiz", sender: UIBarButtonItem.self)
        }
    }
}

