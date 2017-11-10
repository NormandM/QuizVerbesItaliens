//
//  StatistiqueTableViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-11.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import CoreData

class StatistiqueTableViewController: UITableViewController {
    @IBOutlet weak var remettreAZero: UIBarButtonItem!
    
    var itemFinal: [[String]] = []
    
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
        header.contentView.backgroundColor = UIColor(red: 151/255, green: 156/255, blue: 159/255, alpha: 1.0) //make the background color light blue
        header.textLabel!.textColor = UIColor.white //make the text white
        header.alpha = 1.0 //make the header transparent
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Statistiche"
        populateData()
 
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
 
        cell.textLabel?.text = self.itemFinal[indexPath.section][indexPath.row]
        return cell
    }
//////////////////////////////////////
// MARK: All Buttons and actions
//////////////////////////////////////

     @IBAction func remettreAZero(_ sender: UIBarButtonItem) {
        remettreAZero.tintColor = UIColor.black
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
        var IndicativoPresenteM: Int = 0
        var IndicativoImperfettoB: Int = 0
        var IndicativoImperfettoM: Int = 0
        var IndicativoPassatoprossimoB: Int = 0
        var IndicativoPassatoprossimoM: Int = 0
        var IndicativoPassatoremotoB: Int = 0
        var IndicativoPassatoremotoM: Int = 0
        var IndicativoTrapassatoprossimoB: Int = 0
        var IndicativoTrapassatoprossimoM: Int = 0
        var IndicativoFuturosempliceB: Int = 0
        var IndicativoFuturosempliceM: Int = 0
        var IndicativoTrapassatoremotoB: Int = 0
        var IndicativoTrapassatoremotoM: Int = 0
        var IndicativoFuturoanterioreB: Int = 0
        var IndicativoFuturoanterioreM: Int = 0
        var CongiuntivoPresenteB: Int = 0
        var CongiuntivoPresenteM: Int = 0
        var CongiuntivoPassatoB: Int = 0
        var CongiuntivoPassatoM: Int = 0
        var CongiuntivoImperfettoB: Int = 0
        var CongiuntivoImperfettoM: Int = 0
        var CongiuntivoTrapassatoB: Int = 0
        var CongiuntivoTrapassatoM: Int = 0
        var CondizionalePresenteB: Int = 0
        var CondizionalePresenteM: Int = 0
        var CondizionalePassatoB: Int = 0
        var CondizionalePassatoM: Int = 0
        var ImperativoPresenteB: Int = 0
        var ImperativoPresenteM: Int = 0


        do {
            items = try managedObjectContext.fetch(fetchRequest) as! [ItemVerbe]
            
        }catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        for item in items {
            if let tempVerbe = TempsDeVerbe(rawValue: (item.modeVerbe! + item.tempsVerbe!)){

                switch tempVerbe {
                    
                case .Presente:
                    IndicativoPresenteB = IndicativoPresenteB + Int(item.bonneReponse)
                    IndicativoPresenteM = IndicativoPresenteM + Int(item.mauvaiseReponse)
                case .CondizionalePassato:
                    CondizionalePassatoB = CondizionalePassatoB + Int(item.bonneReponse)
                    CondizionalePassatoM = CondizionalePassatoM + Int(item.mauvaiseReponse)
                case .CondizionalePresente:
                    CondizionalePresenteB = CondizionalePresenteB + Int(item.bonneReponse)
                    CondizionalePresenteM = CondizionalePresenteM + Int(item.mauvaiseReponse)
                case .Futuroanteriore:
                    IndicativoFuturoanterioreB = IndicativoFuturoanterioreB + Int(item.bonneReponse)
                    IndicativoFuturoanterioreM = IndicativoFuturoanterioreM + Int(item.mauvaiseReponse)
                case .Futurosemplice:
                    IndicativoFuturosempliceB = IndicativoFuturosempliceB + Int(item.bonneReponse)
                    IndicativoFuturosempliceM = IndicativoFuturosempliceM + Int(item.mauvaiseReponse)
                case .Imperfetto:
                    IndicativoImperfettoB = IndicativoImperfettoB + Int(item.bonneReponse)
                    IndicativoImperfettoM = IndicativoImperfettoM + Int(item.mauvaiseReponse)
                case .ImperativoPresente:
                    ImperativoPresenteB = ImperativoPresenteB + Int(item.bonneReponse)
                    ImperativoPresenteM = ImperativoPresenteM + Int(item.mauvaiseReponse)
                case .Passato:
                    IndicativoPassatoprossimoB = IndicativoPassatoprossimoB + Int(item.bonneReponse)
                    IndicativoPassatoprossimoM = IndicativoPassatoprossimoM + Int(item.mauvaiseReponse)
                case .Trapassatoprossimo:
                    IndicativoTrapassatoprossimoB = IndicativoTrapassatoprossimoB + Int(item.bonneReponse)
                    IndicativoTrapassatoprossimoM = IndicativoTrapassatoprossimoM + Int(item.mauvaiseReponse)
                case .Passatoremoto:
                    IndicativoPassatoremotoB = IndicativoPassatoremotoB + Int(item.bonneReponse)
                    IndicativoPassatoremotoM = IndicativoPassatoremotoM + Int(item.mauvaiseReponse)
                case .Trapassatoremoto:
                    IndicativoTrapassatoremotoB = IndicativoTrapassatoremotoB + Int(item.bonneReponse)
                    IndicativoTrapassatoremotoM = IndicativoTrapassatoremotoM + Int(item.mauvaiseReponse)
                case .CongiuntivoImperfetto:
                    CongiuntivoImperfettoB = CongiuntivoImperfettoB + Int(item.bonneReponse)
                    CongiuntivoImperfettoM = CongiuntivoImperfettoM + Int(item.mauvaiseReponse)
                case .CongiuntivoPassato:
                    CongiuntivoPassatoB = CongiuntivoPassatoB + Int(item.bonneReponse)
                    CongiuntivoPassatoM = CongiuntivoPassatoM + Int(item.mauvaiseReponse)
                case .CongiuntivoTrapassato:
                    CongiuntivoTrapassatoB = CongiuntivoTrapassatoB + Int(item.bonneReponse)
                    CongiuntivoTrapassatoM = CongiuntivoTrapassatoM + Int(item.mauvaiseReponse)
                case .CongiuntivoPresente:
                    CongiuntivoPresenteB = CongiuntivoPresenteB + Int(item.bonneReponse)
                    CongiuntivoPresenteM = CongiuntivoPresenteM + Int(item.mauvaiseReponse)
                }
            }
            
        }
        IndicativoPresenteP = "Presente: " + pourcentage(bonne: IndicativoPresenteB, mauvaise: IndicativoPresenteM)
        IndicativoImperfettoP = "Imperfetto: " + pourcentage(bonne: IndicativoImperfettoB, mauvaise: IndicativoImperfettoM)
        IndicativoPassatoprossimoP = "Passato prossimo: " + pourcentage(bonne: IndicativoPassatoprossimoB, mauvaise: IndicativoPassatoprossimoM)
        IndicativoPassatoremotoP = "Passato remoto: " + pourcentage(bonne: IndicativoPassatoremotoB, mauvaise: IndicativoPassatoremotoM)
        IndicativoTrapassatoprossimoP = "Trapassato prossimo: " + pourcentage(bonne: IndicativoTrapassatoprossimoB, mauvaise: IndicativoTrapassatoprossimoM)
        IndicativoFuturosempliceP = "Futuro semplice: " + pourcentage(bonne: IndicativoFuturosempliceB, mauvaise: IndicativoFuturosempliceM)
        IndicativoTrapassatoremotoP = "Trapassato remoto: " + pourcentage(bonne: IndicativoTrapassatoremotoB, mauvaise: IndicativoTrapassatoremotoM)
        IndicativoFuturoanterioreP = "Futuro anteriore " + pourcentage(bonne: IndicativoFuturoanterioreB, mauvaise: IndicativoFuturoanterioreM)
        CongiuntivoPresenteP = "Presente: " + pourcentage(bonne: CongiuntivoPresenteB, mauvaise: CongiuntivoPresenteM)
        CongiuntivoPassatoP = "Passato: " + pourcentage(bonne: CongiuntivoPassatoB, mauvaise: CongiuntivoPassatoM)
        CongiuntivoImperfettoP = "Imperfetto: " + pourcentage(bonne: CongiuntivoImperfettoB, mauvaise: CongiuntivoImperfettoM)
        CongiuntivoTrapassatoP = "Trapassato: " + pourcentage(bonne: CongiuntivoTrapassatoB, mauvaise: CongiuntivoTrapassatoM)
        CondizionalePresenteP = "Presente: " + pourcentage(bonne: CondizionalePresenteB, mauvaise: CondizionalePresenteM)
        CondizionalePassatoP = "Passato: " + pourcentage(bonne: CondizionalePassatoB, mauvaise: CondizionalePassatoM)
        ImperativoPresenteP = "Presente: " + pourcentage(bonne: ImperativoPresenteB, mauvaise: ImperativoPresenteM)
        
        
        itemFinal = [[IndicativoPresenteP, IndicativoImperfettoP, IndicativoPassatoprossimoP, IndicativoFuturosempliceP, IndicativoPassatoremotoP, IndicativoTrapassatoprossimoP, IndicativoFuturoanterioreP, IndicativoTrapassatoremotoP], [CongiuntivoPresenteP, CongiuntivoPassatoP, CongiuntivoImperfettoP, CongiuntivoTrapassatoP], [CondizionalePresenteP, CondizionalePassatoP], [ImperativoPresenteP]]

    }
    
    func pourcentage (bonne: Int, mauvaise: Int) -> String{
        var result = ""
        if (bonne + mauvaise) != 0 {
            result = String(round (Double(bonne) / Double(bonne + mauvaise) * 100)) + "%"
        }else{
            result = "_"
        }
        return result
    }
}
