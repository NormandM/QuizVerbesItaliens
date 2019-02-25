//
//  StatistiqueTableViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-11.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import CoreData
import Charts


class StatistiqueTableViewController: UITableViewController {
     @IBOutlet weak var remiseAZeroButton: UIButton!
    let modeAndTemp = ModeAndTemp()
    lazy var modes = modeAndTemp.mode
    lazy var temps = modeAndTemp.temp
    var itemFinal: [[String]] = []
    let dataController = DataController.sharedInstance
    let fonts = FontsAndConstraintsOptions()
    var  arrayFinal = [[(Int,Int,Int, String)]]()
    var arrayStringFinal = [[String]]()
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: ItemVerbe.identifier)
        return request
    }()
    var items: [ItemVerbe] = []
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor =  UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        header.textLabel!.textColor = UIColor.white //make the text white
        header.textLabel?.font = fonts.largeBoldFont
        header.alpha = 1.0 //make the header transparent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingData()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Statistiche"
        remiseAZeroButton.layer.cornerRadius = remiseAZeroButton.frame.height / 2.0
        remiseAZeroButton.titleLabel?.font = fonts.normalBoldFont
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return modes[section]
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height * 0.05
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return modes.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temps[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StatistiqueViewCell
        cell.labelForCell.font = fonts.normalItaliqueBoldFont
        cell.labelForCell.textAlignment = .center
        cell.labelForCell.numberOfLines = 0
        cell.labelForCell.text = """
        \(temps[indexPath.section][indexPath.row]):
        \(arrayStringFinal[indexPath.section][indexPath.row])
        """
        let entrieBon = Double(arrayFinal[indexPath.section][indexPath.row].0)
        let entrieAide = Double(arrayFinal[indexPath.section][indexPath.row].1)
        let entrieMal = Double(arrayFinal[indexPath.section][indexPath.row].2)
        let pieChartSetUp = PieChartSetUp(entrieBon: entrieBon, entrieMal: entrieMal, entrieAide: entrieAide, pieChartView: cell.viewForCell )
        cell.viewForCell.data = pieChartSetUp.piechartData
        return cell
    }
    //////////////////////////////////////
    // MARK: All Buttons and actions
    //////////////////////////////////////
    @IBAction func remettreAZero(_ sender: UIButton) {
        remiseAZeroButton.tintColor = UIColor.black
        do {
            let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedObjectContext.delete(item)
            }
            try managedObjectContext.save()
        } catch {
            // Error Handl
        }
        fetchingData()
        tableView.reloadData()
    }
    ////////////////////////////////////////////
    // MARK: ALL FUNCTIONS
    ///////////////////////////////////////////
    func fetchingData() {
        var resultArray = [(Int, Int, Int, String)]()
        var resultStringArray = [String]()
        var n = 0

        for mode in modes{
            for temp in temps[n]{
                let result = FetchRequest.evaluate(modeVerb: mode.lowercased().capitalizingFirstLetter(), tempsVerb: temp)
                resultArray.append(result)
                resultStringArray.append(result.3)
            }
            n = n + 1
        }
        var indexResult = 0
        var arrayIndcatif = [(Int, Int, Int, String)]()
        var arrayStringIndicatif = [String]()
        var arraySubjonctif = [(Int, Int, Int, String)]()
        var arrayStringSubjonctif = [String]()
        var arrayConditionnel = [(Int, Int, Int, String)]()
        var arrayStringConditionnel = [String]()
        var arrayImpératif = [(Int, Int, Int, String)]()
        var arrayStringImpératif = [String]()
        for _ in temps[0]{
            arrayIndcatif.append(resultArray[indexResult])
            arrayStringIndicatif.append(resultStringArray[indexResult])
            indexResult = indexResult + 1
        }
        for _ in temps[1] {
            arraySubjonctif.append(resultArray[indexResult])
            arrayStringSubjonctif.append(resultStringArray[indexResult])
            indexResult = indexResult + 1
            
        }
        for _ in temps[2] {
            arrayConditionnel.append(resultArray[indexResult])
            arrayStringConditionnel.append(resultStringArray[indexResult])
            indexResult = indexResult + 1
        }
        for _ in temps[3] {
            arrayImpératif.append(resultArray[indexResult])
            arrayStringImpératif.append(resultStringArray[indexResult])
            indexResult = indexResult + 1
        }
        arrayFinal = [arrayIndcatif, arraySubjonctif, arrayConditionnel, arrayImpératif]
        arrayStringFinal = [arrayStringIndicatif, arrayStringSubjonctif, arrayStringConditionnel, arrayStringImpératif]
    }
}
