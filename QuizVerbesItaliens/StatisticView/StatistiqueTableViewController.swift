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
    var numberOfVerbs = 0
    var selectedMode = ""
    var selectedTemp = ""
    var listeVerbe: [String] = []
    var itemFinal: [[String]] = []
    let dataController = DataController.sharedInstance
    let fonts = FontsAndConstraintsOptions()
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
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Statistiche".localized
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
        cell.labelForCell.lineBreakMode = .byWordWrapping
        let temp = temps[indexPath.section][indexPath.row]
        let mode = modes[indexPath.section]
        let resultArray = FetchResult.fetchingData(selectedMode: mode, selectedTemp: temp, listeVerbe: listeVerbe)
        let result = FetchResult.resultPertermp(resultArray: resultArray.0)
        cell.labelForCell.text = """
        \(temps[indexPath.section][indexPath.row]):
        \(result.3)
        """
        let goodResult = Double(result.0)
        let badResult = Double(result.1)
        let goodResultWithHint = Double(result.2)
        let pieChartSetUp = PieChartSetUp(entrieBon: goodResult, entrieMal: badResult, entrieAide: goodResultWithHint, pieChartView: cell.viewForCell )
        cell.viewForCell.data = pieChartSetUp.piechartData
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMode = modes[indexPath.section]
        selectedTemp = temps[indexPath.section][indexPath.row]
        numberOfVerbs = numberOfVerbsForSelection(indexPath: indexPath)
        if numberOfVerbs > 0 {
            performSegue(withIdentifier: "showDetailStat", sender: nil)
        }
        
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        numberOfVerbs = numberOfVerbsForSelection(indexPath: indexPath)
        showAlertInfoVerbs()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailStat"{
            let controller = segue.destination as! DetailStatTableViewController
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            controller.selectedMode = selectedMode
            controller.selectedTemp = selectedTemp
            controller.listeVerbe = listeVerbe
        }

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
        tableView.reloadData()
    }
    ////////////////////////////////////////////
    // MARK: ALL FUNCTIONS
    ///////////////////////////////////////////
    func numberOfVerbsForSelection(indexPath: IndexPath) -> Int{
        selectedMode = modes[indexPath.section]
        selectedTemp = temps[indexPath.section][indexPath.row]
        let resultArray = FetchResult.fetchingData(selectedMode: selectedMode, selectedTemp: selectedTemp, listeVerbe: listeVerbe)
        let tuppleOfArrays = FetchResult.resultPerVerb(resultArray: resultArray.1)
        numberOfVerbs = tuppleOfArrays.1.count
        return numberOfVerbs
    }

    func showAlertInfoVerbs () {
        let formatedString = "Numero di verbi studiati\nper questo tempo verbale %d".localized
        let alertController = UIAlertController(title: String(format: formatedString, numberOfVerbs) , message: "Fare clic su Grafico per vedere più dettagli".localized, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = tableView.rectForHeader(inSection: 1)
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
