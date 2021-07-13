//
//  TableViewCell.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 2021-06-22.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import UIKit

class FirstStatTableViewCell: UITableViewCell {
    @IBOutlet weak var rightAnswerLabel: UILabel!
    @IBOutlet weak var rightwithHintLabel: UILabel!
    @IBOutlet weak var wrongAnswerLabel: UILabel!
    @IBOutlet weak var percentRightLabel: UILabel!
    let cBon = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
    let cMal = UIColor(red: 218/255, green: 69/255, blue: 49/255, alpha: 1.0)
    let cAide = UIColor(red: 178/255, green: 208/255, blue: 198/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightAnswerLabel.backgroundColor = cBon
        rightwithHintLabel.backgroundColor = cAide
        wrongAnswerLabel.backgroundColor = cMal
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
