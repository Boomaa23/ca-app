//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation
import UIKit
import SwiftSoup
import SwiftUI

class Tutor : Comparable, Hashable {
    static var allTutors = [Tutor]()
    let firstName: String
    let lastName: String
    let grade: Grade
    var subjects: [SubjectRange]
    var imageUrl: WSImgUrl
    private var num: Int?
    private var zoomUrl: String?
    
    
    init(firstName: String, lastName: String, grade: Grade, subjects: [SubjectRange], imageUrl: WSImgUrl?) {
        self.firstName = firstName.replacingOccurrences(of: " ", with: "").lowercased()
        self.lastName = lastName.replacingOccurrences(of: " ", with: "").lowercased()
        self.grade = grade
        self.subjects = subjects
        self.imageUrl = imageUrl ?? WSImgUrl(base: nil)
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
        if self.zoomUrl != nil {
            return self.zoomUrl
        }
        if self.num == nil && self.getNum() == nil {
            return nil
        }
        do {
            let meta = try SwiftSoup.parse(RequestHelper.get(url: getCalendlyUrl().toNonNil())).getElementsByTag("meta")
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
    
    func getCalendlyUrl() -> String? {
        if num == nil {
            _ = getNum()
        }
        if num == nil {
            return nil
        }
        return "https://calendly.com/dphstutor\(num!)/\(firstName)\(lastName[lastName.startIndex])"
    }
    
    func getFullName() -> String {
        return firstName.toCase(String.Case.title) + " " + lastName.toCase(String.Case.title)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(grade)
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
    let prefix: Prefix
    let levels: [String]
    
    init(_ baseName: String,_ section: SiteSection,_ prefix: Prefix,_ levels: [String]) {
        self.baseName = baseName
        self.section = section
        self.prefix = prefix
        self.levels = levels
        Subject.allClasses[baseName] = self
    }
    
    func withPrefix(_ level: String) -> String {
        switch prefix.loc {
            case .after:
                return "\(level) \(prefix.value)".capsAP()
            case .before:
                return "\(prefix.value) \(level)".capsAP()
            case .none:
                return level.capsAP()
        }
    }
    
    static func fromOther(_ keyText: String,_ section: SiteSection = SiteSection.other) -> Subject? {
        let possibleOthers = ["writing", "tech", "time management", "german", "latin", "art", "ap computer science", "ap environmental science"]
        for other: String in possibleOthers {
            if keyText.contains(other) {
                return Subject(other, section, Prefix(other.toCase(String.Case.title).capsAP(), PrefixLocation.before, PrefixCompaction.none), [""])
            }
        }
        return nil
    }
}

enum SiteSection: String, CaseIterable, Comparable {
    case math, science, english, history, language, other
    
    // Sort by index of SiteSection instead of alphabetically
    static func < (lhs: SiteSection, rhs: SiteSection) -> Bool {
        let lhsIndex: Int = SiteSection.allCases.firstIndex(of: lhs)!
        let rhsIndex: Int = SiteSection.allCases.firstIndex(of: rhs)!
        return lhsIndex < rhsIndex
    }
}

struct Prefix {
    let value: String
    let loc: PrefixLocation
    let compaction: PrefixCompaction
    
    init(_ value: String,_ loc: PrefixLocation,_ compaction: PrefixCompaction) {
        self.value = value
        self.loc = loc
        self.compaction = compaction
    }
}

enum PrefixLocation: CaseIterable {
    case before, after, none
}

enum PrefixCompaction: String, CaseIterable {
    case all, allButOne, none
}

enum Grade: Int, CaseIterable {    
    case invalid = 0
    case freshman = 9
    case sophomore = 10
    case junior = 11
    case senior = 12
}

struct GroupSession: Hashable {
    static var allSessions = [GroupSession]()
    let title: String
    let dayOfWeek: DayOfWeek
    let time: ClockTimeRange
    let pw: String?
    let zoomUrl: String
    var imageUrl: WSImgUrl
    
    init(title: String, dayOfWeek: DayOfWeek, time: ClockTimeRange, pw: String?, zoomUrl: String, imageUrl: WSImgUrl?) {
        self.title = title
        self.dayOfWeek = dayOfWeek
        self.time = time
        self.pw = pw
        self.zoomUrl = zoomUrl
        self.imageUrl = imageUrl ?? WSImgUrl(base: nil)
        GroupSession.allSessions.append(self)
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

class WSImgUrl {
    static let siteDefaultSize = (width: "365", height: "365")
    let base: String?
    private var storedImg: UIImage?
    
    init(base: String?, resizeSingle: Bool = true) {
        self.base = base
        if resizeSingle {
            self.storedImg = download(WSImgUrl.siteDefaultSize.width, WSImgUrl.siteDefaultSize.height)
        }
    }
    
    func toSized(_ width: String,_ height: String) -> String? {
        return self.base?
            .replacingOccurrences(of: "w:\(WSImgUrl.siteDefaultSize.width)", with: "w:\(width)")
            .replacingOccurrences(of: "h:\(WSImgUrl.siteDefaultSize.height)", with: "h:\(height)")
    }
    
    func download(_ width: String,_ height: String) -> UIImage {
        if self.storedImg != nil {
            return self.storedImg!
        }
        if self.base != nil, let sizedUrl = toSized(width, height) {
            let data = try? Data(contentsOf: URL(string: sizedUrl)!)
            if let imageData = data {
                self.storedImg = UIImage(data: imageData)!
                return self.storedImg!
            }
        }
        return (UIImage(named: "logo") ?? UIImage(systemName: "person.fill"))!
    }
    
    func downloadSquare(_ dimension: String = "\(TutorView.tutorImgSize)") -> UIImage {
        return download(dimension, dimension)
    }
}
