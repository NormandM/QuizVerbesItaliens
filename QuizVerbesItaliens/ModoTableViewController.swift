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
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 151/255, green: 156/255, blue: 159/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 1.0 //make the header transparent
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVerbeTestView"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let verbeChoisi = self.item[indexPath.section][indexPath.row]
                let mode = self.sectionListe[indexPath.section]
                let controller = segue.destinationViewController as! VerbTestViewController
                controller.modeChoixVerbe = verbeChoisi
                controller.mode = mode
        
            }
            
            
        }
        
    }



    // MARK: - Table view data source


    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionListe[section]
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return sectionListe.count
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return item[section].count
    }
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("verbCell")!


        cell.textLabel?.text = self.item[indexPath.section][indexPath.row]
        return cell
    }



}
