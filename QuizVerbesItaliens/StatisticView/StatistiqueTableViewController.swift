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
    var itemForPieChartNumBers = [[(Int, Int, Int)]]()
    var itemFinal: [[String]] = []
    let fonts = FontsAndConstraintsOptions()
    let dataController = DataController.sharedInstance
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: ItemVerbe.identifier)
        let sortDescriptor = NSSortDescriptor(key: "verbeInfinitif", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }()
    
    let sectionListe = ["INDICATIVO", "CONGIUNTIVO", "CONDIZIONALE", "IMPERATIVO"]
    let itemInitial = [["Presente", "Imperfetto", "Passato prossimo", "Futuro semplice", "Passato remoto", "Trapassato prossimo", "Futuro anteriore", "Trapassato remoto"], ["Presente", "Passato", "Imperfetto", "Trapassato"], ["Presente", "Passato"], ["Presente"]]
    var items: [ItemVerbe] = []

    enum TempsDeVerbe: String {
        case Presente = "IndicativoPresente"
        case Imperfetto = "IndicativoImperfetto"
        case Passato = "IndicativoPassato prossimo"
        case Passatoremoto = "IndicativoPassato remoto"
        case Trapassatoprossimo = "IndicativoTrapassato prossimo"
        case Futurosemplice = "IndicativoFuturo semplice"
        case Trapassatoremoto = "IndicativoTrapassato remoto"
        case Futuroanteriore = "IndicativoFuturo anteriore"
        case CongiuntivoPresente = "CongiuntivoPresente"
        case CongiuntivoPassato = "CongiuntivoPassato"
        case CongiuntivoImperfetto = "CongiuntivoImperfetto"
        case CongiuntivoTrapassato = "CongiuntivoTrapassato"
        case CondizionalePresente = "CondizionalePresente"
        case CondizionalePassato = "CondizionalePassato"
        case ImperativoPresente = "ImperativoPresente"
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor =  UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        header.textLabel!.textColor = UIColor.white //make the text white
        header.textLabel?.font = fonts.largeBoldFont
        header.alpha = 1.0 //make the header transparent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
     }
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Statistiche"
        remiseAZeroButton.layer.cornerRadius = remiseAZeroButton.frame.height / 2.0
        remiseAZeroButton.titleLabel?.font = fonts.normalBoldFont
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionListe[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionListe.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemInitial[section].count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height * 0.05
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StatistiqueViewCell
        cell.labelForCell.font = fonts.normalItaliqueBoldFont
        cell.labelForCell.textAlignment = .center
        cell.labelForCell.numberOfLines = 0
        cell.labelForCell.text = self.itemFinal[indexPath.section][indexPath.row]
        let entrieBon = Double(itemForPieChartNumBers[indexPath.section][indexPath.row].0)
        let entrieMal = Double(itemForPieChartNumBers[indexPath.section][indexPath.row].1)
        let entrieAide = Double(itemForPieChartNumBers[indexPath.section][indexPath.row].2)
        let pieChartSetUp = PieChartSetUp(entrieBon: entrieBon, entrieMal: entrieMal, entrieAide: entrieAide, pieChartView: cell.viewForCell )
        cell.viewForCell.data = pieChartSetUp.piechartData
        return cell    }
//////////////////////////////////////
// MARK: All Buttons and actions
//////////////////////////////////////

     @IBAction func remettreAZero(_ sender: UIBarButtonItem) {
        remiseAZeroButton.tintColor = UIColor.black
        do {
            let items = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for item in items {
                managedObjectContext.delete(item)
            }
            try managedObjectContext.save()
            
        } catch {
            // Error Handling
            // ...
        }
        
        populateData()
        tableView.reloadData()
        // Save Changes
    }
////////////////////////////////////////////
// MARK: ALL FUNCTIONS
///////////////////////////////////////////
    func populateData() {
        var IndicativoPresenteP: String = ""
        var IndicativoImperfettoP: String = ""
        var IndicativoPassatoprossimoP: String = ""
        var IndicativoPassatoremotoP: String = ""
        var IndicativoTrapassatoprossimoP: String = ""
        var IndicativoFuturosempliceP: String = ""
        var IndicativoTrapassatoremotoP: String = ""
        var IndicativoFuturoanterioreP: String = ""
        var CongiuntivoPresenteP: String = ""
        var CongiuntivoPassatoP: String = ""
        var CongiuntivoImperfettoP: String = ""
        var CongiuntivoTrapassatoP: String = ""
        var CondizionalePresenteP: String = ""
        var CondizionalePassatoP: String = ""
        var ImperativoPresenteP: String = ""
        var IndicativoPresenteB: Int = 0
        var IndicativoPresenteA: Int = 0
        var IndicativoPresenteM: Int = 0
        var IndicativoImperfettoB: Int = 0
        var IndicativoImperfettoA: Int = 0
        var IndicativoImperfettoM: Int = 0
        var IndicativoPassatoprossimoB: Int = 0
        var IndicativoPassatoprossimoA: Int = 0
        var IndicativoPassatoprossimoM: Int = 0
        var IndicativoPassatoremotoB: Int = 0
        var IndicativoPassatoremotoA: Int = 0
        var IndicativoPassatoremotoM: Int = 0
        var IndicativoTrapassatoprossimoB: Int = 0
        var IndicativoTrapassatoprossimoA: Int = 0
        var IndicativoTrapassatoprossimoM: Int = 0
        var IndicativoFuturosempliceB: Int = 0
        var IndicativoFuturosempliceA: Int = 0
        var IndicativoFuturosempliceM: Int = 0
        var IndicativoTrapassatoremotoB: Int = 0
        var IndicativoTrapassatoremotoA: Int = 0
        var IndicativoTrapassatoremotoM: Int = 0
        var IndicativoFuturoanterioreB: Int = 0
        var IndicativoFuturoanterioreA: Int = 0
        var IndicativoFuturoanterioreM: Int = 0
        var CongiuntivoPresenteB: Int = 0
        var CongiuntivoPresenteA: Int = 0
        var CongiuntivoPresenteM: Int = 0
        var CongiuntivoPassatoB: Int = 0
        var CongiuntivoPassatoA: Int = 0
        var CongiuntivoPassatoM: Int = 0
        var CongiuntivoImperfettoB: Int = 0
        var CongiuntivoImperfettoA: Int = 0
        var CongiuntivoImperfettoM: Int = 0
        var CongiuntivoTrapassatoB: Int = 0
        var CongiuntivoTrapassatoA: Int = 0
        var CongiuntivoTrapassatoM: Int = 0
        var CondizionalePresenteB: Int = 0
        var CondizionalePresenteA: Int = 0
        var CondizionalePresenteM: Int = 0
        var CondizionalePassatoB: Int = 0
        var CondizionalePassatoA: Int = 0
        var CondizionalePassatoM: Int = 0
        var ImperativoPresenteB: Int = 0
        var ImperativoPresenteA: Int = 0
        var ImperativoPresenteM: Int = 0
        do {
            items = try managedObjectContext.fetch(fetchRequest) as! [ItemVerbe]
        }catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        for item in items {
            var modiEtTempi = String(item.modeVerbe!)
            modiEtTempi.capitalizeFirstLetter()
            if let tempVerbe = TempsDeVerbe(rawValue: (modiEtTempi + item.tempsVerbe!)){
                switch tempVerbe {
                case .Presente:
                    IndicativoPresenteB = IndicativoPresenteB + Int(item.bonneReponse)
                    IndicativoPresenteM = IndicativoPresenteM + Int(item.mauvaiseReponse)
                    IndicativoPresenteA = IndicativoPresenteA + Int(item.bonneReponseTemps)
                case .CondizionalePassato:
                    CondizionalePassatoB = CondizionalePassatoB + Int(item.bonneReponse)
                    CondizionalePassatoM = CondizionalePassatoM + Int(item.mauvaiseReponse)
                    CondizionalePassatoA = CondizionalePassatoA + Int(item.bonneReponseTemps)
                case .CondizionalePresente:
                    CondizionalePresenteB = CondizionalePresenteB + Int(item.bonneReponse)
                    CondizionalePresenteM = CondizionalePresenteM + Int(item.mauvaiseReponse)
                    CondizionalePresenteA = CondizionalePresenteA + Int(item.bonneReponseTemps)
                case .Futuroanteriore:
                    IndicativoFuturoanterioreB = IndicativoFuturoanterioreB + Int(item.bonneReponse)
                    IndicativoFuturoanterioreM = IndicativoFuturoanterioreM + Int(item.mauvaiseReponse)
                    IndicativoFuturoanterioreA = IndicativoFuturoanterioreA + Int(item.bonneReponseTemps)
                case .Futurosemplice:
                    IndicativoFuturosempliceB = IndicativoFuturosempliceB + Int(item.bonneReponse)
                    IndicativoFuturosempliceM = IndicativoFuturosempliceM + Int(item.mauvaiseReponse)
                    IndicativoFuturosempliceA = IndicativoFuturosempliceA + Int(item.bonneReponseTemps)
                case .Imperfetto:
                    IndicativoImperfettoB = IndicativoImperfettoB + Int(item.bonneReponse)
                    IndicativoImperfettoM = IndicativoImperfettoM + Int(item.mauvaiseReponse)
                    IndicativoImperfettoA = IndicativoImperfettoA + Int(item.bonneReponseTemps)
                case .ImperativoPresente:
                    ImperativoPresenteB = ImperativoPresenteB + Int(item.bonneReponse)
                    ImperativoPresenteM = ImperativoPresenteM + Int(item.mauvaiseReponse)
                    ImperativoPresenteA = ImperativoPresenteA + Int(item.bonneReponseTemps)
                case .Passato:
                    IndicativoPassatoprossimoB = IndicativoPassatoprossimoB + Int(item.bonneReponse)
                    IndicativoPassatoprossimoM = IndicativoPassatoprossimoM + Int(item.mauvaiseReponse)
                    IndicativoPassatoprossimoA = IndicativoPassatoprossimoA + Int(item.bonneReponseTemps)
                case .Trapassatoprossimo:
                    IndicativoTrapassatoprossimoB = IndicativoTrapassatoprossimoB + Int(item.bonneReponse)
                    IndicativoTrapassatoprossimoM = IndicativoTrapassatoprossimoM + Int(item.mauvaiseReponse)
                    IndicativoTrapassatoprossimoA = IndicativoTrapassatoprossimoA + Int(item.bonneReponseTemps)
                case .Passatoremoto:
                    IndicativoPassatoremotoB = IndicativoPassatoremotoB + Int(item.bonneReponse)
                    IndicativoPassatoremotoM = IndicativoPassatoremotoM + Int(item.mauvaiseReponse)
                    IndicativoPassatoremotoA = IndicativoPassatoremotoA + Int(item.bonneReponseTemps)
                case .Trapassatoremoto:
                    IndicativoTrapassatoremotoB = IndicativoTrapassatoremotoB + Int(item.bonneReponse)
                    IndicativoTrapassatoremotoM = IndicativoTrapassatoremotoM + Int(item.mauvaiseReponse)
                    IndicativoTrapassatoremotoA = IndicativoTrapassatoremotoA + Int(item.bonneReponseTemps)
                case .CongiuntivoImperfetto:
                    CongiuntivoImperfettoB = CongiuntivoImperfettoB + Int(item.bonneReponse)
                    CongiuntivoImperfettoM = CongiuntivoImperfettoM + Int(item.mauvaiseReponse)
                    CongiuntivoImperfettoA = CongiuntivoImperfettoA + Int(item.bonneReponseTemps)
                case .CongiuntivoPassato:
                    CongiuntivoPassatoB = CongiuntivoPassatoB + Int(item.bonneReponse)
                    CongiuntivoPassatoM = CongiuntivoPassatoM + Int(item.mauvaiseReponse)
                    CongiuntivoPassatoA = CongiuntivoPassatoA + Int(item.bonneReponseTemps)
                case .CongiuntivoTrapassato:
                    CongiuntivoTrapassatoB = CongiuntivoTrapassatoB + Int(item.bonneReponse)
                    CongiuntivoTrapassatoM = CongiuntivoTrapassatoM + Int(item.mauvaiseReponse)
                    CongiuntivoTrapassatoA = CongiuntivoTrapassatoA + Int(item.bonneReponseTemps)
                case .CongiuntivoPresente:
                    CongiuntivoPresenteB = CongiuntivoPresenteB + Int(item.bonneReponse)
                    CongiuntivoPresenteM = CongiuntivoPresenteM + Int(item.mauvaiseReponse)
                    CongiuntivoPresenteA = CongiuntivoPresenteA + Int(item.bonneReponseTemps)
                }
            }
            
        }
        IndicativoPresenteP = "Presente: " + pourcentage(corrette: IndicativoPresenteB, sbagliate: IndicativoPresenteM, aiuto: IndicativoPresenteA)
        IndicativoImperfettoP = "Imperfetto: " + pourcentage(corrette: IndicativoImperfettoB, sbagliate: IndicativoImperfettoM, aiuto: IndicativoImperfettoA)
        IndicativoPassatoprossimoP = "Passato prossimo: " + pourcentage(corrette: IndicativoPassatoprossimoB, sbagliate: IndicativoPassatoprossimoM, aiuto: IndicativoPassatoprossimoA)
        IndicativoPassatoremotoP = "Passato remoto: " + pourcentage(corrette: IndicativoPassatoremotoB, sbagliate: IndicativoPassatoremotoM, aiuto: IndicativoPassatoremotoA)
        IndicativoTrapassatoprossimoP = "Trapassato prossimo: " + pourcentage(corrette: IndicativoTrapassatoprossimoB, sbagliate: IndicativoTrapassatoprossimoM, aiuto: IndicativoTrapassatoprossimoA)
        IndicativoFuturosempliceP = "Futuro semplice: " + pourcentage(corrette: IndicativoFuturosempliceB, sbagliate: IndicativoFuturosempliceM, aiuto: IndicativoFuturosempliceA)
        IndicativoTrapassatoremotoP = "Trapassato remoto: " + pourcentage(corrette: IndicativoTrapassatoremotoB, sbagliate: IndicativoTrapassatoremotoM, aiuto: IndicativoTrapassatoremotoA)
        IndicativoFuturoanterioreP = "Futuro anteriore " + pourcentage(corrette: IndicativoFuturoanterioreB, sbagliate: IndicativoFuturoanterioreM, aiuto: IndicativoFuturoanterioreA)
        CongiuntivoPresenteP = "Presente: " + pourcentage(corrette: CongiuntivoPresenteB, sbagliate: CongiuntivoPresenteM, aiuto: CongiuntivoPresenteA)
        CongiuntivoPassatoP = "Passato: " + pourcentage(corrette: CongiuntivoPassatoB, sbagliate: CongiuntivoPassatoM, aiuto: CongiuntivoPassatoA)
        CongiuntivoImperfettoP = "Imperfetto: " + pourcentage(corrette: CongiuntivoImperfettoB, sbagliate: CongiuntivoImperfettoM, aiuto: CongiuntivoImperfettoA)
        CongiuntivoTrapassatoP = "Trapassato: " + pourcentage(corrette: CongiuntivoTrapassatoB, sbagliate: CongiuntivoTrapassatoM, aiuto: CongiuntivoTrapassatoA)
        CondizionalePresenteP = "Presente: " + pourcentage(corrette: CondizionalePresenteB, sbagliate: CondizionalePresenteM, aiuto: CondizionalePresenteA)
        CondizionalePassatoP = "Passato: " + pourcentage(corrette: CondizionalePassatoB, sbagliate: CondizionalePassatoM, aiuto: CondizionalePassatoA)
        ImperativoPresenteP = "Presente: " + pourcentage(corrette: ImperativoPresenteB, sbagliate: ImperativoPresenteM, aiuto: ImperativoPresenteA)
        itemFinal = [[IndicativoPresenteP, IndicativoImperfettoP, IndicativoPassatoprossimoP, IndicativoFuturosempliceP, IndicativoPassatoremotoP, IndicativoTrapassatoprossimoP, IndicativoFuturoanterioreP, IndicativoTrapassatoremotoP], [CongiuntivoPresenteP, CongiuntivoPassatoP, CongiuntivoImperfettoP, CongiuntivoTrapassatoP], [CondizionalePresenteP, CondizionalePassatoP], [ImperativoPresenteP]]
        itemForPieChartNumBers = [[(corrette: IndicativoPresenteB, sbaliate: IndicativoPresenteM, con_aiuta: IndicativoPresenteA), (IndicativoImperfettoB, IndicativoImperfettoM,IndicativoImperfettoA), (IndicativoPassatoprossimoB, IndicativoPassatoprossimoM, IndicativoPassatoprossimoA), (IndicativoFuturosempliceB, IndicativoFuturosempliceM, IndicativoFuturosempliceA),(IndicativoPassatoremotoB, IndicativoPassatoremotoM, IndicativoPassatoremotoA), (bonne: IndicativoTrapassatoprossimoB, mauvaise: IndicativoTrapassatoprossimoM, aide: IndicativoTrapassatoprossimoA), (bonne: IndicativoFuturoanterioreB, mauvaise: IndicativoFuturoanterioreM, aide: IndicativoFuturoanterioreA), (IndicativoTrapassatoremotoB, IndicativoTrapassatoremotoM, IndicativoTrapassatoremotoA)],  [(CongiuntivoPresenteB, CongiuntivoPresenteM, CongiuntivoPresenteA), (CongiuntivoPassatoB, mauvaise: CongiuntivoPassatoM, aide: CongiuntivoPassatoA), (CongiuntivoImperfettoB, CongiuntivoImperfettoM, CongiuntivoImperfettoA), (CongiuntivoTrapassatoB, CongiuntivoTrapassatoM, CongiuntivoTrapassatoA)], [(CondizionalePresenteB, CondizionalePresenteM, CondizionalePresenteA), (CondizionalePassatoB, CondizionalePassatoM, CondizionalePassatoA)], [(ImperativoPresenteB, ImperativoPresenteM, ImperativoPresenteA)]]
    }
    func pourcentage (corrette: Int, sbagliate: Int, aiuto: Int) -> String{
        var result = ""
        if (corrette + sbagliate + aiuto) != 0 {
            result = String(round (Double(corrette + aiuto) / Double(corrette + sbagliate + aiuto) * 100)) + "%"
        }else{
            result = "_"
        }
        return result
    }
}
