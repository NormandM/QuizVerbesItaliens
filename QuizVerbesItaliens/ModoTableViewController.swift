//
//  ModoTableViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 16-01-21.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class ModoTableViewController: UITableViewController {
    let sectionListe = ["A CASO", "TERMINAZIONI DEI VERBI", "INDICATIVO", "CONGIUNTIVO", "CONDIZIONALE", "IMPERATIVO"]
    let item = [["Tutti i verbi"], ["are", "ere", "ire"], ["Presente", "Imperfetto", "Passato prossimo", "Futuro semplice", "Passato remoto", "Trapassato prossimo", "Trapassato remoto", "Futuro anteriore"], ["Presente", "Imperfetto", "Passato", "Trapassato"], ["Presente", "Passato"], ["Presente"]]
    let titreSection: String = ""
    
    // Changing backgroung colors of the header of sections
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 151/255, green: 156/255, blue: 159/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.white //make the text white
        header.alpha = 1.0 //make the header transparent
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVerbeTestView"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let verbeChoisi = self.item[indexPath.section][indexPath.row]
                let mode = self.sectionListe[indexPath.section]
                let controller = segue.destination as! VerbTestViewController
                controller.modeChoixVerbe = verbeChoisi
                controller.mode = mode
        
            }
            
            
        }
        
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
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "verbCell")!
        cell.textLabel?.text = self.item[indexPath.section][indexPath.row]
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

        
        return cell
    }



}
