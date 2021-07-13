//
//  FetchResultFoeOneTemp.swift
//  QuizVerbesItaliens
//
//  Created by NORMAND MARTIN on 2021-06-29.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import Foundation
struct FetchResult {
    static func fetchingData(selectedMode: String, selectedTemp: String, listeVerbe: [String]) -> ([[Int]], [[String]]){
        var resultArray = [[Int]]()
        var resultArrayString = [[String]]()
        for verb in listeVerbe {
            let result = FetchRequestForVerb.evaluate(modeVerb: selectedMode.lowercased().capitalizingFirstLetter(), tempsVerb: selectedTemp, verbInfinitif: verb)
            resultArray.append(result.0)
            resultArrayString.append(result.1)
        }
        return (resultArray, resultArrayString)
    }
    static func resultPertermp(resultArray: [[Int]]) -> (Int, Int, Int, String){
        var goodResultWithHint = 0
        var goodResult = 0
        var badResult = 0
        var result = String()
        for array in resultArray {
            goodResultWithHint = goodResultWithHint + array[0]
            goodResult = goodResult + array[1]
            badResult = badResult + array[2]
        }
        if (goodResult + badResult + goodResultWithHint) != 0 {
           result = String(round(Double(goodResult) / Double(goodResult + badResult + goodResultWithHint) * 100)) + "%"
            
        }else{
            result = "_"
        }
        return(goodResult, badResult, goodResultWithHint, result)
    }
    
    static func resultPerVerb(resultArray: [[String]]) -> ([[[String]]], [String]){
        var forImprovementArray = [[[String]]]()
        var infinitveVerbsForImprovement = [String]()
        var singleImprovementArray = [[String]]()
        for var result in resultArray {
            if result[1] != "" && result[2] != "" && result[3] != ""{
                let percent =  String(round(Double(result[2])!/(Double(result[1])! + Double(result[2])! + Double(result[3])!) * 100)) + "%"
                result.append(percent)
                singleImprovementArray.append(result)
            }
        }
        
        singleImprovementArray.sort(by: {Double($0[4].dropLast())! < Double($1[4].dropLast())!})
        
        for array in singleImprovementArray {
            forImprovementArray.append([array])
        }
        for array in singleImprovementArray {
            infinitveVerbsForImprovement.append(array[0])
        }
        return (forImprovementArray, infinitveVerbsForImprovement)
    }


}

