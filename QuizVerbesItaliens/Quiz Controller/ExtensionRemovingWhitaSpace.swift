//
//  ExtensionRemovingWhitaSpace.swift
//  French Verbs Quiz
//
//  Created by Normand Martin on 2022-12-12.
//  Copyright © 2022 Normand Martin. All rights reserved.
//

import Foundation
extension String {
    func removeWhiteSpace() -> String{
        self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")

    }
}
