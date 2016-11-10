//
//  VerbeFinalTableViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 16-08-18.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class VerbeFinalTableViewController: UITableViewController {
    var selectionVerbe: [String] = []
    var verbeConjugue: [String] = []
    var tempsDeVerbe: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = selectionVerbe[0]

        if let plistPath = Bundle.main.path(forResource: "ItalianVerbPlist", ofType: "plist"),
            let verbeDictionary = NSDictionary(contentsOfFile: plistPath){
            let listeDeVerbe = ListedeVerbe(verbeDictionary: verbeDictionary as! [String : [String : AnyObject]])
            let dictionnaire = listeDeVerbe.dictVerbes
            tempsDeVerbe = selectionVerbe[1] + " " + selectionVerbe[2]
            if let verb = dictionnaire[selectionVerbe[0]]?[tempsDeVerbe]{
                if selectionVerbe[1] != "Imperativo"{
                    if let io = verb["io"], let tu = verb["tu"], let lui = verb["lui, lei"], let noi = verb["noi"], let voi = verb["voi"], let loro = verb["loro"]{
                        verbeConjugue = ["io " + io, "tu " + tu, "lui " + lui, "noi " + noi, "voi " + voi, "loro " + loro]
                        // Special case of the congiuntivo verb
                        if selectionVerbe[1] == "Congiuntivo"{
                            verbeConjugue = ["che io " + io, "che tu " + tu, "che lui " + lui, "che noi " + noi, "che voi " + voi, "che loro " + loro]
                        }
                    }
                // Special case of the imperativo verbs
                }else{
                    if let tu = verb["tu"], let lui = verb["lui, lei"], let noi = verb["noi"], let voi = verb["voi"], let loro = verb["loro"]{
                         if tu == "niente"{
                            verbeConjugue = ["Per questo verbo non c'è imperativo"]
                         }else{
                            verbeConjugue = [" ", "(tu) " + tu, "(lui) " + lui, "(noi) " + noi, "(voi) " + voi, "(loro) " + loro]
                       
                        }
                        
                            
                    }
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " \(tempsDeVerbe)"
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 165/255, green: 200/255, blue: 233/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.white //make the text white
        header.alpha = 1.0 //make the header transparent
        header.textLabel?.textAlignment = NSTextAlignment.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return verbeConjugue.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = verbeConjugue[indexPath.row]
        return cell
    }
 


}
