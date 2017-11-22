//
//  QuizController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-04.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreData
import GoogleMobileAds

class QuizController: UIViewController, NSFetchedResultsControllerDelegate,  GADBannerViewDelegate  {
    var showWindow = false
    var tempsEtMode = [[String]]()
    var verbeInfinitif: [String] = []
    var indexChoisi: Int = 0
    var testComplete: Bool = false
    var arrayVerbe: [[String]] = []
    var arraySelection: [String] = []
    var allInfoList: [[String]] = []
    var infinitifVerb: Int = 0
    var listeVerbe: [String] = []
    var verbeChoisi: String = ""
    var tempsChoisi: String = ""
    var modeChoisi: String = ""
    var indexDesVerbes: [Int] = []
    var noPersonne: Int = 0
    var noItem: Int = 0
    var choixPersonne: String = ""
    var reponseBonne: String = ""
    var progress: Float = 0.0
    var progressInt: Float = 0.0
    var goodResponse: Int = 0
    var totalProgress: Int = 0
    var soundURL: NSURL?
    var soundID:SystemSoundID = 0
    var didSave: Bool = false
    var verbeFinal: String = ""
    var modeFinal: String = ""
    var tempsFinal: String = ""
    var fenetre = UserDefaults.standard.bool(forKey: "fenetre")
    var testCompltete = UserDefaults.standard.bool(forKey: "testCompltete")
    let dataController = DataController.sharedInstance
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: ItemVerbe.identifier)
        let sortDescriptor = NSSortDescriptor(key: "verbeInfinitif", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }()
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-1437510869244180/3360498117"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
    var items: [ItemVerbe] = []
    
    @IBOutlet weak var autreQuestionLabel: UIBarButtonItem!
    @IBOutlet weak var verbe: UILabel!
    @IBOutlet weak var mode: UILabel!
    @IBOutlet weak var temps: UILabel!
    @IBOutlet weak var personne: UILabel!
    @IBOutlet weak var bonneReponse: UILabel!
    @IBOutlet weak var reponse: UITextField!
    @IBOutlet weak var barreProgression: UIProgressView!
    @IBOutlet weak var checkButton: UIButton!
    
    let screenSize: CGRect = UIScreen.main.bounds
    @IBOutlet weak var masterConstraint: NSLayoutConstraint!
    @IBOutlet weak var tempsConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        adBannerView.load(GADRequest())
        navigationItem.titleView = adBannerView
        masterConstraint.constant = 0.10 * screenSize.height
        tempsConstraint.constant = 0.10 * screenSize.height
        testCompltete = false
        self.title = "Rispondere"
        barreProgression.progress = 0.0
        selectionQuestion()
        do {
            items = try managedObjectContext.fetch(fetchRequest) as! [ItemVerbe]
        }catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if showWindow {
            showAlert4()
        }
        showWindow = false
    }
    // the 3 next function moves the KeyBoards when keyboard appears or hides
 
        @objc func textFieldDidBeginEditing(_ textField: UITextField) {
            if UIDevice.current.userInterfaceIdiom == .pad && (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight){
            animateViewMoving(true, moveValue: 50)
            }
        }
        @objc func textFieldDidEndEditing(_ textField: UITextField) {
            if UIDevice.current.userInterfaceIdiom == .pad && (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight){
            animateViewMoving(false, moveValue: 50)
            }
        }
        func animateViewMoving (_ up:Bool, moveValue :CGFloat){
            let movementDuration:TimeInterval = 0.3
            let movement:CGFloat = ( up ? -moveValue : moveValue)
            UIView.beginAnimations( "animateView", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration )
            self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
            UIView.commitAnimations()
        }

    
// MARK: NAVIGATION
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showResult" {
        let controller = segue.destination as! ResultViewController
        controller.goodResponse = goodResponse
        controller.totalProgress = totalProgress
        }
    if segue.identifier == "showTempsVerbesChoisis" {
        let controller = segue.destination as! TempsVerbesChoisisViewController
        controller.tempsEtMode = tempsEtMode
        controller.verbeInfinitif = verbeInfinitif
        controller.listeVerbe = listeVerbe
        }
    }


    
    
 //////////////////////////////////////
// MARK: ALL BUTTON AND ACTIONS
//////////////////////////////////////
    
    
    @IBAction func check(_ sender: Any) {
        evaluationReponse()
        specificQuiz()
        reponse.resignFirstResponder()
        checkButton.isEnabled = false
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        reponse.isEnabled = false
    }
    @IBAction func autreQuestion(_ sender: Any) {
        selectionQuestion()
        bonneReponse.text = ""
        reponse.text = ""
        checkButton.isEnabled = true
        reponse.isEnabled = true
    }
    
    
    @IBAction func unwindToLast(segue: UIStoryboardSegue) {
        autreQuestionLabel.isEnabled = true
        progressInt = 0.0
        progress = 0.0
        goodResponse = 0
        barreProgression.progress = 0.0
        bonneReponse.text = ""
        reponse.text = ""
        indexChoisi = 0
        checkButton.isEnabled = true
        reponse.isEnabled = true
        selectionQuestion()
        if fenetre == false {
            showWindow = true
        }
    }
    @IBAction func exemple(_ sender: Any) {
        showAlert()
    }
    
    

    
/////////////////////////////////////
// MARK: ALL FUNCTIONS
/////////////////////////////////////
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    func selectionQuestion(){
        if verbeInfinitif != ["Tous les verbes"] {
            if allInfoList.count == 0{
                let selection = Selection()
                let choixTempsEtMode = selection.questionSpecifique(arraySelection: arraySelection, arrayVerbe: arrayVerbe, verbeInfinitif: verbeInfinitif)
                allInfoList = choixTempsEtMode.0
                
                indexDesVerbes = choixTempsEtMode.1
                tempsEtMode = choixTempsEtMode.2
            }
            let verbeTrie = VerbeTrie(allInfoList: allInfoList, n: indexDesVerbes[indexChoisi])
            let personneVerbe = PersonneTrie(verbeTrie: verbeTrie)
            verbeFinal = verbeTrie.verbe
            modeFinal = verbeTrie.mode
            tempsFinal = verbeTrie.temps
            noPersonne = Int(verbeTrie.personne)!
            reponseBonne = verbeTrie.verbeConjugue
            bonneReponse.text = ""
            let question = Question()
            let questionFinale = question.finaleSpecifique(noPersonne: noPersonne, personneVerbe: personneVerbe)
            choixPersonne = questionFinale[0]
            personne.text = questionFinale[1]
            totalProgress = allInfoList.count
            
        }else{
            let selection = Selection()
            totalProgress = 10
            let choixTempsEtMode = selection.questionAleatoire(arraySelection: arraySelection, arrayVerbe: arrayVerbe)
            let leChoixTempsEtMode = choixTempsEtMode.0
            tempsEtMode = choixTempsEtMode.1
            verbeFinal = (leChoixTempsEtMode[0] as? String)!
            modeFinal = (leChoixTempsEtMode[1] as? String)!
            tempsFinal = (leChoixTempsEtMode[2] as? String)!
            bonneReponse.text = ""
            choixPersonne = leChoixTempsEtMode[3] as! String
            personne.text = leChoixTempsEtMode[4] as? String
            reponseBonne = leChoixTempsEtMode[5] as! String
        }
        let helper = Helper()
        verbe.text = helper.capitalize(word: verbeFinal)
        mode.text = helper.capitalize(word: modeFinal)
        temps.text = helper.capitalize(word: tempsFinal)
    }

    func evaluationReponse(){
        if reponse.text == reponseBonne{
            goodResponse = goodResponse + 1
            bonneReponse.text = "Buonissimo!"
            let filePath = Bundle.main.path(forResource: "Incoming Text 01", ofType: "wav")
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
            bonneReponse.textColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)
            didSave = false
            for item in items {
                if item.tempsVerbe == temps.text && item.modeVerbe == mode.text && item.verbeInfinitif == verbe.text?.lowercased(){
                    item.bonneReponse = item.bonneReponse + 1
                    didSave = true
                }
            }

            if didSave == false {
                let itemVerbe = NSEntityDescription.insertNewObject(forEntityName: "ItemVerbe", into: dataController.managedObjectContext) as! ItemVerbe
                itemVerbe.verbeInfinitif = verbeFinal
                itemVerbe.tempsVerbe = tempsFinal
                itemVerbe.modeVerbe = modeFinal
                itemVerbe.bonneReponse = itemVerbe.bonneReponse + 1
            }
            dataController.saveContext()
            
        }else{
            didSave = false
            for item in items {
                if item.tempsVerbe == temps.text && item.modeVerbe == mode.text && item.verbeInfinitif == verbe.text?.lowercased(){
                    item.mauvaiseReponse = item.mauvaiseReponse + 1
                    didSave = true
                }
                
                
            }
            if didSave == false {
                let itemVerbe = NSEntityDescription.insertNewObject(forEntityName: "ItemVerbe", into: dataController.managedObjectContext) as! ItemVerbe
                itemVerbe.verbeInfinitif = verbeFinal
                itemVerbe.tempsVerbe = tempsFinal
                itemVerbe.modeVerbe = modeFinal
                itemVerbe.mauvaiseReponse = itemVerbe.mauvaiseReponse + 1
                
            }
            
            dataController.saveContext()
            bonneReponse.text = reponseBonne
            bonneReponse.textColor = UIColor(red: 255/255, green: 17/255, blue: 93/255, alpha: 1.0)
            let filePath = Bundle.main.path(forResource: "Error Warning", ofType: "wav")
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
            
        }
        
        progressClaculation()
        if progressInt == Float(totalProgress) {
            let when = DispatchTime.now() + 1.5 // change 2 to desired number of seconds
            autreQuestionLabel.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.performSegue(withIdentifier: "showResult", sender: nil)
            }
            
        }
    }
    @objc func textFieldShouldReturn(_ reponse: UITextField) -> Bool {
        reponse.resignFirstResponder()
        specificQuiz()
        evaluationReponse()
        checkButton.isEnabled = false
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        reponse.isEnabled = false
        return true
    }
    func progressClaculation() {
        progressInt = progressInt + 1
        progress = Float(progressInt)/Float(totalProgress)
        barreProgression.progress = progress
    }
    func specificQuiz() {
        indexChoisi = indexChoisi + 1
    }
    func showAlert () {
        var englishVerbe = String()
        var verbeFinal = String()
        let frenchToEnglish = FrenchToEnglish()
        let verbeLowerCase = verbe.text?.lowercased()
        let dictFrenchEnglish = frenchToEnglish.getDict()
        if let verbeTexte = verbeLowerCase , let english = dictFrenchEnglish[verbeTexte]{
            englishVerbe = english
            verbeFinal = verbeTexte
        }else{
            englishVerbe = "la traduzione non è disponibile"
        }
        let alertController = UIAlertController(title: "\(verbeFinal):  \(englishVerbe)", message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = temps.frame
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: dismissAlert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func dismissAlert(_ sender: UIAlertAction) {
        
    }
    
    func showAlert4 () {
        
        let alert = UIAlertController(title: "Verbi Italiani Quiz", message: "La sua opinione è importante per migliorare l'applicazione. Per favore dia i suoi commenti", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Va bene", style: UIAlertActionStyle.default, handler:{(alert: UIAlertAction!) in self.rateApp(appId: "id1087151566") { success in
            print("RateApp \(success)")
            }}))
        alert.addAction(UIAlertAction(title: "Più tardi", style: UIAlertActionStyle.default, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Non mostrare mai questo", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.fenetre = true; UserDefaults.standard.set(self.fenetre, forKey: "fenetre") }))
        self.present(alert, animated: true, completion: nil)
    }
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }


    
}
