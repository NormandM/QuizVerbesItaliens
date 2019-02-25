//
//  FinalVerbeViewController.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2016-12-03.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit

class FinalVerbeViewController: UIViewController {
    @IBOutlet weak var backgrounColorView: UIView!
    @IBOutlet weak var infinitif: UILabel!
    @IBOutlet weak var mode: UILabel!
    @IBOutlet weak var temps: UILabel!
    @IBOutlet weak var premier: UILabel!
    @IBOutlet weak var deuxieme: UILabel!
    @IBOutlet weak var troisieme: UILabel!
    @IBOutlet weak var quatrieme: UILabel!
    @IBOutlet weak var cinquieme: UILabel!
    @IBOutlet weak var sixieme: UILabel!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var fourth: UILabel!
    @IBOutlet weak var fifth: UILabel!
    @IBOutlet weak var sixth: UILabel!
    let screenSize: CGRect = UIScreen.main.bounds
    let fonts = FontsAndConstraintsOptions()
    var verbInfinitif = String()
    var modeVerb = String()
    var temp = String()
    typealias ListedVerb = Verb
    override func viewDidLoad() {
        super.viewDidLoad()
        let chosenVerb = ChosenVerb(infinitif: verbInfinitif, mode: modeVerb, temp: temp)
        let verb: ListedVerb = chosenVerb.conjugatedVerb
        infinitif.text = verb.verbInfinitif.capitalizingFirstLetter()
        mode.text = verb.mode.capitalizingFirstLetter()
        temps.text = verb.temp.capitalizingFirstLetter()
        premier.text = verb.firstPersonVerb
        deuxieme.text = verb.secondPersonVerb
        troisieme.text = verb.thirdPersonVerb
        quatrieme.text = verb.fourthPersonVerb
        cinquieme.text = verb.fifthPersonVerb
        sixieme.text = verb.sixthPersonVerb
        let choixDeLaPersonne1 = ChoixDuPronom(mode:  verb.mode, temps: verb.temp, infinitif: verb.verbInfinitif, personne: "1", conjugatedVerb: verb.firstPersonVerb)
        let choixDeLaPersonne2 = ChoixDuPronom(mode:  verb.mode, temps: verb.temp, infinitif: verb.verbInfinitif, personne: "2", conjugatedVerb: verb.secondPersonVerb)
        let choixDeLaPersonne3 = ChoixDuPronom(mode:  verb.mode, temps: verb.temp, infinitif: verb.verbInfinitif, personne: "3", conjugatedVerb: verb.thirdPersonVerb)
        let choixDeLaPersonne4 = ChoixDuPronom(mode:  verb.mode, temps: verb.temp, infinitif: verb.verbInfinitif, personne: "4", conjugatedVerb: verb.fourthPersonVerb)
        let choixDeLaPersonne5 = ChoixDuPronom(mode:  verb.mode, temps: verb.temp, infinitif: verb.verbInfinitif, personne: "5", conjugatedVerb: verb.fifthPersonVerb)
        let choixDeLaPersonne6 = ChoixDuPronom(mode:  verb.mode, temps: verb.temp, infinitif: verb.verbInfinitif, personne: "6", conjugatedVerb: verb.sixthPersonVerb)
        first.text = choixDeLaPersonne1.pronom
        second.text = choixDeLaPersonne2.pronom
        third.text = choixDeLaPersonne3.pronom
        fourth.text = choixDeLaPersonne4.pronom
        fifth.text = choixDeLaPersonne5.pronom
        sixth.text = choixDeLaPersonne6.pronom
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Verbo coniugato"
        backgrounColorView.layer.cornerRadius = 50
        infinitif.font = fonts.largeBoldFont
        mode.font = fonts.largeFont
        temps.font = fonts.largeFont
        premier.font = fonts.smallItaliqueBoldFont
        deuxieme.font = fonts.smallItaliqueBoldFont
        troisieme.font = fonts.smallItaliqueBoldFont
        quatrieme.font = fonts.smallItaliqueBoldFont
        cinquieme.font = fonts.smallItaliqueBoldFont
        sixieme.font = fonts.smallItaliqueBoldFont
        first.font = fonts.smallFont
        second.font = fonts.smallFont
        third.font = fonts.smallFont
        fourth.font = fonts.smallFont
        fifth.font = fonts.smallFont
        sixth.font = fonts.smallFont
    }
    


}
