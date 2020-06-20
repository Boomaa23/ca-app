//
//  MathUtils.swift
//  ca-app
//
//  Created by Nikhil on 6/18/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import Foundation
import SwiftUI

extension String {
    func toPadded(_ num: Int,_ char: Character) -> String {
        let diff = num - self.count
        if diff <= 0 {
            return self
        } else {
            var out = self
            for _ in [0..<diff] {
                out.append(char)
            }
            return out
        }
    }
    
    func toCase(_ strCase: Case) -> String {
        switch strCase {
            case .camel:
                let title = self.toCase(String.Case.title)
                return title.replacingCharacters(in: ...title.startIndex, with: title[...title.startIndex].uppercased()).replacingOccurrences(of: " ", with: "")
            case .title:
                var outStr: String = ""
                let arrSplit = self.split(separator: " ")
                for (count, splStr) in arrSplit.enumerated() {
                    let splitStr: String = String(splStr)
                    let index = splitStr.index(after: self.startIndex)
                    outStr += splitStr[..<index].uppercased() + splitStr[index...] + (count != arrSplit.count - 1 ? " " : "")
                }
                return outStr
            case .lower:
                return self.lowercased()
            case .upper:
                return self.uppercased()
        }
    }
    
    func charAt(int: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: int)]
    }
        
    enum Case {
        case camel, upper, lower, title
    }
}

//TODO implement
extension UITextView {
    func attributeText(_ text: NSMutableAttributedString) -> UITextView {
        self.attributedText = text
        return self
    }
}

