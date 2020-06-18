//
//  MathUtils.swift
//  ca-app
//
//  Created by Nikhil on 6/18/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import Foundation

class Counter {
    private var incrementer: Int = 0
    
    func getNext() -> Int {
        incrementer += 1
        return incrementer
    }
}

enum DayOfWeek : String, CaseIterable, Equatable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    static func == (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        return DayOfWeek.allCases.firstIndex(of: lhs) == DayOfWeek.allCases.firstIndex(of: rhs)
    }
    
    static func fromString(_ value: String) -> DayOfWeek? {
        for day: DayOfWeek in DayOfWeek.allCases {
            if day.rawValue == value {
                return day
            }
        }
        return nil
    }
}

struct ClockTime : Comparable {
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    func toString(_ militaryTime: Bool) -> String {
        if militaryTime {
            return "\(hours):\(minutes):\(seconds)"
        } else {
            let timeHalf = hours / 12 > 1 ? "PM" : "AM"
            return "\(hours % 12):\(minutes):\(seconds) \(timeHalf)"
        }
    }
    
    func valueInSeconds() -> Int {
        return (self.hours * 3600) + (self.minutes * 60) + self.seconds
    }
    
    static func < (lhs: ClockTime, rhs: ClockTime) -> Bool {
        return lhs.valueInSeconds() < rhs.valueInSeconds()
    }
}

struct ClockTimeRange {
    let start: ClockTime
    let end: ClockTime
    let duration: Int
    
    init(start: ClockTime, end: ClockTime) {
        self.start = start
        self.end = end
        self.duration = end.valueInSeconds() - start.valueInSeconds()
    }
    
    static func fromString(_ str: String) -> ClockTimeRange? {
        let str = str.lowercased()
        var holderTime: ClockTime?
        let hasPm: Bool = str.contains("pm")
        let hasDash: Bool = str.contains("-")
        for word: Substring in str.split(separator: " ") {
            var tempTime: ClockTime?
            if Int(word) != nil {
                tempTime = ClockTime(hours: Int(word)! + (hasPm ? 12 : 0), minutes: 0, seconds: 0)
            } else if word.contains(":") {
                let cin = word.firstIndex(of: Character(":"))!
                let hours = Int(word[..<cin])! + (hasPm ? 12 : 0)
                let minutes = Int(word[word.index(after: cin)...])! / 60
                tempTime = ClockTime(hours: hours, minutes: minutes, seconds: 0)
            }
            if tempTime != nil {
                if holderTime == nil {
                    if hasDash {
                        holderTime = tempTime
                    } else {
                        return ClockTimeRange(start: tempTime!, end: tempTime!)
                    }
                } else {
                    return ClockTimeRange(start: holderTime!, end: tempTime!)
                }
            }
        }
        
        return nil
    }
}

enum TimeFormat {
    case h12, h24
}

//TODO fix camelCase and Title Case
class StringUtils {
    static func toCase(_ str: String,_ strCase: StringCases) -> String {
        switch strCase {
            case .camel:
            return ":"
            case .lower:
                return str.lowercased()
            case .upper:
                return str.uppercased()
            case .title:
                for splitStr: Substring in str.split(separator: " ") {
                    var splitStr: String = String(splitStr)
                    let range = ...splitStr.index(after: str.startIndex)
                    splitStr.replaceSubrange(range, with: splitStr[range].uppercased())
                }
        }
        return str
    }
}

enum StringCases {
    case camel, upper, lower, title
}
