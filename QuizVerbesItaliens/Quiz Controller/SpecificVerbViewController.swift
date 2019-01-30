//
//  SpecificVerbViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 17-11-04.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit

class SpecificVerbViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var randomVerb: Int = 0
    var arrayFilter: [Any] = []
    var listeVerbe: [String] = []
    var listeVerbeAny: [[Any]] = []
    var arrayVerbe: [[String]] = []
    var arraySelection: [String] = []
    var verbesChoisi: [String] = []
    let fontsAndConstraints = FontsAndConstraintsOptions()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scegliere di 1 a 10 verbi"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(showQuiz))
        for verb in arrayVerbe {
            if !listeVerbe.contains(verb[2]){
                listeVerbe.append(verb[2])
            }
        }
        func alpha (_ s1: String, s2: String) -> Bool {
            return s1 < s2
        }
        listeVerbe = listeVerbe.sorted(by: alpha)
        var n = 0
        for verbe in listeVerbe {
            listeVerbeAny.append([verbe, false, n])
            n = n + 1
        }
    }
    // Setting up the searchBar active: Ttrue/False
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // filter array with string that start with searchText
        self.arrayFilter = listeVerbeAny.filter{
            if let pos = ($0[0] as! String).lowercased().range(of: searchText.lowercased()) {
                return (pos.lowerBound == ($0[0] as! String).startIndex)
            }
            return false
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchBar.text == "" ? self.listeVerbeAny.count : self.arrayFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let lista = self.searchBar.text == "" ? self.listeVerbeAny : self.arrayFilter
        let cellAnyArray = lista[indexPath.row] as! [Any]
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.font =  fontsAndConstraints.normalItaliqueBoldFont
        let cellText = cellAnyArray[0] as! String
        cell.textLabel?.text = cellText
        // check cell based on second field
        let cellCheck = cellAnyArray[1] as! Bool
        if cellCheck{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        verbesChoisi = []
        var lista = self.searchBar.text == "" ? self.listeVerbeAny : self.arrayFilter
        let idAnyArray = lista[indexPath.row] as! [Any]
        let id = idAnyArray[2] as! Int
        // invert the value of checked
        self.listeVerbeAny[id][1] = !(listeVerbeAny[id][1] as! Bool)
        lista = self.searchBar.text == "" ? self.listeVerbeAny : self.arrayFilter
        let cellAnyArray = lista[indexPath.row] as! [Any]
        let cellCheck = cellAnyArray[1] as! Bool
        let cell = tableView.cellForRow(at: indexPath)
        if cellCheck{
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        self.searchBar.text! = ""
        tableView.reloadData()
    }
    func choix() {
        for element in self.listeVerbeAny {
            if element[1] as! Bool {
                verbesChoisi.append(element[0] as! String)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var okForSegue = true
        let selection = Selection()
        let modeEtTemps = selection.choixTempsEtMode(arraySelection: arraySelection)
        for mode in modeEtTemps {
            if mode.contains("Imperativo"){
                if verbesChoisi.contains("potere") || verbesChoisi.contains("dovere")  || verbesChoisi.contains("piovere"){
                    showAlertPasDImperatif()
                    okForSegue = false
                }
            }
        }
        if okForSegue {
            if segue.identifier == "showQuiz"{
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
                let controller = segue.destination as! QuizController
                controller.arrayVerbe = arrayVerbe
                controller.arraySelection = arraySelection
                controller.verbeInfinitif = verbesChoisi
                controller.listeVerbe = listeVerbe
            }
        }
    }
    func showAlert () {
        let alertController = UIAlertController(title: "Si deve scegliere almeno 1 verbo e un massimo di 10", message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = tableView.rectForHeader(inSection: 1)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func showAlertPasDImperatif() {
        let alertController = UIAlertController(title: "Non esiste alcun imperativo per questi verbi:", message: "potere, dovere. Fare un'altra scelta", preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = tableView.rectForHeader(inSection: 1)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @objc func showQuiz() {
        choix()
        if verbesChoisi.count == 0 || verbesChoisi.count > 10{
            showAlert()
        }else {
            performSegue(withIdentifier: "showQuiz", sender: Any?.self)
        }
    }
}
