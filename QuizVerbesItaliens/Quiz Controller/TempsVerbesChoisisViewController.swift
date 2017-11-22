//
//  TempsVerbesChoisisViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 17-09-22.
//  Copyright © 2017 Normand Martin. All rights reserved.
//

import UIKit

class TempsVerbesChoisisViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableViewTemps: UITableView!
    @IBOutlet weak var tableViewVerbes: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lesTemps: UILabel!
    @IBOutlet weak var lesVerbes: UILabel!
    let sectionHeaderTableTemps: String = ""
    let sectionHeaderTableVerbes: String = ""
    var tempsEtMode = [[String]]()
    var verbeInfinitif = [String]()
    var listeVerbe = [String]()
    var mode = [String]()
    var temps = [[String]]()
    var verbeInfinitiFinal = [String]()
    let headerLabelTableViewTemps = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Le sue scelte per il Quiz"
        titleLabel.backgroundColor = UIColor(red: 171/255, green: 203/255, blue: 235/255, alpha: 1.0)
        titleLabel.textColor = UIColor.white
        tableViewTemps.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableViewVerbes.register(UITableViewCell.self, forCellReuseIdentifier: "Cell1")
        if verbeInfinitif == ["Tous les verbes"] {
            verbeInfinitiFinal = listeVerbe
        }else{
            verbeInfinitiFinal = verbeInfinitif
        }
        for temp in tempsEtMode {
            if mode.contains(temp[1]){
            }else{
                mode.append(temp[1])
            }
        }
        for _ in mode{
            var tempsInd = [String]()
            var tempSubj = [String]()
            var tempCond = [String]()
            var tempsImp = [String]()
            for temp in tempsEtMode{
                if temp[1] == "Indicativo"{
                    tempsInd.append(temp[0])
                }else if temp[1] == "Congiuntivo"{
                    tempSubj.append(temp[0])
                }else if temp[1] == "Condizionale"{
                    tempCond.append(temp[0])
                }else if temp[1] == "Imperativo"{
                    tempsImp.append(temp[0])
                }
            }
            
            temps = [tempsInd, tempSubj, tempCond, tempsImp]
            var n = 0
            for temp in temps {
                if temp == [] {temps.remove(at: n); n = n - 1}
                n = n + 1
            }
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header: String = ""
        if tableView == self.tableViewTemps {
            
            header = mode[section]
        }
        if tableView == self.tableViewVerbes{
            header = "Infinitivo"
        }
        return header
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 151/255, green: 156/255, blue: 159/255, alpha: 1.0) //make the background color light blue
        header.textLabel?.textAlignment = .center
        header.textLabel!.textColor = UIColor.white //make the text white
        header.alpha = 1.0 //make the header transparent
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        if tableView == self.tableViewTemps {
            count = temps[section].count
        }
        if tableView == self.tableViewVerbes {
            count = verbeInfinitiFinal.count
        }
        return count!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var count:Int?
        if tableView == self.tableViewTemps {
            count = mode.count
        }
        if tableView == self.tableViewVerbes {
            count =  1
        }
        return count!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if tableView == self.tableViewTemps {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell?.textLabel!.text = temps[indexPath.section][indexPath.row]
            
        }
        
        if tableView == self.tableViewVerbes {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
            cell?.textLabel!.text = verbeInfinitiFinal[indexPath.row]
            
        }
        return (cell)!
    }


    @IBAction func termine(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
