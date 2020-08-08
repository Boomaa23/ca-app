//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import SwiftSoup
import UIKit

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
        Tutor.allTutors = [Tutor]()
        let raw: String = RequestHelper.caGet(relUrl: "tutors")
        do {
            let parsed = try SwiftSoup.parse(raw).body()!
            let sections = try parsed.getElementsByAttributeValue("data-ux", "ContentCards")
            for section: Element in sections {
                let cards = try section.getElementsByAttributeValue("data-ux", "ContentCard")
                for card: Element in cards {
                    let nameElem = try card.getElementsByAttributeValue("data-ux", "ContentCardButton").first()
                    let name: String
                    if nameElem != nil {
                        name = String(try nameElem!.attr("href").replacingOccurrences(of: "/", with: ""))
                    } else {
                        continue
                    }
                    
                    let imageElem = try card.getElementsByAttributeValue("data-ux", "ContentCardWrapperImage").first()
                    var imageUrl: WSImgUrl?
                    if imageElem != nil {
                        let tempImgUrl = try imageElem!.getElementsByTag("img").first()!.attr("src")
                        if !tempImgUrl.contains("chargerdotacademywithstroke.png") {
                            imageUrl = WSImgUrl(base: "https:\(tempImgUrl)")
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
        let info = String(String(desc[startIndex...endIndex]).replacingOccurrences(of: ".", with: " ").lowercased())
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
                if info.contains(subject.prefix.value.lowercased()) {
                    let prevCtr = subjRangeRtn.count
                    for level: String in subject.levels.reversed() {
                        if thrAft.lowercased().contains(level.lowercased()) {
                            subjRangeRtn.append(SubjectRange(subject: subject, maxLevel: level))
                            break
                        }
                    }
                    if subjRangeRtn.count == (prevCtr + 1) {
                        sectionRtn = subject.section
                        break
                    }
                }
            }
        } else {
            for subject: Subject in Subject.allClasses.values {
                if info.contains(subject.prefix.value.lowercased()) {
                    sectionRtn = subject.section
                    var applLvl = [String]()
                    for level: String in subject.levels {
                        if info.contains(level.lowercased()) {
                            applLvl.append(level)
                        }
                    }
                    if applLvl.count != 0 {
                        subjRangeRtn.append(SubjectRange(subject: subject, applicableLevels: applLvl))
                    }
                    break;
                }
            }
        }
        if sectionRtn == nil {
             sectionRtn = SiteSection.other
        }
        let otherSubj = Subject.fromOther(info, sectionRtn!)
        if otherSubj != nil {
            subjRangeRtn.append(SubjectRange(subject: otherSubj!, applicableLevels: [""]))
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
                
                let imageElem = try card.getElementsByAttributeValue("data-ux", "ContentCardWrapperImage").first()
                var imageUrl: WSImgUrl?
                if imageElem != nil {
                    let tempImgUrl = try imageElem!.getElementsByTag("img").first()!.attr("src")
                    if !tempImgUrl.contains("chargerdotacademywithstroke.png") {
                        imageUrl = WSImgUrl(base: "https:\(tempImgUrl)")
                    }
                }
                
                if (text.lowercased() != day) {
                    sessions.append(GroupSession(title: title, dayOfWeek: DayOfWeek.fromString(day)!, time: ClockTimeRange.fromString(text)!,
                                                 pw: pw, zoomUrl: href, imageUrl: imageUrl))
                } else if text.contains("every weekday") {
                    for index in 1...5 {
                        sessions.append(GroupSession(title: title, dayOfWeek: DayOfWeek.allCases[index], time: ClockTimeRange.fromString(text)!,
                                                     pw: nil, zoomUrl: href, imageUrl: imageUrl))
                    }
                }
            }
        } catch let error {
            print(error)
        }
        return sessions
    }
}
