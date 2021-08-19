//
//  extensionLocalisation.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 2021-07-06.
//  Copyright © 2021 Normand Martin. All rights reserved.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
