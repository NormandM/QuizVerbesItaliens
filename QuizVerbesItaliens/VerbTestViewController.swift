//
//  ViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 15-12-26.
//  Copyright © 2015 Normand Martin. All rights reserved.
//

import UIKit
import AudioToolbox
var soundURL: URL?
var soundID:SystemSoundID = 0

var infinitif: [String] = []
var tempsVerbe: [String] = []
var personneVerbe: [String] = []
var personneVerbeCount: Int = 0
var dictVerbes: [String: [String:[String: String]]] = ["": ["":["": ""]]]
var goodResponse: String = ""
var tempsTest: String = ""


class VerbTestViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var verbeAConjuguer: UILabel!
    @IBOutlet weak var tempsDuVerbe: UILabel!
    @IBOutlet weak var personneDuVerbe: UILabel!
    @IBOutlet weak var correction: UILabel!
    @IBOutlet weak var response: UITextField!
    @IBOutlet weak var vedereStatistica: UIButton!
    @IBOutlet weak var altro: UIButton!
    @IBOutlet weak var modeDuVerbe: UILabel!
    var modeChoixVerbe: String = ""
    var mode = ""
    var up = true
    

    override func viewDidLoad() {
                super.viewDidLoad()
        self.navigationItem.title = "Rispondere"
        
        // Setting up notification to detect when appa goes into the background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(VerbTestViewController.appMovedToBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        // Setting up notification to detect rotation
        let notificationCenter2 = NotificationCenter.default
            notificationCenter2.addObserver(self, selector: #selector(VerbTestViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        modeChoixVerbe = mode + " \(modeChoixVerbe)"
        retrieveVerbes()
       
    }
    // Hiding keyboard when apps goes into background
    func appMovedToBackground() {
        self.view.endEditing(true)
    }
    
    // Hiding keyboard when rotating
    func rotated() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // This button calls the func otro when press getting setting another verb as a question
    @IBAction func otro() {
        retrieveVerbes()
    }
    
    
    // the 3 next function moves the KeyBoards when keyboard appears or hides
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(true, moveValue: 50)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(false, moveValue: 50)
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

    
    // Definition of the function retrieveing verbs from the Plist and selecting one for the question
    func retrieveVerbes() {
        var vChoix: [String] = []
        var tChoisi: [String] = []
        correction.text = ""
        response.text = ""
        if let plistPath = Bundle.main.path(forResource: "ItalianVerbPlist", ofType: "plist"),
            let verbeDictionary = NSDictionary(contentsOfFile: plistPath){
                let listeDeVerbe = ListedeVerbe(verbeDictionary: verbeDictionary as! [String : [String : AnyObject]])
                dictVerbes = listeDeVerbe.dictVerbes
                infinitif = listeDeVerbe.infinitif
                tempsVerbe = listeDeVerbe.tempsVerbe
                personneVerbe = listeDeVerbe.personneVerbe
                
           //MARK: Next lines finds out if the user selected the verb to be in are, ere or ire
                for infinitifVerb in infinitif {
                    print(modeChoixVerbe)
                    let indexChar = infinitifVerb.characters.count
                    let suffixeVerbe = infinitifVerb[infinitifVerb.index(infinitifVerb.startIndex, offsetBy: indexChar - 3)]
  
                    if modeChoixVerbe == "TERMINAZIONI DEI VERBI are" {
                        
                        if suffixeVerbe == "a" {
                            vChoix.append(infinitifVerb)
                        }
                    }else if modeChoixVerbe == "TERMINAZIONI DEI VERBI ere" {
                        
                        if suffixeVerbe == "e" {
                            vChoix.append(infinitifVerb)
                            
                        }
                    }else if modeChoixVerbe == "TERMINAZIONI DEI VERBI ire" {
                        if suffixeVerbe == "i" {
                            vChoix.append(infinitifVerb)
                        }
                    }else  {
                       vChoix = infinitif
                    }

                }
            print(vChoix)
           // print(infinitif)
            // Next lines finds out what tense of verbs the user selected
                if modeChoixVerbe == "INDICATIVO Presente" {
                    tChoisi = ["Indicativo Presente"]
                }else if modeChoixVerbe == "INDICATIVO Futuro semplice"{
                    tChoisi = ["Indicativo Futuro semplice"]
                }else if modeChoixVerbe == "INDICATIVO Imperfetto"{
                    tChoisi = ["Indicativo Imperfetto"]
                }else if modeChoixVerbe == "INDICATIVO Passato prossimo"{
                    tChoisi = ["Indicativo Passato prossimo"]
                }else if modeChoixVerbe == "INDICATIVO Passato remoto"{
                    tChoisi = ["Indicativo Passato remoto"]
                }else if modeChoixVerbe == "INDICATIVO Trapassato prossimo"{
                    tChoisi = ["Indicativo Trapassato prossimo"]
                }else if modeChoixVerbe == "INDICATIVO Trapassato remoto"{
                    tChoisi = ["Indicativo Trapassato remoto"]
                }else if modeChoixVerbe == "INDICATIVO Futuro anteriore"{
                    tChoisi = ["Indicativo Futuro anteriore"]
                }else if modeChoixVerbe == "CONDIZIONALE Presente"{
                    tChoisi = ["Condizionale Presente"]
                }else if modeChoixVerbe == "CONDIZIONALE Passato"{
                    tChoisi = ["Condizionale Passato"]
                }else if modeChoixVerbe == "CONGIUNTIVO Presente"{
                    tChoisi = ["Congiuntivo Presente"]
                }else if modeChoixVerbe == "CONGIUNTIVO Imperfetto"{
                    tChoisi = ["Congiuntivo Imperfetto"]
                }else if modeChoixVerbe == "CONGIUNTIVO Passato"{
                    tChoisi = ["Congiuntivo Passato"]
                }else if modeChoixVerbe == "CONGIUNTIVO Trapassato"{
                    tChoisi = ["Congiuntivo Trapassato"]
                }else if modeChoixVerbe == "IMPERATIVO Presente"{
                    tChoisi = ["Imperativo Presente"]
                }else if modeChoixVerbe == "INDICATIVO Trapassato prossimo"{
                    tChoisi = ["Indicativo Trapassato prossimo"]
                }else{
                    tChoisi = tempsVerbe
                }
        }
        
        // this function randomly selects a verb from the plist taking into account the user's selection: are, ere, ire or tense of verb
        func randomVerbe() -> [String] {

            let infinitifRandom = Int(arc4random_uniform(UInt32(vChoix.count)))
            let tempsVerbeRandom = Int(arc4random_uniform(UInt32(tChoisi.count)))
            let verbeChoisi = vChoix[infinitifRandom]
            let tempsChoisi = tChoisi[tempsVerbeRandom]
        // For the imperative tence there is only 5 persons
            if tempsChoisi == "Imperativo Presente" {
                personneVerbeCount = 5
                
            }else {
                personneVerbeCount = 6
            }
            var personneVerbeRandom = Int(arc4random_uniform(UInt32(personneVerbeCount)))
            if tempsChoisi == "Imperativo Presente" {
                personneVerbeRandom = personneVerbeRandom + 1
            }
            let personneChoisi = personneVerbe[personneVerbeRandom]
            return [verbeChoisi, tempsChoisi, personneChoisi]
        }
        
        // Function chooseVerb breaks up the Array so the selected verb, tense and person can be displayed.
        @discardableResult func chooseVerb() -> String {
            let verbeElection = randomVerbe()
            let infinitifTest = verbeElection[0]
            let tempsTest = verbeElection[1]
            let personneTest = verbeElection[2]
            let leVerbeChoisiVerbe =  dictVerbes[infinitifTest]
            
            if let leVerbeChoisiTemps = leVerbeChoisiVerbe?[tempsTest],let leVerbeChoisiPersonne = leVerbeChoisiTemps[personneTest]{
                verbeAConjuguer.text = infinitifTest.uppercased()
                personneDuVerbe.text = personneTest
                goodResponse = leVerbeChoisiPersonne
                
                // splitting temps du verbe to have it in two distinct labels: modeDuVerbe and tempsDuVerbe
                let result = tempsTest.components(separatedBy: " ")
                
                modeDuVerbe.text = result[0]
                if result.count == 3 {
                    tempsDuVerbe.text = result[1] + " " + result[2]
                }else {
                    tempsDuVerbe.text = result[1]
                }
                if result[0] == "Imperativo" {
                    personneDuVerbe.text = "(\(personneTest))"
                }else if result[0] == "Congiuntivo" {
                    personneDuVerbe.text = "che \(personneTest)"
                }
                
            }
            return goodResponse
        }
      chooseVerb()

    }
// The next function checks if the response of the user is true or false. It also counts the good and bad responses and saves it in the NSUserDefault.
    func textFieldShouldReturn(_ response: UITextField) -> Bool {
// For these 2 arrays the first Int represents good answer, the second a bad answer.
        var statReponse: [Int] = [0,0]
        var statReponseTemps: [Int] = [0,0]
        let tempsTotal = modeDuVerbe.text! + " " + tempsDuVerbe.text!
        let verbeConjugueTotal = verbeAConjuguer.text?.lowercased()
        if response.text == goodResponse {
            let reponse = UserDefaults.standard
// Making sure the values in NUserDefaults are not nil
            if reponse.array(forKey: verbeConjugueTotal!) == nil {
                reponse.set([0, 0], forKey: verbeConjugueTotal!)
            }
            if reponse.array(forKey: tempsTotal) == nil {
                reponse.set([0, 0], forKey: tempsTotal)
            }
// Adding the total good responses for both the verb and the time of the verb
            statReponse = reponse.array(forKey: verbeConjugueTotal!) as! [Int]
            statReponseTemps = reponse.array(forKey: tempsTotal) as! [Int]
            statReponse[0] += 1
            statReponseTemps[0] += 1
            reponse.set(statReponse, forKey: verbeConjugueTotal!)
            reponse.set(statReponseTemps, forKey: tempsTotal)
            correction.text = "Buonissimo!"
// Adding sound for good response and changing text to blue
            let filePath = Bundle.main.path(forResource: "Incoming Text 01", ofType: "wav")
            soundURL = URL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL! as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
            correction.textColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)

        }else{
// Adding the total bad responses for both the verb and the time of the verb
            let reponse = UserDefaults.standard
            if reponse.array(forKey: verbeConjugueTotal!) == nil {
                reponse.set([0, 0], forKey: verbeConjugueTotal!)
            }
            if reponse.array(forKey: tempsTotal) == nil {
                reponse.set([0, 0], forKey: tempsTotal)
            }
            statReponse = reponse.array(forKey: verbeConjugueTotal!) as! [Int]
            statReponseTemps = reponse.array(forKey: tempsTotal) as! [Int]
            statReponse[1] += 1
            statReponseTemps[1] += 1
            reponse.set(statReponse, forKey: verbeConjugueTotal!)
            reponse.set(statReponseTemps, forKey: tempsTotal)
// Adding sound for bad response and changing text to red
            let filePath = Bundle.main.path(forResource: "Error Warning", ofType: "wav")
            soundURL = URL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL! as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
            correction.textColor = UIColor(red: 255/255, green: 17/255, blue: 93/255, alpha: 1.0)
            
            correction.text = " \(goodResponse)"
        }
 // Hiding the Keyboard after response was written and return was pressed
        response.resignFirstResponder()
        return true
        
    }
    


}
