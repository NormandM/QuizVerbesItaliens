//
//  TextFieldProperties.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2018-12-05.
//  Copyright © 2018 Normand Martin. All rights reserved.
//

import UIKit
struct TextFieldProperties {
    static func initiate (verbHintButton: [UIButton], verbResponseButton: UIButton, checkButton: UIButton, verbTextField: UITextField, difficulté: DifficultyLevel, suggestionButton: UIButton, hintMenuAction: () -> Void ) {
        suggestionButton.backgroundColor = UIColor(red: 27/255, green: 95/255, blue: 94/255, alpha: 1.0)
        switch difficulté {
        case .FACILE:
            verbHintButton.forEach {(eachButton) in
                eachButton.isHidden = false
            }
            verbResponseButton.isHidden = false
            verbResponseButton.setTitle("Scegli il verbo".localized, for: .disabled)
            verbTextField.isHidden = true
            checkButton.isHidden = true
            suggestionButton.isHidden = true
        case .DIFFICILE:
            verbHintButton.forEach {(eachButton) in
                eachButton.isHidden = true
            }
            verbResponseButton.isHidden = true
            verbTextField.isHidden = false
            checkButton.isHidden = false
            verbTextField.isEnabled = true
            checkButton.isEnabled = true
            suggestionButton.isEnabled = true
            suggestionButton.isHidden = false
        }
        
    }

}
