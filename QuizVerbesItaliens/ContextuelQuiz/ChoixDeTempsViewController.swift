//
//  ChoixDeTempsViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-12-09.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

class ChoixDeTempsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableViewTemps: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lesTemps: UILabel!
    @IBOutlet weak var termineButton: UIButton!
    
    let sectionHeaderTableTemps: String = ""
    var tempsEtMode = [[String]]()
    var mode = [String]()
    var temps = [[String]]()
    let headerLabelTableViewTemps = UILabel()
    let fonts = FontsAndConstraintsOptions()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Le sue scelte per il Quiz".localized
        titleLabel.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        titleLabel.textColor = UIColor.white
        lesTemps.textColor = UIColor.white
        lesTemps.text =  "I Tempi".localized
        lesTemps.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        tableViewTemps.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
                if temp[1].lowercased() == ModeAndTemp().mode[0].lowercased(){
                    tempsInd.append(temp[0])
                }else if temp[1].lowercased() == ModeAndTemp().mode[1].lowercased(){
                    tempSubj.append(temp[0])
                }else if temp[1].lowercased() == ModeAndTemp().mode[2].lowercased(){
                    tempCond.append(temp[0])
                }else if temp[1].lowercased() == ModeAndTemp().mode[3].lowercased(){
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
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.font = fonts.largeBoldFont
        lesTemps.font = fonts.largeFont
    }
    override func viewDidAppear(_ animated: Bool) {
        termineButton.layer.cornerRadius = termineButton.frame.height / 2.0
        termineButton.titleLabel?.font = fonts.normalBoldFont
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header: String = ""
        header = mode[section]
        return header
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        header.textLabel?.textAlignment = .center
        header.textLabel!.textColor = UIColor.white //make the text white
        header.textLabel?.font = fonts.normalBoldFont
        header.alpha = 1.0 //make the header transparent
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int
        count = temps[section].count
        return count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var count:Int?
        count = mode.count
        return count!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell?.textLabel!.text = temps[indexPath.section][indexPath.row]
        cell!.textLabel?.textColor = UIColor.black
        cell!.textLabel?.font =  fonts.normalItaliqueBoldFont
        return (cell)!
    }
    @IBAction func termine(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
