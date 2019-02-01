//
//  ContextuelQuizViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-11-16.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreData

class ContextuelQuizViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var tempsLabel: UILabel!
    @IBOutlet weak var tempsEtverbesChoisiButton: UIButton!
    @IBOutlet weak var suggestionButton: UIButton!
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var verbTextField: UITextField!
    @IBOutlet weak var uneAutreQuestionButton: UIButton!
    @IBOutlet weak var barreProgression: UIProgressView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var verbResponseButton: UIButton!
    @IBOutlet var verbHintButton: [UIButton]!
    let fontAndConstraints = FontsAndConstraintsOptions()
    var totalProgress: Double = 0
    var textFieldIsActivated = false
    lazy var screenDeviceDimension = fontAndConstraints.screenDeviceDimension
    var rightHintWasSelected = false
    var modeEtTemps = [[String]]()
    var sentenceArray = [[String]]()
    var selectedSentences = [[String]]()
    var indexSentence = Int()
    var arrayVerbe: [[String]] = []
    var didSave: Bool = false
    var goodResponse: Double = 0
    var aideCount = Double()
    var badRep = Double()
    var reponseBonne: String = ""
    var soundURL: NSURL?
    var soundID:SystemSoundID = 0
    var difficulté = DifficultyLevel.FACILE
    let dataController = DataController.sharedInstance
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    lazy var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: ItemVerbe.identifier)
        let sortDescriptor = NSSortDescriptor(key: "verbeInfinitif", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }()
    var items: [ItemVerbe] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        barreProgression.progress = 0.0
        if let plistPath = Bundle.main.path(forResource: "ContextuelItalien", ofType: "plist"),
            let arrayNS = NSArray(contentsOfFile: plistPath){
            sentenceArray = arrayNS as! [[String]]
        }
        for sentences in sentenceArray {
            for selection in modeEtTemps {
                if selection[0].caseInsensitiveCompare(sentences[1]) == .orderedSame && selection[1].caseInsensitiveCompare(sentences[0]) == .orderedSame{
                    selectedSentences.append(sentences)
                }
            }
        }
        selectedSentences.shuffle()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        let fonts = FontsAndConstraintsOptions()
        self.title = "Coniuga il verbo"
        modeLabel.font = fonts.largeBoldFont
        tempsLabel.font = fonts.largeBoldFont
        suggestionButton.titleLabel?.font = fonts.smallItaliqueBoldFont
        tempsEtverbesChoisiButton.titleLabel?.font = fonts.smallFont
        sentenceLabel.font = fonts.normalItaliqueBoldFont
        verbTextField.font = fonts.normalFont
        uneAutreQuestionButton.titleLabel!.font = fonts.normalFont
        checkButton.titleLabel!.font = fonts.largeBoldFont
        verbResponseButton.titleLabel!.font = fonts.normalItaliqueBoldFont
        for eachButton in verbHintButton {
            eachButton.titleLabel!.font = fonts.normalFont
        }
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: verbTextField, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondAppear)
        choiceOfSentence()
        verbResponseButton.isEnabled = false
    }
    @objc func keyBoardWillChange(notification: Notification) {
        let distanceFromTextField = view.frame.size.height - (verbTextField.frame.size.height + verbTextField.frame.origin.y)
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
    override func viewDidAppear(_ animated: Bool) {
        tempsEtverbesChoisiButton.layer.cornerRadius = tempsEtverbesChoisiButton.frame.height/2
        verbResponseButton.layer.cornerRadius = verbResponseButton.frame.height / 2.0
        uneAutreQuestionButton.layer.cornerRadius = uneAutreQuestionButton.frame.height / 2.0
        suggestionButton.layer.cornerRadius = suggestionButton.frame.height / 2.0
        verbHintButton.forEach {(eachButton) in
            eachButton.layer.cornerRadius = eachButton.frame.height / 2.0
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tempsEtverbesChoisiButton.layer.cornerRadius = tempsEtverbesChoisiButton.frame.height/2
        uneAutreQuestionButton.layer.cornerRadius = uneAutreQuestionButton.frame.height / 2.0
        suggestionButton.layer.cornerRadius = suggestionButton.frame.height / 2.0
        uneAutreQuestionButton.setNeedsLayout()
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
        verbTextField.resignFirstResponder()
        evaluationReponse()
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        suggestionButton.isEnabled = false
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        verbTextField.isHidden = true
        suggestionButton.isEnabled = false
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        verbResponseButton.isHidden = true
        checkButton.isHidden = true
        return true
    }
    func hintMenuActiondissapear() {
        verbHintButton.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = true
                self.view.layoutIfNeeded()
            })
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
    func choiceOfSentence () {
        indexSentence = indexSentence + 1
        if indexSentence >= selectedSentences.count {indexSentence = 0}
        questionInitialisation()
        
    }
    func evaluationReponse(){
        let sentences = Sentences(selectedSentences: selectedSentences, indexSentence: indexSentence)
        sentenceLabel.textColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        if verbTextField.text == reponseBonne || rightHintWasSelected{
            if rightHintWasSelected {
                aideCount = aideCount + 1
            }else{
                goodResponse = goodResponse + 1
            }
            sentenceLabel.attributedText = sentences.attributeBonneReponse
            verbResponseButton.setTitle("Bravo!", for: .disabled)
            let filePath = Bundle.main.path(forResource: "Incoming Text 01", ofType: "wav")
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
            didSave = false
            for item in items {
                if item.tempsVerbe == selectedSentences[indexSentence][0] && item.modeVerbe == selectedSentences[indexSentence][1] && item.verbeInfinitif == selectedSentences[indexSentence][4]{
                   
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
                itemVerbe.verbeInfinitif = selectedSentences[indexSentence][4]
                itemVerbe.tempsVerbe = selectedSentences[indexSentence][1]
                itemVerbe.modeVerbe = selectedSentences[indexSentence][0]
                if rightHintWasSelected {
                    itemVerbe.bonneReponseTemps = itemVerbe.bonneReponseTemps + 1
                }else{
                    itemVerbe.bonneReponse = itemVerbe.bonneReponse + 1
                }
            }
            dataController.saveContext()
        }else{
            didSave = false
            badRep = badRep + 1
            sentenceLabel.attributedText = sentences.attributeMauvaiseReponse
            for item in items {
                if item.tempsVerbe == selectedSentences[indexSentence][0] && item.modeVerbe == selectedSentences[indexSentence][1] && item.verbeInfinitif == selectedSentences[indexSentence][4]{
                    item.mauvaiseReponse = item.mauvaiseReponse + 1
                    didSave = true
                }
            }
            if didSave == false {
                let itemVerbe = NSEntityDescription.insertNewObject(forEntityName: "ItemVerbe", into: dataController.managedObjectContext) as! ItemVerbe
                itemVerbe.verbeInfinitif = selectedSentences[indexSentence][4]
                itemVerbe.tempsVerbe = selectedSentences[indexSentence][1]
                itemVerbe.modeVerbe = selectedSentences[indexSentence][0]
                itemVerbe.mauvaiseReponse = itemVerbe.mauvaiseReponse + 1
            }
            dataController.saveContext()
            verbResponseButton.setTitle("Sbagliato...", for: .disabled)
            let filePath = Bundle.main.path(forResource: "Error Warning", ofType: "wav")
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
// to be introduced
        progressClaculation()
        if totalProgress == Double(10) {
            let when = DispatchTime.now() + 1.0 // change 2 to desired number of seconds
            uneAutreQuestionButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.performSegue(withIdentifier: "showResult", sender: nil)
            }
        }
    }
    func progressClaculation() {
        totalProgress = totalProgress + 1
        let progress = Float(totalProgress)/10.0
        barreProgression.progress = progress
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChoixDeTemps" {
            let controller = segue.destination as! ChoixDeTempsViewController
            controller.tempsEtMode = modeEtTemps
        }
        if segue.identifier == "showResult" {
            let wichQuiz = UnwindSegueChoice.toContexteViewController
            let controller = segue.destination as! ResultViewController
            controller.goodResponse = goodResponse
            controller.badResponse = badRep
            controller.aideCount = aideCount
            controller.totalProgress = totalProgress
            controller.wichQuiz = wichQuiz
        }
    }
    @IBAction func unwindToContextuekQuiz(segue: UIStoryboardSegue) {
        totalProgress = 0.0
        goodResponse = 0
        aideCount = 0
        badRep = 0
        barreProgression.progress = 0.0
        selectionAutreQuestion()
    }
    // MARK: Buttons
    @IBAction func uneAutreQuestionButtonPushed(_ sender: UIButton) {
        selectionAutreQuestion()
    }
    @IBAction func checkButton(_ sender: UIButton) {
        evaluationReponse()
        verbTextField.resignFirstResponder()
        checkButton.isEnabled = false
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        suggestionButton.isEnabled = false
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        verbTextField.isHidden = true
        verbResponseButton.isHidden = false
        checkButton.isHidden = true
    }
    @IBAction func verbHintPressed(_ sender: UIButton) {
        if reponseBonne.lowercased() == sender.titleLabel?.text?.lowercased() {
            rightHintWasSelected = true
        }else{
            rightHintWasSelected = false
        }
        evaluationReponse()
        hintMenuActiondissapear()
    }
    @IBAction func suggestionButtonWasPressed(_ sender: UIButton) {
        difficulté = .FACILE
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: verbTextField, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondAppear)
        suggestionButton.isEnabled = false
        questionInitialisation()
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
    }
    func questionInitialisation() {
        var sentences = Sentences(selectedSentences: selectedSentences, indexSentence: indexSentence)
        verbTextField.text = ""
        sentences = Sentences(selectedSentences: selectedSentences, indexSentence: indexSentence)
        let tempsDuVerbe = sentences.tempsDuVerbe
        let modeDuverbe = sentences.modeDuverbe
        reponseBonne = sentences.reponseBonne
        let infinitif = sentences.infinitif
        modeLabel.text = modeDuverbe.capitalizingFirstLetter()
        tempsLabel.text = tempsDuVerbe.capitalizingFirstLetter()
        sentenceLabel.attributedText = sentences.attributeQuestion
        switch difficulté {
        case .FACILE:
            ChoixFacileVerbeConjugue.verbeConjugue(arrayVerbe: arrayVerbe, infinitif: infinitif, tempsDuVerbe: tempsDuVerbe, modeDuverbe: modeDuverbe, verbHintButton: verbHintButton, hintMenuAction: hintMenuActiondAppear, reponseBonne: reponseBonne )
        default:
            break
        }
        
    }
    func selectionAutreQuestion() {
        sentenceLabel.textColor = UIColor.black
        checkButton.isEnabled = true
        verbTextField.isEnabled = true
        verbTextField.textColor = UIColor.black
        verbTextField.text = ""
        verbResponseButton.setTitle("Scegli il verbo", for: .disabled)
        uneAutreQuestionButton.isEnabled = true
        difficulté = .DIFFICILE
        rightHintWasSelected = false
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: verbTextField, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondAppear)
        choiceOfSentence()
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
