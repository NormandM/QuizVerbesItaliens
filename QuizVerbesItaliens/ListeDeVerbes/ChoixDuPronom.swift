//
//  ChoixDeLaPersonne.swift
//  VerbAppRefactored
//
//  Created by Normand Martin on 2019-02-10.
//  Copyright © 2019 Normand Martin. All rights reserved.
//

import Foundation
struct ChoixDuPronom {
    let mode: String
    let temps: String
    let infinitif: String
    let conjugatedVerb: String
    let personne: String
    let pronom: String
    
    init(mode: String, temps: String, infinitif: String, personne: String, conjugatedVerb: String) {
        self.mode = mode
        self.temps = temps
        self.infinitif = infinitif
        self.personne = personne
        self.conjugatedVerb = conjugatedVerb
        var pronomTrans = String()
        switch personne {
        case "1":
            if mode == "Congiuntivo"{
                pronomTrans = "che io"
            }else if mode == "Imperativo"{
                pronomTrans = ""
            }else {pronomTrans = "io"}
        case "2":
            if mode == "Congiuntivo"{
                pronomTrans = "che tu"
            }else if mode == "Imperativo"{
                pronomTrans = "(tu)"
            }else{
                pronomTrans = "tu"
            }
        case "3":
            if mode == "Congiuntivo"{
                pronomTrans = "che lui, lei"
            }else if mode == "Imperativo"{
                pronomTrans = "(lui, lei)"
            }else{
                pronomTrans = "lui, lei"
            }
        case "4":
            if mode == "Congiuntivo"{
                pronomTrans = "che noi"
            }else if mode == "Imperativo"{
                pronomTrans = "(noi)"
            }else{
                pronomTrans = "noi"
            }
        case "5":
            if mode == "Congiuntivo"{
                pronomTrans = "che voi"
            }else if mode == "Imperativo"{
                pronomTrans = "(voi)"
            }else{
                pronomTrans = "voi"
            }
        case "6":
            if mode == "Congiuntivo"{
                pronomTrans = "che loro"
            }else if mode == "Imperativo"{
                pronomTrans = "(loro)"
            }else{
                pronomTrans = "loro"
            }
 
        default:
            break
        }
      pronom = pronomTrans
    }
}
    
    

