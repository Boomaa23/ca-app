//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation
import UIKit
import SwiftUI

extension String {
    func capsAP() -> String {
        return self.replacingOccurrences(of: "ap", with: "AP").replacingOccurrences(of: "Ap", with: "AP")
    }
    
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
    
    static func blank() -> String {
        return ""
    }
        
    enum Case {
        case camel, upper, lower, title
    }
}

extension Optional where Wrapped == String {
    func toNonNil(_ value: String = "N/A") -> String {
        return self ?? value
    }
}

extension Image {
    func toSquareSize(_ size: CGFloat) -> some View {
        return self.resizable().frame(width: size, height: size, alignment: .center)
    }
}

extension Text {
    func toLink(_ url: String,_ color: Color = .blue) -> some View {
        return Text.createLink(url, color, self)
    }
    
    static func createLink(_ url: String,_ color: Color = .blue,_ obj: Text? = nil) -> some View {
        return (obj ?? Text(url)).foregroundColor(color).onTapGesture {
            UIApplication.shared.open(URL(string: url)!)
        }
    }
}
