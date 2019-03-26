//
//  ChoiceOfSentence.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-11-28.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit

struct Sentences {
    let selectedSentences: [[String]]
    let indexSentence: Int
    let infinitif: String
    let tempsDuVerbe: String
    let modeDuverbe: String
    let reponseBonne: String
    let attributeQuestion:  NSMutableAttributedString
    let attributeBonneReponse:  NSMutableAttributedString
    let attributeMauvaiseReponse: NSMutableAttributedString
    init (selectedSentences: [[String]], indexSentence: Int) {
        self.selectedSentences = selectedSentences
        self.indexSentence = indexSentence
        infinitif = selectedSentences[indexSentence][4]
        tempsDuVerbe = selectedSentences[indexSentence][1]
        modeDuverbe = selectedSentences[indexSentence][0]
        reponseBonne = selectedSentences[indexSentence][3]
        var string_to_color = "(" + infinitif + ")"
        let sentenceQuestion = selectedSentences[indexSentence][2] + " " + string_to_color + " " + selectedSentences[indexSentence][5]
        var range = (sentenceQuestion as NSString).range(of: string_to_color)
        attributeQuestion = NSMutableAttributedString.init(string: sentenceQuestion)
        attributeQuestion.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0) , range: range)
        string_to_color = reponseBonne
        let sentenceBonneReponse = selectedSentences[indexSentence][2] + " " + reponseBonne + " " + selectedSentences[indexSentence][5]
        range = (sentenceBonneReponse as NSString).range(of: string_to_color)
        attributeBonneReponse = NSMutableAttributedString.init(string: sentenceBonneReponse)
        attributeBonneReponse.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)
        attributeMauvaiseReponse = NSMutableAttributedString.init(string: sentenceBonneReponse)
        attributeMauvaiseReponse.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 218/255, green: 69/255, blue: 49/255, alpha: 1.0) , range: range)
        
    }
}
