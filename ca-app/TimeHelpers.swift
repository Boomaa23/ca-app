//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation

enum DayOfWeek : String, CaseIterable, Equatable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    static func == (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        return lhs.rawValue == rhs.rawValue
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
    
    func toString(_ militaryTime: Bool,_ excludeSeconds: Bool) -> String {
        if militaryTime {
            return "\(hours):\(minutes)" + (!excludeSeconds ? ":\(seconds)" : "")
        } else {
            return "\(hours <= 12 ? hours : hours - 12)" + ":"
                + "\(minutes)".toPadded(2, Character("0"))
                + (!excludeSeconds ? ":\(seconds)".toPadded(2, Character("0")) : "")
                + (hours < 12 ? " AM" : " PM")
        }
    }
    
    func valueInSeconds() -> Int {
        return (self.hours * 3600) + (self.minutes * 60) + self.seconds
    }
    
    static func < (lhs: ClockTime, rhs: ClockTime) -> Bool {
        return lhs.valueInSeconds() < rhs.valueInSeconds()
    }
}

struct ClockTimeRange : Equatable {
    let start: ClockTime
    let end: ClockTime
    let duration: Int
    
    init(start: ClockTime, end: ClockTime) {
        self.start = start
        self.end = end
        self.duration = end.valueInSeconds() - start.valueInSeconds()
    }
    
    func toString(_ militaryTime: Bool,_ excludeSeconds: Bool) -> String {
        return "\(start.toString(militaryTime, excludeSeconds)) - \(end.toString(militaryTime, excludeSeconds))"
    }
    
    static func fromString(_ str: String) -> ClockTimeRange? {
        let str = str.lowercased()
        var holderTime: ClockTime?
        let hasPm: Bool = str.contains("pm")
        let hasDash: Bool = str.contains("-")
        for word: Substring in str.split(separator: " ") {
            var tempTime: ClockTime?
            if Int(word) != nil {
                tempTime = ClockTime(hours: Int(word)! + (hasPm && Int(word)! < 12 ? 12 : 0), minutes: 0, seconds: 0)
            } else if word.contains(":") {
                let cin = word.firstIndex(of: Character(":"))!
                let hours = Int(word[..<cin])! + (hasPm && Int(word[..<cin])! < 12 ? 12 : 0)
                let minutes = Int(word[word.index(after: cin)...])!
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
