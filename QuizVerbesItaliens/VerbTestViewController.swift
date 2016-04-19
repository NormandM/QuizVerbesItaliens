//
//  ViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 15-12-26.
//  Copyright © 2015 Normand Martin. All rights reserved.
//

import UIKit
import AudioToolbox
var soundURL: NSURL?
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
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "appMovedToBackground", name: UIApplicationWillResignActiveNotification, object: nil)
        
        // Setting up notification to detect rotation
        let notificationCenter2 = NSNotificationCenter.defaultCenter()
            notificationCenter2.addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
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
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 50)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 50)
    }
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

    
    // Definition of the function retrieveing verbs from the Plist and selecting one for the question
    func retrieveVerbes() {
        var vChoix: [String] = []
        var tChoisi: [String] = []
        correction.text = ""
        response.text = ""
        if let plistPath = NSBundle.mainBundle().pathForResource("ItalianVerbPlist", ofType: "plist"),
            let verbeDictionary = NSDictionary(contentsOfFile: plistPath){
                let listeDeVerbe = ListedeVerbe(verbeDictionary: verbeDictionary)
                dictVerbes = listeDeVerbe.dictVerbes
                infinitif = listeDeVerbe.infinitif
                tempsVerbe = listeDeVerbe.tempsVerbe
                personneVerbe = listeDeVerbe.personneVerbe
                
           //Next lines finds out if the user selected the verb to be in are, ere or ire
                for infinitifVerb in infinitif {
                    let suffixeVerbe = infinitifVerb[infinitifVerb.endIndex.predecessor().predecessor().predecessor()]
                    if modeChoixVerbe == "TERMINAZIONI DEI VERBI are" {
                        if suffixeVerbe == "a" {
                            vChoix.append(infinitifVerb)
                        }
                    }else if modeChoixVerbe == "TERMINAZIONE DEI VERBI ere" {
                        if suffixeVerbe == "e" {
                            vChoix.append(infinitifVerb)
                        }
                    }else if modeChoixVerbe == "TERMINAZIONE DEI VERBI ire" {
                        if suffixeVerbe == "i" {
                            vChoix.append(infinitifVerb)
                        }
                    }else  {
                        vChoix = infinitif
                    }
                }
            
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
        func chooseVerb() -> String {
            let verbeElection = randomVerbe()
            let infinitifTest = verbeElection[0]
            let tempsTest = verbeElection[1]
            let personneTest = verbeElection[2]
            let leVerbeChoisiVerbe =  dictVerbes[infinitifTest]
            
            if let leVerbeChoisiTemps = leVerbeChoisiVerbe?[tempsTest],let leVerbeChoisiPersonne = leVerbeChoisiTemps[personneTest]{
                verbeAConjuguer.text = infinitifTest.uppercaseString
                personneDuVerbe.text = personneTest
                goodResponse = leVerbeChoisiPersonne
                
                // splitting temps du verbe to have it in two distinct labels: modeDuVerbe and tempsDuVerbe
                let result = tempsTest.componentsSeparatedByString(" ")
                
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
    func textFieldShouldReturn(response: UITextField) -> Bool {
// For these 2 arrays the first Int represents good answer, the second a bad answer.
        var statReponse: [Int] = [0,0]
        var statReponseTemps: [Int] = [0,0]
        let tempsTotal = modeDuVerbe.text! + " " + tempsDuVerbe.text!
        let verbeConjugueTotal = verbeAConjuguer.text?.lowercaseString
        if response.text == goodResponse {
            let reponse = NSUserDefaults.standardUserDefaults()
// Making sure the values in NUserDefaults are not nil
            if reponse.arrayForKey(verbeConjugueTotal!) == nil {
                reponse.setObject([0, 0], forKey: verbeConjugueTotal!)
            }
            if reponse.arrayForKey(tempsTotal) == nil {
                reponse.setObject([0, 0], forKey: tempsTotal)
            }
// Adding the total good responses for both the verb and the time of the verb
            statReponse = reponse.arrayForKey(verbeConjugueTotal!) as! [Int]
            statReponseTemps = reponse.arrayForKey(tempsTotal) as! [Int]
            ++statReponse[0]
            ++statReponseTemps[0]
            reponse.setObject(statReponse, forKey: verbeConjugueTotal!)
            reponse.setObject(statReponseTemps, forKey: tempsTotal)
            correction.text = "Buonissimo!"
// Adding sound for good response and changing text to blue
            let filePath = NSBundle.mainBundle().pathForResource("Incoming Text 01", ofType: "wav")
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
            correction.textColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)

        }else{
// Adding the total bad responses for both the verb and the time of the verb
            let reponse = NSUserDefaults.standardUserDefaults()
            if reponse.arrayForKey(verbeConjugueTotal!) == nil {
                reponse.setObject([0, 0], forKey: verbeConjugueTotal!)
            }
            if reponse.arrayForKey(tempsTotal) == nil {
                reponse.setObject([0, 0], forKey: tempsTotal)
            }
            statReponse = reponse.arrayForKey(verbeConjugueTotal!) as! [Int]
            statReponseTemps = reponse.arrayForKey(tempsTotal) as! [Int]
            ++statReponse[1]
            ++statReponseTemps[1]
            reponse.setObject(statReponse, forKey: verbeConjugueTotal!)
            reponse.setObject(statReponseTemps, forKey: tempsTotal)
// Adding sound for bad response and changing text to red
            let filePath = NSBundle.mainBundle().pathForResource("Error Warning", ofType: "wav")
            soundURL = NSURL(fileURLWithPath: filePath!)
            AudioServicesCreateSystemSoundID(soundURL!, &soundID)
            AudioServicesPlaySystemSound(soundID)
            correction.textColor = UIColor(red: 255/255, green: 17/255, blue: 93/255, alpha: 1.0)
            
            correction.text = " \(goodResponse)"
        }
 // Hiding the Keyboard after response was written and return was pressed
        response.resignFirstResponder()
        return true
        
    }
    
    // Calling the display of the next view with statistical results
    @IBAction func vedereStatistica(sender: AnyObject) {
        
    
    }
    // Transfering data to next view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStatisticView" {
            let verbeStatistic = segue.destinationViewController as! StatitsticViewController
            verbeStatistic.verbesStatistics = infinitif
            verbeStatistic.tempsStatistics = tempsVerbe


    }
    }

}
