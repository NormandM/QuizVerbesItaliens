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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scegliere i verbi"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(showQuiz))
        let i = arrayVerbe.count
        while randomVerb < i {
            let allVerbs = VerbeItalien(verbArray: arrayVerbe, n: randomVerb)
            listeVerbe.append(allVerbs.verbe)
            randomVerb = randomVerb + 16
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
        // #warning Incomplete implementation, return the number of rows
        return self.searchBar.text == "" ? self.listeVerbeAny.count : self.arrayFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let lista = self.searchBar.text == "" ? self.listeVerbeAny : self.arrayFilter
        let cellAnyArray = lista[indexPath.row] as! [Any]
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
    func showAlert () {
        let alertController = UIAlertController(title: "If faut choisir au moins un verbe.", message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = tableView.rectForHeader(inSection: 1)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: dismissAlert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    

    func dismissAlert(_ sender: UIAlertAction) {
        
    }
    @objc func showQuiz() {
        choix()
        if verbesChoisi.count == 0 {
            showAlert()
        }else {
            performSegue(withIdentifier: "showQuiz", sender: Any?.self)
        }
        
    }
    
}
