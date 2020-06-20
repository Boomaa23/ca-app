//
// Created by Nikhil on 6/12/20.
// Copyright (c) 2020 Charger Academy. All rights reserved.
//

import Foundation
import SwiftSoup

class RequestHelper {
    static func caGet(relUrl: String) -> String {
        get(url: "https://charger.academy/\(relUrl)/")
    }

    static func get(url: String) -> String {
        do {
            return try String(contentsOf: URL(string: url)!)
        } catch let error {
            print(error)
        }
        return String()
    }
}

class Parser {
    static func initTutors() -> [Tutor] {
        if Tutor.allTutors.count != 0 {
            return Tutor.allTutors
        }
        let raw: String = RequestHelper.caGet(relUrl: "tutors")
        do {
            let parsed = try SwiftSoup.parse(raw).body()!
            let sections = try parsed.getElementsByAttributeValue("data-ux", "ContentCards")
            for section: Element in sections {
                let cards = try section.getElementsByAttributeValue("data-ux", "ContentCard")
                //TODO temporary fix to get around first few sections
                if cards.count < 4 {
                    continue
                }
                for card: Element in cards {
                    let nameElem = try card.getElementsByAttributeValue("data-ux", "ContentCardButton").first()
                    let name: String
                    if nameElem != nil {
                        name = String(try nameElem!.attr("href").replacingOccurrences(of: "/", with: ""))
                    } else {
                        continue
                    }
                    
                    let imageElem = try card.getElementsByAttributeValue("data-ux", "ContentCardWrapperImage").first()
                    var imageUrl: String?
                    if imageElem != nil {
                        let tempImgUrl = try imageElem!.getElementsByTag("img").first()!.attr("src")
                        if !tempImgUrl.contains("chargerdotacademywithstroke.png") {
                            imageUrl = "https:\(tempImgUrl)"
                                .replacingOccurrences(of: "w:365", with: "w:\(TutorView.tutorImgSize)")
                                .replacingOccurrences(of: "h:365", with: "h:\(TutorView.tutorImgSize)")
                        }
                    }
                    
                    var text: String = try card.getElementsByTag("span").text()
                    text = String(text[text.firstIndex(of: " ")!...])
                    
                    var grade: Grade = Grade.invalid
                    for grLoop: Grade in Grade.allCases {
                        if text.lowercased().contains("\(grLoop)") {
                            grade = grLoop
                            break
                        }
                    }
                    
                    let foundClasses = parseDescription(text)
                    let ioName = Tutor.indexByName(name)
                    if ioName != nil {
                        Tutor.allTutors[ioName!].subjects.append(contentsOf: foundClasses.subjRange)
                    } else {
                        let nameSep = name.firstIndex(of: Character("-"))!
                        _ = Tutor(firstName: String(name[..<nameSep]), lastName: String(name[name.index(after: nameSep)...]),
                              grade: grade, subjects: foundClasses.subjRange, imageUrl: imageUrl)
                    }
                }
            }
        } catch let error {
            //TODO handle errored connections/refresh ability
            if error.localizedDescription.contains("failed to connect") {
                return initTutors()
            } else {
                print(error)
            }
        }
        return Tutor.allTutors
    }
    
    private static func parseDescription(_ desc: String) -> (section: SiteSection, subjRange: [SubjectRange]) {
        var sectionRtn: SiteSection?
        var subjRangeRtn = [SubjectRange]()
        
        var startIndex = desc.range(of: "with ")?.upperBound ?? desc.startIndex
        let endIndex = desc.range(of: ". Book")!.lowerBound
        if endIndex < startIndex {
            startIndex = desc.startIndex
        }
        var info = String(String(desc[startIndex...endIndex]).replacingOccurrences(of: ".", with: " ").lowercased())
        for section: SiteSection in SiteSection.allCases {
            let loopSec = "\(section)"
            if info.contains(loopSec) {
                sectionRtn = section
                break
            }
        }
        
        let thrFound = info.range(of: "through ");
        if thrFound != nil {
            let thrAft = String(info[thrFound!.upperBound...])
            for subject: Subject in Subject.allClasses.values {
                if sectionRtn == nil {
                    if info.contains(subject.baseName) {
                        sectionRtn = subject.section
                    } else {
                        continue
                    }
                }
                if sectionRtn == subject.section {
                    if sectionRtn == SiteSection.science {
                        info = info.replacingOccurrences(of: "/", with: " ")
                    }
                    for level: String in subject.levels {
                        if thrAft.lowercased().contains(level.lowercased()) {
                            if level.count == 1 && thrAft.endIndex != thrAft.firstIndex(of: Character(level)) {
                                let aftChar = thrAft[thrAft.index(thrAft.firstIndex(of: Character(level))!, offsetBy: 1)]
                                if aftChar != Character(" ") && aftChar != Character(",") && aftChar != Character(".") {
                                    continue
                                }
                            }
                            //TODO figure out a parsing system that avoids level conflicts like this
                            if thrAft == "3/pre-calculus " && level == "Pre-Calculus" {
                                continue
                            }
                            subjRangeRtn.append(SubjectRange(subject: subject, maxLevel: level))
                            break
                        }
                    }
                }
            }
        } else {
            for subject: Subject in Subject.allClasses.values {
                if sectionRtn == nil {
                    if info.contains(subject.baseName) {
                        sectionRtn = subject.section
                    } else {
                        continue
                    }
                } else if sectionRtn == subject.section {
                    var applLvl = [String]()
                    for level: String in subject.levels {
                        if info.contains(level.lowercased()) {
                            applLvl.append(level)
                        }
                    }
                    if applLvl.count != 0 {
                        subjRangeRtn.append(SubjectRange(subject: subject, applicableLevels: applLvl))
                    }
                }
            }
        }
        
        if sectionRtn == nil {
            return (SiteSection.other, [SubjectRange(subject: Subject.fromOther(info)!, applicableLevels: [""])])
        }
        return (sectionRtn!, subjRangeRtn)
    }
    
    static func initGroupSessions() -> [GroupSession] {
        if GroupSession.allSessions.count != 0 {
            return GroupSession.allSessions
        }
        var sessions = [GroupSession]()
        let pageText = RequestHelper.caGet(relUrl: "group-tutoring")
        do {
            let parsed = try SwiftSoup.parse(pageText)
            let cards = try parsed.getElementsByAttributeValue("data-ux", "ContentCard")
            for card: Element in cards {
                var title = try card.getElementsByAttributeValue("data-ux", "ContentCardHeading").first()!.text()
                let titleAtIndex = title.range(of: " at ")
                if titleAtIndex != nil {
                    title = String(title[..<title.index(after: titleAtIndex!.lowerBound)])
                }
                let text = try card.getElementsByAttributeValue("data-ux", "ContentCardText").first()!.text()
                let day = try card.getElementsByTag("strong").first()!.text().lowercased()
                let pw = String(text[text.index(after: text.lastIndex(of: Character(" "))!)...])
                let href = try card.getElementsByAttributeValue("data-ux", "ContentCardButton").first()!.attr("href")
                if (text.lowercased() != day) {
                    sessions.append(GroupSession(title: title, dayOfWeek: DayOfWeek.fromString(day)!, time: ClockTimeRange.fromString(text)!, pw: pw, zoomUrl: href))
                } else if text.contains("every weekday") {
                    for index in 1...5 {
                        sessions.append(GroupSession(title: title, dayOfWeek: DayOfWeek.allCases[index], time: ClockTimeRange.fromString(text)!, pw: nil, zoomUrl: href))
                    }
                }
            }
        } catch let error {
            print(error)
        }
        return sessions
    }
}
