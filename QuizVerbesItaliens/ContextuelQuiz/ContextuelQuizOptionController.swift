//
//  ContextuelQuizOptionController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-11-15.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class ContextuelQuizOptionController: UITableViewController {
    var arrayVerbe: [[String]] = []
    var listeVerbes = [String]()
    var arraySelection: [String] = []
    var verbeInfinitif: [String] = []
    var refIndexPath = [IndexPath]()
    var selectedTimeVerbes = NSMutableSet()
    var arr: NSMutableArray = []
    var difficulté = DifficultyLevel.FACILE
    let fontsAndConstraints = FontsAndConstraintsOptions()
    let sectionListe = ["INDICATIVO", "CONGIUNTIVO", "CONDIZIONALE", "IMPERATIVO"]
    let item = [["Presente", "Imperfetto", "Passato prossimo", "Futuro semplice", "Passato remoto", "Trapassato prossimo", "Futuro anteriore", "Trapassato remoto"], ["Presente ", "Passato ", "Imperfetto ", "Trapassato "], ["Presente  ", "Passato  "], ["Presente   "]]

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as
        header.contentView.backgroundColor =  UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        header.textLabel!.textColor = UIColor.white //make the text white
        header.textLabel?.font = fontsAndConstraints.largeBoldFont
        header.alpha = 1.0 //make the header transparent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        for array in arrayVerbe {
            if listeVerbes.contains(array[2]){
                
            }else{
                listeVerbes.append(array[2])
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Scegliere i tempi"
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionListe[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionListe.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return item[section].count
    }
    // Next code is to enable checks for each cell selected
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = self.item[indexPath.section][indexPath.row]
        cell.selectionStyle = .none
        configure(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    func configure(_ cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        if selectedTimeVerbes.contains(indexPath) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        cell.textLabel?.font =  fontsAndConstraints.normalItaliqueBoldFont
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedTimeVerbes.contains(indexPath) {
            // deselect
            selectedTimeVerbes.remove(indexPath)
            let cell2 = tableView.cellForRow(at: indexPath)!
            if let text = cell2.textLabel?.text, let n = arraySelection.index(of: text){
                arraySelection.remove(at: n)
            }
        }
        else {
            // select
            selectedTimeVerbes.add(indexPath)
            arraySelection.append(self.item[indexPath.section][indexPath.row])
        }
        let cell = tableView.cellForRow(at: indexPath)!
        configure(cell, forRowAtIndexPath: indexPath)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showContextuelQuiz"{
            verbeInfinitif = ["Tous les verbes"]
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            let selection = Selection()
            let modeEtTemps = selection.choixTempsEtMode(arraySelection: arraySelection)
            let controller = segue.destination as! ContextuelQuizViewController
            controller.modeEtTemps = modeEtTemps
            controller.difficulté = difficulté
            controller.arrayVerbe = arrayVerbe
        }
    }
    func showAlert () {
        let alertController = UIAlertController(title: "È necessario scegliere almeno un tempo verbale.", message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = tableView.rectForHeader(inSection: 1)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func OK(_ sender: UIBarButtonItem) {
        var i = 0
        i = arraySelection.count
        if i == 0{
            showAlert()
        }else{
            difficulté = DifficultyLevel.DIFFICILE
            performSegue(withIdentifier: "showContextuelQuiz", sender: UIBarButtonItem.self)
        }
    }
}
