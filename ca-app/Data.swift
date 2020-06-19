//
//  Data.swift
//  ca-app
//
//  Created by Nikhil on 6/14/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import Foundation
import SwiftSoup

class Tutor : Comparable {
    private var num: Int?
    private var zoomUrl: String?
    let firstName: String
    let lastName: String
    let grade: Grade
    var subjects: [SubjectRange]
    
    init(firstName: String, lastName: String, grade: Grade, subjects: [SubjectRange]) {
        self.firstName = firstName
        self.lastName = lastName
        self.grade = grade
        self.subjects = subjects
    }
    
    func getNum() -> Int {
        if self.num != nil {
            return self.num!
        }
        do {
            let iframes = try SwiftSoup.parse(RequestHelper.caGet(relUrl: getRelUrl())).getElementsByTag("iframe")
            for frame in iframes {
                let attrText = try frame.attr("srcdoc")
                let calName = "\(firstName)\(lastName[lastName.startIndex])"
                if attrText.range(of: calName) != nil {
                    let upper = attrText.index(before: attrText.index(before: attrText.range(of: calName)!.lowerBound))
                    let lower = attrText.range(of: "dphstutor")!.upperBound
                    return Int(String(attrText[lower...upper]))!
                }
            }
        } catch let error {
            print(error)
        }
        return -1
    }
    
    func getZoomUrl() -> String? {
        if self.zoomUrl != nil {
            return self.zoomUrl!
        }
        do {
            if self.num == nil {
                self.num = getNum()
            } else if num == -1 {
                return nil
            }
            let meta = try SwiftSoup.parse(RequestHelper.get(url: getCalendlyUrl())).getElementsByTag("meta")
            for href in meta {
                let link = try href.getElementsByAttributeValue("name", "description")
                if link.first() == nil {
                    continue
                }
                let fullDesc = try link.first()!.attr("content")
                if fullDesc.contains("zoom.us") {
                    let begin = fullDesc.range(of: "https://")!.lowerBound
                    let end = fullDesc.range(of: "Meeting ID")!.lowerBound
                    self.zoomUrl = String(fullDesc[begin..<end])
                    return self.zoomUrl
                }
            }
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func getRelUrl() -> String {
        return firstName.lowercased() + "-" + lastName.lowercased()
    }
    
    func getCalendlyUrl() -> String {
        return "https://calendly.com/dphstutor\(num!)/\(firstName)\(lastName[lastName.startIndex])"
    }
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
    
    static func < (lhs: Tutor, rhs: Tutor) -> Bool {
        return lhs.getRelUrl() < rhs.getRelUrl()
    }
    
    static func == (lhs: Tutor, rhs: Tutor) -> Bool {
        return lhs.getRelUrl() == rhs.getRelUrl()
    }
}

struct SubjectRange {
    let subject: Subject
    let applicableLevels: [String]
    
    init(subject: Subject, maxLevel: String) {
        self.subject = subject
        let i = subject.levels.firstIndex(of: maxLevel)
        self.applicableLevels = Array<String>(subject.levels[...i!])
    }
    
    init(subject: Subject, applicableLevels: [String]) {
        self.subject = subject
        self.applicableLevels = applicableLevels
    }
}

struct Subject {
    let baseName: String
    let section: SiteSection
    let prefix: (value: String, loc: PrefixLocation)
    let levels: [String]
    
    init(_ baseName: String,_ section: SiteSection,_ prefix: (value: String, loc: PrefixLocation),_ levels: [String]) {
        self.baseName = baseName
        self.section = section
        self.prefix = prefix
        self.levels = levels
    }
    
    func withPrefix(_ level: String) -> String {
        switch prefix.loc {
            case .after:
                return "\(level) \(prefix.value)"
            case .before:
                return "\(prefix.value) \(level)"
            case .none:
                return level
        }
    }
    
    static func fromOther(_ keyText: String) -> Subject? {
        let possibleOthers = ["writing", "tech", "time management", "german", "latin", "art"]
        for other: String in possibleOthers {
            if keyText.contains(other) {
                return Subject(other, SiteSection.other, ("", PrefixLocation.none), [])
            }
        }
        return nil
    }
    
    static func getAllClasses() -> [String: Subject] {
        return [
            "mathCommon": Subject("mathCommon", SiteSection.math, ("Math", PrefixLocation.before),
                    ["1 Support", "1", "1+E", "2 Support", "2+E", "2", "3", "2/3 Compaction", "Pre-Calculus", "3/Pre-Calculus"]),
            "mathCalculus": Subject("mathCalculus", SiteSection.math, ("Math", PrefixLocation.none),
                    ["SBCC 150", "AP Calculus AB", "SBCC 160"]),
            "mathOther": Subject("mathOther", SiteSection.math, ("Math", PrefixLocation.none),
                    ["SBCC 117", "AP Statistics", "Trigonometry", "IB Math", "Math Modeling"]),
            "chemistry": Subject("chemistry", SiteSection.science, ("Chemistry", PrefixLocation.after),
                    ["", "Honors", "AP"]),
            "biology": Subject("biology", SiteSection.science, ("Biology", PrefixLocation.none),
                    ["Biology", "AP Biology", "IB Biology", "Medical Biology", "AP Environmental Science"]),
            "physics": Subject("physics", SiteSection.science, ("Physics", PrefixLocation.none),
                    ["Conceptual Physics", "Physics", "AP Physics 1", "AP Physics 2"]),
            "englishLower": Subject("englishLower", SiteSection.english, ("English", PrefixLocation.before),
                    ["Literacy", "Support", "9", "9H", "10", "10H", "11", "12"]),
            "englishUpper": Subject("englishUpper", SiteSection.english, ("English", PrefixLocation.none),
                    ["AP Language", "AP Literature", "IB Year 1", "IB Year 2"]),
            "worldHistory": Subject("worldHistory", SiteSection.history, ("World History", PrefixLocation.after), ["", "AP"]),
            "usHistory": Subject("usHistory", SiteSection.history, ("US History", PrefixLocation.after), ["", "AP"]),
            "french": Subject("french", SiteSection.language, ("French", PrefixLocation.before),
                    ["1", "2", "3", "AP", "IB 1", "IB 2"]),
            "spanish": Subject("spanish", SiteSection.language, ("Spanish", PrefixLocation.before),
                    ["1", "2", "2 Native Speakers", "3", "3 Native Speakers", "AP", "IB 1", "IB 2"]),
        ]
    }
}

enum SiteSection : String, CaseIterable {
    case math, science, english, history, language, other
}

enum ClassRelation : CaseIterable {
    case linear, distinct
}

enum PrefixLocation : CaseIterable {
    case before, after, none
}

enum Grade : Int, CaseIterable {
    case invalid = 0
    case freshman = 9
    case sophomore = 10
    case junior = 11
    case senior = 12
}

struct GroupSession {
    let title: String
    let dayOfWeek: DayOfWeek
    let time: ClockTimeRange
    let pw: String?
    let zoom: String
}
