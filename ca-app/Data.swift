//
//  Data.swift
//  ca-app
//
//  Created by Nikhil on 6/14/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class Tutor : Comparable, Hashable {
    static var allTutors = [Tutor]()
    let firstName: String
    let lastName: String
    let grade: Grade
    var subjects: [SubjectRange]
    var imageUrl: String?
    private var num: Int?
    private var zoomUrl: String?
    
    
    init(firstName: String, lastName: String, grade: Grade, subjects: [SubjectRange], imageUrl: String?) {
        self.firstName = firstName.replacingOccurrences(of: " ", with: "").lowercased()
        self.lastName = lastName.replacingOccurrences(of: " ", with: "").lowercased()
        self.grade = grade
        self.subjects = subjects
        self.imageUrl = imageUrl
        Tutor.allTutors.append(self)
    }
    
    func getNum() -> Int? {
        if self.num != nil {
            return self.num
        }
        do {
            let iframes = try SwiftSoup.parse(RequestHelper.caGet(relUrl: getRelUrl())).getElementsByTag("iframe")
            for frame in iframes {
                let attrText = try frame.attr("srcdoc")
                let calName = "\(firstName)\(lastName[lastName.startIndex])"
                if attrText.range(of: calName) != nil {
                    let upper = attrText.index(before: attrText.index(before: attrText.range(of: calName)!.lowerBound))
                    let lower = attrText.range(of: "dphstutor")!.upperBound
                    self.num = Int(String(attrText[lower...upper]))!
                    return self.num
                }
            }
        } catch let error {
            print(error)
        }
        return nil
    }
    
    func getZoomUrl() -> String? {
        if self.num == nil {
            return nil
        }
        if self.zoomUrl != nil {
            return self.zoomUrl
        }
        do {
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
        return firstName + "-" + lastName
    }
    
    func getCalendlyUrl() -> String {
        return "https://calendly.com/dphstutor\(num!)/\(firstName)\(lastName[lastName.startIndex])"
    }
    
    func getFullName() -> String {
        return firstName.toCase(String.Case.title) + " " + lastName.toCase(String.Case.title)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(num)
        hasher.combine(firstName)
        hasher.combine(lastName)
    }
    
    static func indexByName(_ name: String) -> Int? {
        for (index, tutor) in allTutors.enumerated() {
            if tutor.getRelUrl() == name {
                return index
            }
        }
        return nil
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
    static var allClasses: [String: Subject] = [:]
    let baseName: String
    let section: SiteSection
    let prefix: (value: String, loc: PrefixLocation)
    let levels: [String]
    
    init(_ baseName: String,_ section: SiteSection,_ prefix: (value: String, loc: PrefixLocation),_ levels: [String]) {
        self.baseName = baseName
        self.section = section
        self.prefix = prefix
        self.levels = levels
        Subject.allClasses[baseName] = self
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
        let possibleOthers = ["writing", "tech", "time management", "german", "latin", "art", "english"]
        for other: String in possibleOthers {
            if keyText.contains(other) {
                return Subject(other, SiteSection.other, (other.toCase(String.Case.title), PrefixLocation.before), [""])
            }
        }
        return nil
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

struct GroupSession : Hashable {
    static var allSessions = [GroupSession]()
    let title: String
    let dayOfWeek: DayOfWeek
    let time: ClockTimeRange
    let pw: String?
    let zoomUrl: String
    var imageUrl: String?
    
    init(title: String, dayOfWeek: DayOfWeek, time: ClockTimeRange, pw: String?, zoomUrl: String, imageUrl: String?) {
        self.title = title
        self.dayOfWeek = dayOfWeek
        self.time = time
        self.pw = pw
        self.zoomUrl = zoomUrl
        self.imageUrl = imageUrl
        GroupSession.allSessions.append(self)
    }
    
    //TODO implement
    func zoomHref() -> NSMutableAttributedString {
        let href = NSMutableAttributedString(string: self.zoomUrl)
        href.addAttribute(.link, value: self.zoomUrl, range: NSString(string: self.zoomUrl).range(of: self.zoomUrl))
        return href
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(dayOfWeek)
    }
    
    static func == (lhs: GroupSession, rhs: GroupSession) -> Bool {
        return lhs.title == rhs.title
            && lhs.dayOfWeek == rhs.dayOfWeek
            && lhs.time == rhs.time
    }
}
