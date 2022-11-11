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
    let notificationCenter = NotificationCenter.default
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
    @IBOutlet weak var verbeVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var tempChoisiConstraint: NSLayoutConstraint!
    @IBOutlet weak var tempConstraint: NSLayoutConstraint!
    @IBOutlet weak var modeConstraint: NSLayoutConstraint!
    @IBOutlet weak var traductionButtonConstraint: NSLayoutConstraint!
    lazy var quizQuestion = QuizQuestion(verbSelectionRandom: verbSelectionRandom, index: index)
    var difficulté = DifficultyLevel.DIFFICILE
    var textFieldIsActivated = false
    var arrayVerb = [[String]]()
    var verbInfinitif = [String]()
    var arraySelectionTempsEtMode = [[String]]()
    var index = Int()
    var verbSelectionRandom = [[String]]()
    var conjugatedVerb = String()
    var rightHintWasSelected = false
    var verbCountInQuiz  = Int()
    var progressInt = Int()
    var listeVerbe = [String]()
    var userRespone = String()
    var correctionResponse = String()
    var soundPlayer: SoundPlayer?
    var reponseEvaluation = QuizResult.bad
    override func viewDidLoad() {
        super.viewDidLoad()
        let selectVerbArray = SelectVerb(arrayVerb: arrayVerb, tempsEtMode: arraySelectionTempsEtMode, verbInfinitif: verbInfinitif)
        verbSelectionRandom = selectVerbArray.verbSelectionRandom
        for array in arrayVerb{
            if !listeVerbe.contains(array[2]){
                listeVerbe.append(array[2])
            }
        }
        barreProgression.progress = 0.0
        if selectVerbArray.verbInfinitif == ["Tous les verbes"]{
            verbCountInQuiz = 10
        }else{
            verbCountInQuiz = verbSelectionRandom.count
        }
        setQuestion()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        let voiceStopped = Notification.Name("voiceStopped")
        notificationCenter.addObserver(self,selector: #selector(voiceDidTerminate),name: voiceStopped,object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Coniuga il verbo".localized
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
        UserDefaults.standard.set(0, forKey: "thisQuizHintAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizGoodAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizBadAnswer")
    }
    override func viewDidAppear(_ animated: Bool) {
        traductionAnglaiseButton.layer.cornerRadius = traductionAnglaiseButton.frame.height/2
        tempsChoisiButton.layer.cornerRadius = tempsChoisiButton.frame.height/2
        verbResponseButton.layer.cornerRadius = verbResponseButton.frame.height / 2.0
        uneAutreQuestionButton.layer.cornerRadius = uneAutreQuestionButton.frame.height / 2.0
        suggestionButton.layer.cornerRadius = suggestionButton.frame.height / 2.0
        verbHintButton.forEach {(eachButton) in
            eachButton.layer.cornerRadius = eachButton.frame.height / 2.0
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(0, forKey: "thisQuizHintAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizGoodAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizBadAnswer")
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        traductionAnglaiseButton.layer.cornerRadius = traductionAnglaiseButton.frame.height/2
        tempsChoisiButton.layer.cornerRadius = tempsChoisiButton.frame.height/2
        uneAutreQuestionButton.layer.cornerRadius = uneAutreQuestionButton.frame.height / 2.0
        suggestionButton.layer.cornerRadius = suggestionButton.frame.height / 2.0
        uneAutreQuestionButton.setNeedsLayout()
    }
    @objc func keyBoardWillChange(notification: Notification) {
        let distanceFromTextField = view.frame.size.height - (reponse.frame.size.height + reponse.frame.origin.y)
        guard let keyBoardRec = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification && !textFieldIsActivated{
            let moveValue = keyBoardRec.height - distanceFromTextField + 5
            //textFieldIsActivated = true
            animateViewMoving(true, moveValue: moveValue)
            if moveValue > 100 {tempsChoisiButton.isHidden = true}
        }else if notification.name == UIResponder.keyboardWillHideNotification{
            textFieldIsActivated = false
            animateViewMoving(false, moveValue: distanceFromTextField - keyBoardRec.height - 5)
            tempsChoisiButton.isHidden = false
        }
    }
    func setQuestion() {
        quizQuestion = QuizQuestion(verbSelectionRandom: verbSelectionRandom, index: index)
        let choixDuPronom = ChoixDuPronom(mode: quizQuestion.mode, temps: quizQuestion.temp, infinitif: quizQuestion.infinitif, personne: quizQuestion.person, conjugatedVerb: quizQuestion.conjugatedVerb)
        personneResponse.isHidden = true
        index = quizQuestion.indexIncrement
        verbe.text = quizQuestion.infinitif.capitalizingFirstLetter()
        mode.text = quizQuestion.mode.capitalizingFirstLetter()
        temps.text = quizQuestion.temp.capitalizingFirstLetter()
        personne.text = choixDuPronom.pronom
        personneResponse.text = choixDuPronom.pronom
        conjugatedVerb = quizQuestion.conjugatedVerb
    }
    @objc func textFieldShouldReturn(_ reponse: UITextField) -> Bool {
        userRespone = reponse.text!
        afterUserResponse()
        return true
    }
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        if !textFieldIsActivated {
            let newRatio = movement/view.frame.height
            if up{
                self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
                print(-newRatio)
                print(view.frame.height)
                verbeVerticalConstraint.constant = -newRatio * view.frame.height
                traductionButtonConstraint.constant = -newRatio * view.frame.height
                modeConstraint.constant = -newRatio * view.frame.height
                tempConstraint.constant = -newRatio * view.frame.height
                tempChoisiConstraint.constant = -newRatio * view.frame.height
                textFieldIsActivated = true
            }else{
                self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: -movement)
                verbeVerticalConstraint.constant = 0.27
                traductionButtonConstraint.constant = 0.44
                modeConstraint.constant = 0.65
                tempConstraint.constant = 0.74
                tempChoisiConstraint.constant = 0.92
                textFieldIsActivated = false
            }
        }
    }
    func questionInitialisation() {
        switch difficulté {
        case .FACILE:
            ChoixFacileVerbeConjugue.verbeConjugue(arrayVerbe: arrayVerb, infinitif:  quizQuestion.infinitif, tempsDuVerbe: quizQuestion.temp, modeDuverbe:quizQuestion.mode, verbHintButton: verbHintButton, hintMenuAction: hintMenuActiondAppear, reponseBonne: conjugatedVerb)
        default:
            break
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
    func hintMenuActiondAppear() {
        verbHintButton.forEach { (eachButton) in
            UIView.animate(withDuration: 0.4, animations: {
                eachButton.isHidden = false
                self.view.layoutIfNeeded()
            })
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            let wichQuiz = UnwindSegueChoice.toQuizViewController
            let controller = segue.destination as! ResultViewController
            controller.totalProgress = Double(verbCountInQuiz)
            controller.wichQuiz = wichQuiz
        }
        if segue.identifier == "showTempsVerbesChoisis" {
            let controller = segue.destination as! TempsVerbesChoisisViewController
            controller.tempsEtMode = arraySelectionTempsEtMode
            controller.verbeInfinitif = verbInfinitif
            controller.listeVerbe = listeVerbe
        }
    }
    @IBAction func unwindToQuizController(segue: UIStoryboardSegue) {
        autreQuestionLabel.isEnabled = true
        UserDefaults.standard.set(0, forKey: "thisQuizGoodAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizHintAnswer")
        UserDefaults.standard.set(0, forKey: "thisQuizBadAnswer")
        barreProgression.progress = 0.0
        progressInt = 0
        reponse.text = ""
        index = 0
        difficulté = .DIFFICILE
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: reponse, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondissapear)
        personneResponse.isHidden = true
        personne.isHidden = false
    }
    @IBAction func autreQuestionPushed(_ sender: UIButton) {
        setQuestion()
        personne.isHidden = false
        reponse.isHidden = false
        wrongAnswerCorrection.isHidden = true
        personneResponse.isHidden = true
        checkButton.isEnabled = true
        reponse.isEnabled = true
        reponse.textColor = UIColor.black
        reponse.text = ""
        verbResponseButton.setTitle("Scegli il verbo".localized, for: .disabled)
        difficulté = .DIFFICILE
        rightHintWasSelected = false
        TextFieldProperties.initiate(verbHintButton: verbHintButton, verbResponseButton: verbResponseButton, checkButton: checkButton, verbTextField: reponse, difficulté: difficulté, suggestionButton: suggestionButton, hintMenuAction: hintMenuActiondAppear)
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
        userRespone = reponse.text!
        afterUserResponse()
        checkButton.isEnabled = false
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        suggestionButton.isEnabled = false
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        reponse.isHidden = true
        verbResponseButton.isHidden = false
        checkButton.isHidden = true
    }
    @IBAction func verbHintPressed(_ sender: UIButton) {
        userRespone = (sender.titleLabel?.text?.lowercased())!
        if conjugatedVerb.lowercased() == sender.titleLabel?.text?.lowercased() {
            rightHintWasSelected = true
        }else{
            rightHintWasSelected = false
        }
        afterUserResponse()
        hintMenuActiondissapear()
    }
    @IBAction func traductionButtonPushed(_ sender: UIButton) {
        showAlert()
    }
    func afterUserResponse() {
        soundPlayer = SoundPlayer()
        reponseEvaluation = ResponseEvaluation.evaluate(modeVerb: quizQuestion.mode, tempsVerb:  quizQuestion.temp, infinitif: quizQuestion.infinitif, userResponse: userRespone, rightAnswer: conjugatedVerb, rightHintWasSelected: rightHintWasSelected)
        let pronom = personne.text!
        correctionResponse = "\(pronom) \(conjugatedVerb)"
        switch reponseEvaluation {
        case .good:
            wrongAnswerCorrection.textColor = UIColor.black
            Speak.text(text: "\(pronom) \(conjugatedVerb)")
            wrongAnswerCorrection.isHidden = false
            wrongAnswerCorrection.text = correctionResponse
            verbResponseButton.setTitle("Ben fatto!".localized, for: .disabled)
            wrongAnswerCorrection.clickLabel()
        case .help:
            wrongAnswerCorrection.textColor = UIColor.black
            Speak.text(text: "\(pronom) \(conjugatedVerb)")
            wrongAnswerCorrection.isHidden = false
            wrongAnswerCorrection.text = correctionResponse
            verbResponseButton.setTitle("Ben fatto!".localized, for: .disabled)
            wrongAnswerCorrection.clickLabel()
        case .bad:
            soundPlayer?.playSound(soundName: "etc_error_drum", type: "mp3")
            verbResponseButton.setTitle("Sbagliato...".localized, for: .disabled)
            wrongAnswerCorrection.isHidden = false
            wrongAnswerCorrection.textColor = UIColor.red
            wrongAnswerCorrection.text = correctionResponse
            wrongAnswerCorrection.clickLabel()
        }
        reponse.resignFirstResponder()
        personneResponse.isHidden = true
        personne.isHidden = true
        checkButton.isEnabled = false
        checkButton.setTitleColor(UIColor.gray, for: .disabled)
        suggestionButton.isEnabled = false
        suggestionButton.backgroundColor = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
        reponse.isHidden = true
        verbResponseButton.isHidden = false
        checkButton.isHidden = true
        progressInt = progressInt + 1
        barreProgression.progress = Float(progressInt)/Float(verbCountInQuiz)
        if progressInt == verbCountInQuiz {
            let when = DispatchTime.now() + 1.0 // change 2 to desired number of seconds
            uneAutreQuestionButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.performSegue(withIdentifier: "showResult", sender: nil)
            }
        }
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
            englishVerbe = "La traduzione non è disponibile".localized
        }
        let alertController = UIAlertController(title: "\(verbeFinal):  \(englishVerbe)", message: nil, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = temps.frame
        let okAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc func voiceDidTerminate(_ notification: NSNotification){
        print("terminate")
        switch reponseEvaluation {
        case .good:
            wrongAnswerCorrection.textColor = .black
        case .help:
            wrongAnswerCorrection.textColor = .black
        case .bad:
            wrongAnswerCorrection.textColor = .red
        }
    }
}
