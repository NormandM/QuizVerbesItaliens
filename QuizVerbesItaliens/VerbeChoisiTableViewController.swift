//
//  VerbeChoisiTableViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 16-08-17.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit


class VerbeChoisiTableViewController: UITableViewController {
    let sectionListe = ["INDICATIVO", "CONGIUNTIVO", "CONDIZIONALE", "IMPERATIVO"]
    let item = [["Presente", "Imperfetto", "Passato prossimo", "Futuro semplice", "Passato remoto", "Trapassato prossimo", "Trapassato remoto", "Futuro anteriore"], ["Presente", "Imperfetto", "Passato", "Trapassato"], ["Presente", "Passato"], ["Presente"]]
    var labelTextTemps: String = ""
    var labelTextInfinitif: String = ""
    var nomSection: String = ""
    var textInfinitif: String = ""
    var verbeTotal = ["", "", ""]
    var leTemps: String = ""
    var detailItem: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    // Changing backgroung colors of the header of sections
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 151/255, green: 156/255, blue: 159/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.white //make the text white
        header.alpha = 1.0 //make the header transparent
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionListe[section]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionListe.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = self.item[indexPath.section][indexPath.row]
        return cell
    }
    
// NAVIGATION:
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLeVerbeFinal2" {
            if let indexPath = self.tableView.indexPathForSelectedRow, let leTemps = tableView.cellForRow(at: indexPath)?.textLabel?.text {
                if item[indexPath.section].count == 8{
                    nomSection = "Indicativo"
                }else if item[indexPath.section].count == 4 {
                    nomSection = "Congiuntivo"
                }else if item[indexPath.section].count == 2{
                    nomSection = "Condizionale"
                }else if item[indexPath.section].count == 1{
                    nomSection = "Imperativo"
                }
                
                verbeTotal = [detailItem, nomSection, leTemps ]
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
            
            let controller = segue.destination as! VerbeFinalTableViewController
           controller.selectionVerbe = verbeTotal
           
            }
    }
  }
    


}
