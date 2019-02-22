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

class QuizController: UIViewController, NSFetchedResultsControllerDelegate{
    @IBOutlet weak var autreQuestionLabel: UIButton!
    @IBOutlet weak var verbe: UILabel!
    @IBOutlet weak var mode: UILabel!
    @IBOutlet weak var temps: UILabel!
    @IBOutlet weak var personne: UILabel!
    @IBOutlet weak var reponse: UITextField!
    @IBOutlet weak var barreProgression: UIProgressView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var traductionAnglaiseButton: UIButton!
    @IBOutlet weak var tempsChoisiButton: UIButton!
    @IBOutlet weak var suggestionButton: UIButton!
    @IBOutlet var verbHintButton: [UIButton]!
    @IBOutlet weak var uneAutreQuestionButton: UIButton!
    @IBOutlet weak var verbResponseButton: UIButton!
    @IBOutlet weak var personneResponse: UILabel!
    @IBOutlet weak var wrongAnswerCorrection: UILabel!
    var textFieldIsActivated = false
    var tempsEtMode = [[String]]()
    var listeVerbe: [String] = []
    var arrayVerbe: [[String]] = []
    var arraySelection: [String] = []
    var verbeInfinitif: [String] = []
    var allInfoList: [[String]] = []
    var indexChoisi: Int = 0
    var indexDesVerbes: [Int] = []
    var noPersonne: Int = 0
    var noItem: Int = 0
    var choixPersonne: String = ""
    var reponseBonne: String = ""
    var progress: Float = 0.0
    var progressInt: Float = 0.0
    var goodResponse = Double()
    var badRep = Double()
    var aideCount = Double()
    var totalProgress: Double = 0
    var soundURL: NSURL?
    var soundID:SystemSoundID = 0
    var didSave: Bool = false
    var verbeFinal: String = ""
    var modeFinal: String = ""
    var tempsFinal: String = ""
    var testCompltete = UserDefaults.standard.bool(forKey: "testCompltete")
    let dataController = DataController.sharedInstance
    var difficulté = DifficultyLevel.DIFFICILE
    var rightHintWasSelected = false
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: ItemVerbe.identifier)
        let sortDescriptor = NSSortDescriptor(key: "verbeInfinitif", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }()
    var items: [ItemVerbe] = []
    let screenSize: CGRect = UIScreen.main.bounds
    override func viewDidLoad() {
        super.viewDidLoad()
        personneResponse.isHidden = true
        testCompltete = false
        barreProgression.progress = 0.0
        selectionQuestion()
        do {
            items = try managedObjectContext.fetch(fetchRequest) as! [ItemVerbe]
        }catch let error as NSError {
            print("Error fetching Item objects: \(error.localizedDescription), \(error.userInfo)")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Coniuga il verbo"
        let fonts = FontsAndConstraintsOptions()
        verbe.font = fonts.largeBoldFont
        mode.font = fonts.largeFont
        temps.font = fonts.largeFont
        wrongAnswerCorrection.font = fonts.normalFont
        wrongAnswerCorrection.isHidden = true
        suggestionButton.titleLabel?.font = fonts.smallItaliqueBoldFont
        tempsChoisiButton.titleLabel?.font = fonts.smallFont
        traductionAnglaiseButton.titleLabel?.font = fonts.smallFont
        
        reponse.font = fonts.normalFont
        personne.font = fonts.smallBoldFont
        personneResponse.font = fonts.smallBoldFont
        uneAutreQuestionButton.titleLabel!.font = fonts.normalFont
        checkButton.titleLabel!.font = fonts.largeBoldFont
        verbResponseButton.titleLabel!.font = fonts.normalItaliqueBoldFont
        for eachButton in verbHintButton {
            eachButton.titleLabel!.font = fonts.normalFont
        }
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: reponse, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondAppear)
        verbResponseButton.isEnabled = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tempsChoisiButton.layer.cornerRadius = tempsChoisiButton.frame.height/2
        verbResponseButton.layer.cornerRadius = verbResponseButton.frame.height / 2.0
        uneAutreQuestionButton.layer.cornerRadius = uneAutreQuestionButton.frame.height / 2.0
        suggestionButton.layer.cornerRadius = suggestionButton.frame.height / 2.0
        traductionAnglaiseButton.layer.cornerRadius = traductionAnglaiseButton.frame.height / 2.0
        verbHintButton.forEach {(eachButton) in
            eachButton.layer.cornerRadius = eachButton.frame.height / 2.0
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tempsChoisiButton.layer.cornerRadius = tempsChoisiButton.frame.height/2
        verbResponseButton.layer.cornerRadius = verbResponseButton.frame.height / 2.0
        uneAutreQuestionButton.layer.cornerRadius = uneAutreQuestionButton.frame.height / 2.0
        suggestionButton.layer.cornerRadius = suggestionButton.frame.height / 2.0
        traductionAnglaiseButton.layer.cornerRadius = traductionAnglaiseButton.frame.height / 2.0
        verbHintButton.forEach {(eachButton) in
            eachButton.layer.cornerRadius = eachButton.frame.height / 2.0
        }
    }
    @objc func keyBoardWillChange(notification: Notification) {
        let distanceFromTextField = view.frame.size.height - (reponse.frame.size.height + reponse.frame.origin.y)
        guard let keyBoardRec = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow && !textFieldIsActivated{
            textFieldIsActivated = true
            animateViewMoving(true, moveValue: keyBoardRec.height - distanceFromTextField + 5)
        }else if notification.name == Notification.Name.UIKeyboardWillHide{
            textFieldIsActivated = false
            animateViewMoving(true, moveValue: distanceFromTextField - keyBoardRec.height - 5)
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
    @objc func textFieldShouldReturn(_ reponse: UITextField) -> Bool {
        evaluationReponse()
        personneResponse.isHidden = true
        personne.isHidden = true
        specificQuiz()
        reponse.resignFirstResponder()
        checkButton.isEnabled = false
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        suggestionButton.isEnabled = false
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        reponse.isHidden = true
        verbResponseButton.isHidden = false
        checkButton.isHidden = true
        return true
    }
    @IBAction func suggestionButtonWasPressed(_ sender: UIButton) {
        difficulté = .FACILE
        personne.isHidden = true
        personneResponse.isHidden = false
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: reponse, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondAppear)
        suggestionButton.isEnabled = false
        questionInitialisation()
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
    }
    @IBAction func checkButton(_ sender: UIButton) {
        evaluationReponse()
        personneResponse.isHidden = true
        personne.isHidden = true
        specificQuiz()
        reponse.resignFirstResponder()
        checkButton.isEnabled = false
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        suggestionButton.isEnabled = false
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        reponse.isHidden = true
        verbResponseButton.isHidden = false
        checkButton.isHidden = true
    }
    @IBAction func verbHintPressed(_ sender: UIButton) {
        
        personne.isHidden = true
        personneResponse.isHidden = true
        if reponseBonne.lowercased() == sender.titleLabel?.text?.lowercased() {
            rightHintWasSelected = true
        }else{
            rightHintWasSelected = false
        }
        evaluationReponse()
        specificQuiz()
        hintMenuActiondissapear()
    }
    @IBAction func uneAutreQuestionButtonPushed(_ sender: UIButton) {
        personne.isHidden = false
        wrongAnswerCorrection.isHidden = true
        personneResponse.isHidden = true
        checkButton.isEnabled = true
        reponse.isEnabled = true
        reponse.textColor = UIColor.black
        reponse.text = ""
        verbResponseButton.setTitle("Scegli il verbo", for: .disabled)
        selectionQuestion()
        difficulté = .DIFFICILE
        rightHintWasSelected = false
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: reponse, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondAppear)
    }

    
// MARK: NAVIGATION
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showResult" {
        let wichQuiz = UnwindSegueChoice.toQuizViewController
        let controller = segue.destination as! ResultViewController
        controller.goodResponse = goodResponse
        controller.badResponse = badRep
        controller.aideCount = aideCount
        controller.totalProgress = totalProgress
        controller.wichQuiz = wichQuiz
        }
    if segue.identifier == "showTempsVerbesChoisis" {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        let controller = segue.destination as! TempsVerbesChoisisViewController
        controller.tempsEtMode = tempsEtMode
        controller.verbeInfinitif = verbeInfinitif
        controller.listeVerbe = listeVerbe
        }
    }

 //////////////////////////////////////
// MARK: ALL BUTTON AND ACTIONS
//////////////////////////////////////
    @IBAction func unwindToLast(segue: UIStoryboardSegue) {
        autreQuestionLabel.isEnabled = true
        progressInt = 0.0
        progress = 0.0
        goodResponse = 0
        aideCount = 0
        badRep = 0
        barreProgression.progress = 0.0
        reponse.text = ""
        indexChoisi = 0
        difficulté = .DIFFICILE
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: reponse, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondissapear)
        personneResponse.isHidden = true
        personne.isHidden = false
        selectionQuestion()
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
            let question = Question()
            let questionFinale = question.finaleSpecifique(noPersonne: noPersonne, personneVerbe: personneVerbe)
            choixPersonne = questionFinale[0]
            personne.text = questionFinale[1]
            personneResponse.text = questionFinale[1]
            totalProgress = Double(allInfoList.count)
        }else{
            let selection = Selection()
            totalProgress = 10
            let choixTempsEtMode = selection.questionAleatoire(arraySelection: arraySelection, arrayVerbe: arrayVerbe)
            let leChoixTempsEtMode = choixTempsEtMode.0
            tempsEtMode = choixTempsEtMode.1
            verbeFinal = (leChoixTempsEtMode[0] as? String)!
            modeFinal = (leChoixTempsEtMode[1] as? String)!.lowercased()
            tempsFinal = (leChoixTempsEtMode[2] as? String)!
            choixPersonne = leChoixTempsEtMode[3] as! String
            personne.text = leChoixTempsEtMode[4] as? String
            personneResponse.text = leChoixTempsEtMode[4] as? String
            reponseBonne = leChoixTempsEtMode[5] as! String
        }
        
        let helper = Helper()
        verbe.text = helper.capitalize(word: verbeFinal)
        mode.text = helper.capitalize(word: modeFinal)
        temps.text = helper.capitalize(word: tempsFinal)
    }
    func evaluationReponse(){
        if reponse.text == reponseBonne || rightHintWasSelected{
            if rightHintWasSelected {
                aideCount = aideCount + 1
            }else{
                goodResponse = goodResponse + 1
            }
            let filePath = Bundle.main.path(forResource: "Incoming Text 01", ofType: "wav")
            verbResponseButton.setTitle("Bravo!", for: .disabled)
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
            var good = String()
            if let personne = personne.text {
                good = "\(personne) \(reponseBonne)"
            }
            wrongAnswerCorrection.isHidden = false
            wrongAnswerCorrection.textColor = UIColor.black
            wrongAnswerCorrection.text = good
            didSave = false
            for item in items {
                if item.tempsVerbe == temps.text && item.modeVerbe == mode.text && item.verbeInfinitif == verbe.text{
                    if rightHintWasSelected {
                        item.bonneReponseTemps = item.bonneReponseTemps + 1

                        
                    }else{
                        item.bonneReponse = item.bonneReponse + 1
                    }
                    didSave = true
                }
            }
            if didSave == false {
                let itemVerbe = NSEntityDescription.insertNewObject(forEntityName: "ItemVerbe", into: dataController.managedObjectContext) as! ItemVerbe
                itemVerbe.verbeInfinitif = verbeFinal
                itemVerbe.tempsVerbe = tempsFinal
                itemVerbe.modeVerbe = modeFinal
                if rightHintWasSelected {
                    itemVerbe.bonneReponseTemps = itemVerbe.bonneReponseTemps + 1
                }else{
                    itemVerbe.bonneReponse = itemVerbe.bonneReponse + 1
                }
            }
            dataController.saveContext()
        }else{
            badRep = badRep + 1
            didSave = false
            for item in items {
                if item.tempsVerbe == temps.text && item.modeVerbe == mode.text && item.verbeInfinitif == verbe.text{
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
            var badResponse = String()
            if let personne = personne.text {
                badResponse = "\(personne) \(reponseBonne)"
            }
            verbResponseButton.setTitle("Sbagliato...", for: .disabled)
            wrongAnswerCorrection.isHidden = false
            wrongAnswerCorrection.textColor = UIColor.red
            wrongAnswerCorrection.text = badResponse
            let filePath = Bundle.main.path(forResource: "Error Warning", ofType: "wav")
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
        progressClaculation()
        if progressInt == Float(totalProgress) {
            let when = DispatchTime.now() + 1.0 // change 2 to desired number of seconds
            autreQuestionLabel.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.performSegue(withIdentifier: "showResult", sender: nil)
            }
        }
    }
    func hintMenuActiondAppear() {
        verbHintButton.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
    func hintMenuActiondissapear() {
        verbHintButton.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
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
            englishVerbe = "La traduzione non è disponibile"
        }
        let alertController = UIAlertController(title: "\(verbeFinal):  \(englishVerbe)", message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = temps.frame
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func questionInitialisation() {
        switch difficulté {
        case .FACILE:
            ChoixFacileVerbeConjugue.verbeConjugue(arrayVerbe: arrayVerbe, infinitif: verbeFinal, tempsDuVerbe: tempsFinal, modeDuverbe: modeFinal, verbHintButton: verbHintButton, hintMenuAction: hintMenuActiondAppear, reponseBonne: reponseBonne )
        default:
            break
        }
        
    }
    
    @IBAction func traductionButtonPushed(_ sender: UIButton) {
        showAlert()
    }

    
}
