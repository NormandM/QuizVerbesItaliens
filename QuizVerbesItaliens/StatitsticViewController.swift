//
//  StatitsticViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 16-01-10.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import Foundation
var indPresent: String = ""
var indImperfetto: String = ""
var indPassatoProssimo: String = ""
var indFuturoSimplice: String = ""
var indPassatoRemoto: String = ""
var indTrapassatoProssimo: String = ""
var indTrapassatoRemoto: String = ""
var indFuturoAnteriore: String = ""
var congPresente: String = ""
var congImperfetto: String = ""
var congPassato: String = ""
var congTrapassato: String = ""
var condPresente: String = ""
var condPassato: String = ""
var impPresente: String = ""
let titreSection: String = ""
var verbAre: String = ""
var verbEre: String = ""
var verbIre: String = ""
let sectionListe = ["TERMINAZIONI DEI VERBI", "INDICATIVO", "CONGIUNTIVO", "CONDIZIONALE", "IMPERATIVO"]
var item = [[verbAre, verbEre, verbIre], [indPresent, indImperfetto, indPassatoProssimo, indFuturoSimplice, indPassatoRemoto, indTrapassatoProssimo, indTrapassatoRemoto, indFuturoAnteriore], [congPresente, congImperfetto, congPassato, congTrapassato], [condPresente, condPassato], [impPresente]]


class StatitsticViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var verbesStatistics: [String] = infinitif
    var tempsStatistics: [String] = tempsVerbe
    var temps: [String] = []
    var verbeStatistic: String = ""
    var tempsStatistic: String = ""
    var tempsStat: String = ""
    var verbeClasse = ["": 0.0]
    var bonneReponseAr = 0.0
    var mauvaiseReponseAr = 0.0
    var bonneReponseIr = 0.0
    var mauvaiseReponseEr = 0.0
    var mauvaiseReponseIr = 0.0
    var bonneReponseEr = 0.0
    let sectionListe = ["TERMINAZIONI DEI VERBI", "INDICATIVO", "CONGIUNTIVO", "CONDIZIONALE", "IMPERATIVO"]
    var item = [[verbAre, verbEre, verbIre], [indPresent, indImperfetto, indPassatoProssimo, indFuturoSimplice, indPassatoRemoto, indTrapassatoProssimo, indTrapassatoRemoto, indFuturoAnteriore], [congPresente, congImperfetto, congPassato, congTrapassato], [condPresente, condPassato], [impPresente]]

    
    // Changing backgroung colors of the header of sections
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 151/255, green: 156/255, blue: 159/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.whiteColor() //make the text white
        header.alpha = 1.0 
    }
    
    override func viewDidLoad() {

        var a: Int = 0
        var e: Int = 0
        var i: Int = 0
        self.navigationItem.title = "Statistiche per gruppi"
        let reponse = NSUserDefaults.standardUserDefaults()
        // Retrieving Statistics for groups: are, ere, ire
        for verbeStatistic in verbesStatistics {
        // Making sure any Nil result is replaced by 0
            if reponse.arrayForKey(verbeStatistic) == nil {
                reponse.setObject([0, 0], forKey: verbeStatistic)

            }else {
                let statReponse = reponse.arrayForKey(verbeStatistic) as! [Double]
                let lastCharacters = verbeStatistic[verbeStatistic.endIndex.predecessor().predecessor().predecessor()]
          // If the group doest not have 0 results retrieve the data by the different groups
                if statReponse[0] + statReponse[1] != 0 {
                    if lastCharacters == "a" {
                        bonneReponseAr = bonneReponseAr + statReponse[0]
                        mauvaiseReponseAr = mauvaiseReponseAr + statReponse[1]
                        verbAre =  "are: \(round(bonneReponseAr / (bonneReponseAr + mauvaiseReponseAr) * 100))%"
                        a += 1
                    }else if lastCharacters == "e" {
                        bonneReponseEr = bonneReponseEr + statReponse[0]
                        mauvaiseReponseEr = mauvaiseReponseEr + statReponse[1]
                        verbEre =  "ere: \(round(bonneReponseEr / (bonneReponseEr + mauvaiseReponseEr) * 100))%"
                        e += 1
                    }else if lastCharacters == "i" {
                        bonneReponseIr = bonneReponseIr + statReponse[0]
                        mauvaiseReponseIr = mauvaiseReponseIr + statReponse[1]
                        verbIre =  "ire: \(round(bonneReponseIr / (bonneReponseIr + mauvaiseReponseIr) * 100))%"
                        i += 1
                    }

                    
                }
                 
            }
            
        }
        // Displaying "⎯⎯" if the group as no data that is a 0 result
        if a == 0 {
            verbAre = "are: ⎯⎯"
        }
        if e == 0 {
            verbEre = "ere: ⎯⎯"
        }
        if i == 0 {
            verbIre = "ire: ⎯⎯"
        }
        // Retrieveing results for differente Verb Tense
        for tempsStatistic in tempsStatistics {
            // Making sure any Nil result is replaced by 0
            if reponse.arrayForKey(tempsStatistic) == nil {
                reponse.setObject([0,0], forKey: tempsStatistic)
            }else{
                let statTemps = reponse.arrayForKey(tempsStatistic) as! [Double]
            // For each Verb tense if results are 0 displaying: "⎯⎯"
                if statTemps[0] + statTemps[1] == 0{
                    temps = temps + [("\(tempsStatistic): ⎯⎯")]
                }else{
            // Retrieveing the data for each Verb Tense and displaying in %
                    let pourcentageTemps = round(statTemps[0] / (statTemps[0] + statTemps[1])*100)
                    temps = temps + [("\(tempsStatistic): \(pourcentageTemps)%")]
                }
                
            }
          
        }
        if temps != [] {
            statCalc()
        item = [[verbAre, verbEre, verbIre], [indPresent, indImperfetto, indPassatoProssimo, indFuturoSimplice, indPassatoRemoto, indTrapassatoProssimo, indTrapassatoRemoto, indFuturoAnteriore], [congPresente, congImperfetto, congPassato, congTrapassato], [condPresente, condPassato], [impPresente]]
        
    
        }
        
       
    }
    // Identifying name of each section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionListe[section]
    }
    // Identifying the numer of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionListe.count
    }
    // Identifying numer of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return item[section].count
        
    }
    // Populating each line of the Table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("verbCell2")!
        cell.textLabel!.text = self.item[indexPath.section][indexPath.row]
        return cell
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // The purpose of this button is to reset all data to 0
    @IBAction func rimettereAZaero() {
        let reponse = NSUserDefaults.standardUserDefaults()
        
        for verbeStatistic in verbesStatistics {
            reponse.setObject([0, 0], forKey: verbeStatistic)
            }
        
        verbAre = "are: ⎯⎯"
        verbEre = "ere: ⎯⎯"
        verbIre = "ire: ⎯⎯"
        temps = [""]
        
        for tempsStatistic in tempsStatistics {
            reponse.setObject([0,0], forKey: tempsStatistic)
            temps = temps + [("\(tempsStatistic): ⎯⎯")]
        }
        temps.removeFirst()
// Label references
        statCalc()
        item = [[verbAre, verbEre, verbIre], [indPresent, indImperfetto, indPassatoProssimo, indFuturoSimplice, indPassatoRemoto, indTrapassatoProssimo, indTrapassatoRemoto, indFuturoAnteriore], [congPresente, congImperfetto, congPassato, congTrapassato], [condPresente, condPassato], [impPresente]]
        loadView()
    }
// This function arranges the Verbe Tense in the same way they are found in the Plist
    func statCalc() -> AnyObject {
        for temp in temps {
            let tempSepare = temp.componentsSeparatedByString(" ")
            if tempSepare[0] == "Indicativo"{
                if tempSepare[1] == "Presente:" {
                    indPresent = tempSepare[1] + " " + tempSepare[2]
                }else if tempSepare[1] == "Imperfetto:"{
                    indImperfetto = tempSepare[1] + " " + tempSepare[2]
                }else if tempSepare[1] == "Passato" && tempSepare[2] == "prossimo:"{
                    indPassatoProssimo = tempSepare[1] + " " + tempSepare[2] + " " + tempSepare[3]
                }else if tempSepare[1] == "Futuro" && tempSepare[2] == "semplice:"{
                    indFuturoSimplice = tempSepare[1] + " " + tempSepare[2] + " " + tempSepare[3]
                }else if tempSepare[1] == "Passato" && tempSepare[2] == "remoto:"{
                    indPassatoRemoto = tempSepare[1] + " " + tempSepare[2] + " " + tempSepare[3]
                }else if tempSepare[1] == "Trapassato" && tempSepare[2] == "prossimo:"{
                    indTrapassatoProssimo = tempSepare[1] + " " + tempSepare[2] + " " + tempSepare[3]
                }else if tempSepare[1] == "Trapassato" && tempSepare[2] == "remoto:"{
                    indTrapassatoRemoto = tempSepare[1] + " " + tempSepare[2] + " " + tempSepare[3]
                }else if tempSepare[1] == "Futuro" && tempSepare[2] == "anteriore:"{
                    indFuturoAnteriore = tempSepare[1] + " " + tempSepare[2] + " " + tempSepare[3]
                }
            }else if tempSepare[0] == "Congiuntivo"{
                if tempSepare[1] == "Presente:"{
                    congPresente = tempSepare[1] + " " + tempSepare[2]
                }else if tempSepare[1] == "Imperfetto:"{
                    congImperfetto = tempSepare[1] + " " + tempSepare[2]
                }else if tempSepare[1] == "Passato:"{
                    congPassato = tempSepare[1] + " " + tempSepare[2]
                }else if tempSepare[1] == "Trapassato:"{
                    congTrapassato = tempSepare[1] + " " + tempSepare[2]
                }
            }else if tempSepare[0] == "Condizionale"{
                if tempSepare[1] == "Presente:"{
                    condPresente = tempSepare[1] + " " + tempSepare[2]
                }else if tempSepare[1] == "Passato:"{
                    condPassato = tempSepare[1] + " " + tempSepare[2]
                }
                
            }else if tempSepare[0] == "Imperativo"{
                impPresente = tempSepare[1] + " " + tempSepare[2]
            }
        }
    //Returns an array composed of all the groups
      return item
    }
    
}
