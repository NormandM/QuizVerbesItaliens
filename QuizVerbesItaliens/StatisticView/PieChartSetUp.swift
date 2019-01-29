//
//  PieChartSetUp.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-12-26.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
import Charts

struct PieChartSetUp {
    let entrieBon: Double
    let entrieMal: Double
    let entrieAide: Double
    let pieChartView: PieChartView
    let cBon = NSUIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
    let cMal = NSUIColor(red: 218/255, green: 69/255, blue: 49/255, alpha: 1.0)
    let cAide = NSUIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
    let cTrnasparent = NSUIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 0.0)
    var piechartData: ChartData
    init(entrieBon: Double, entrieMal: Double, entrieAide: Double, pieChartView: PieChartView){
        self.entrieBon = entrieBon
        self.entrieMal = entrieMal
        self.entrieAide = entrieAide
        self.pieChartView = pieChartView
        var pieDataLocal = ChartData()
        pieChartView.chartDescription?.enabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = false
        pieChartView.isUserInteractionEnabled = false
        pieChartView.legend.enabled = true
        let legend = pieChartView.legend
        let lengendEntry1 = LegendEntry(label: "Corretto", form: .default, formSize: .nan, formLineWidth: .leastNonzeroMagnitude, formLineDashPhase: .leastNormalMagnitude, formLineDashLengths: nil, formColor: cBon)
        let lengendEntry2 = LegendEntry(label: "Sbaliato", form: .default, formSize: .nan, formLineWidth: .leastNormalMagnitude, formLineDashPhase: .leastNormalMagnitude, formLineDashLengths: nil, formColor: cMal)
        let lengendEntry3 = LegendEntry(label: "Con l'aiuto", form: .default, formSize: .nan, formLineWidth: .leastNormalMagnitude, formLineDashPhase: .leastNormalMagnitude, formLineDashLengths: nil, formColor: cAide)
        let legengEntry4 = LegendEntry(label: "", form: .default, formSize: .nan, formLineWidth: .leastNormalMagnitude, formLineDashPhase: .leastNormalMagnitude, formLineDashLengths: nil, formColor: cTrnasparent)
        legend.horizontalAlignment = .center
        var entries : [PieChartDataEntry] = Array()
        let casesPie = [entrieBon,entrieMal,entrieAide]
        switch casesPie {
        case [entrieBon,0,0]:
            entries.append(PieChartDataEntry(value: entrieBon, label: ""))
            let dataSet = PieChartDataSet(values: entries, label: "")
            var legendEntryArray: [LegendEntry] = []
            if entrieBon == 0.0 {
                dataSet.colors = [cTrnasparent]
                legendEntryArray = [legengEntry4]
            }else{
                legendEntryArray = [lengendEntry1]
                dataSet.colors = [cBon]
            }
            legend.setCustom(entries: legendEntryArray)
            pieDataLocal = PieChartData(dataSet: dataSet)
            dataSet.drawValuesEnabled = false
        case [0,entrieMal,0]:
            entries.append(PieChartDataEntry(value: entrieMal, label: ""))
            let dataSet = PieChartDataSet(values: entries, label: "")
            dataSet.colors = [cMal]
            let legendEntryArray = [lengendEntry2]
            legend.setCustom(entries: legendEntryArray)
            pieDataLocal = PieChartData(dataSet: dataSet)
            dataSet.drawValuesEnabled = false
        case [0,0,entrieAide]:
            entries.append(PieChartDataEntry(value: entrieAide, label: ""))
            let dataSet = PieChartDataSet(values: entries, label: "")
            dataSet.colors = [cAide]
            let legendEntryArray = [lengendEntry3]
            legend.setCustom(entries: legendEntryArray)
            pieDataLocal = PieChartData(dataSet: dataSet)
            dataSet.drawValuesEnabled = false
        case [entrieBon,entrieMal,0]:
            entries.append(PieChartDataEntry(value: entrieBon, label: ""))
            entries.append(PieChartDataEntry(value: entrieMal, label: ""))
            let dataSet = PieChartDataSet(values: entries, label: "")
            dataSet.colors = [cBon, cMal]
            let legendEntryArray = [lengendEntry1, lengendEntry2]
            legend.setCustom(entries: legendEntryArray)
            pieDataLocal = PieChartData(dataSet: dataSet)
            dataSet.drawValuesEnabled = false
        case [entrieBon,0,entrieAide]:
            entries.append(PieChartDataEntry(value: entrieBon, label: ""))
            entries.append(PieChartDataEntry(value: entrieAide, label: ""))
            let dataSet = PieChartDataSet(values: entries, label: "")
            dataSet.colors = [cBon, cAide]
            let legendEntryArray = [lengendEntry1,lengendEntry3]
            legend.setCustom(entries: legendEntryArray)
            pieDataLocal = PieChartData(dataSet: dataSet)
            dataSet.drawValuesEnabled = false
        case[0,entrieMal,entrieAide]:
            entries.append(PieChartDataEntry(value: entrieMal, label: ""))
            entries.append(PieChartDataEntry(value: entrieAide, label: ""))
            let dataSet = PieChartDataSet(values: entries, label: "")
            dataSet.colors = [cMal, cAide]
            let legendEntryArray = [lengendEntry2, lengendEntry3]
            legend.setCustom(entries: legendEntryArray)
            pieDataLocal = PieChartData(dataSet: dataSet)
            dataSet.drawValuesEnabled = false
        case [entrieBon,entrieMal,entrieAide]:
            entries.append(PieChartDataEntry(value: entrieAide, label: ""))
            entries.append(PieChartDataEntry(value: entrieBon, label: ""))
            entries.append(PieChartDataEntry(value: entrieMal, label: ""))
            let dataSet = PieChartDataSet(values: entries, label: "")
            let legendEntryArray = [lengendEntry1, lengendEntry2, lengendEntry3]
            legend.setCustom(entries: legendEntryArray)
            dataSet.colors = [cAide, cBon, cMal]
            pieDataLocal = PieChartData(dataSet: dataSet)
            dataSet.drawValuesEnabled = false
        default:
            break
        }
        piechartData = pieDataLocal
    }
}
