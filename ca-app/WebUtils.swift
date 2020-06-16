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
    static func getTutors() -> [String: Tutor] {
        let raw: String = RequestHelper.caGet(relUrl: "tutors")
        var tutors = [String: Tutor]()
        do {
            let parsed = try SwiftSoup.parse(raw).body()!
            let sections = try parsed.getElementsByAttributeValue("data-ux", "ContentCards")
            for section: Element in sections[4...] {
                let cards = try section.getElementsByAttributeValue("data-ux", "ContentCard")
                //TODO temporary fix to get around first few sections
                if cards.count < 4 {
                    continue
                }
                for card: Element in cards[4...] {
                    var name: String = try card.getElementsByTag("h4").text()
                    let nameRange: Range<String.Index>? = name.range(of: ". ")
                    if (nameRange != nil) {
                        name = String(name[..<nameRange!.lowerBound])
                    } else {
                        continue
                    }
                    
                    var text: String = try card.getElementsByTag("span").text()
                    text = String(text[text.firstIndex(of: " ")!...])
                    
                    var grade: Grade = Grade.invalid
                    for grLoop: Grade in Grade.allCases() {
                        if text.lowercased().contains("\(grLoop)") {
                            grade = grLoop
                            break
                        }
                    }
                    
                    let foundClasses = parseDescription(text)
                    if tutors[name] != nil {
                        tutors[name]!.subjects.append(contentsOf: foundClasses.subjRange)
                    } else {
                        let nameSep = name.firstIndex(of: Character(" "))!
                        tutors[name] = Tutor(firstName: String(name[..<nameSep]), lastName: String(name[name.index(after: nameSep)...]),
                                             grade: grade, subjects: foundClasses.subjRange)
                    }
                }
            }
        } catch let error {
            print(error)
        }
        print(tutors)
        return tutors
    }
    
    private static func parseDescription(_ desc: String) -> (section: Section, subjRange: [SubjectRange]) {
        var sectionRtn: Section?
        var subjRangeRtn = [SubjectRange]()
        
        var startIndex = desc.range(of: "with ")?.upperBound ?? desc.startIndex
        let endIndex = desc.range(of: ". Book")!.lowerBound
        if endIndex < startIndex {
            startIndex = desc.startIndex
        }
        var info = String(String(desc[startIndex...endIndex]).replacingOccurrences(of: ".", with: ""))
        for section: Section in Section.allCases {
            let loopSec = "\(section)".lowercased()
            if info.lowercased().contains(loopSec) {
                sectionRtn = section
                break
            }
        }
        if sectionRtn == nil && (info.lowercased().contains("chemistry") || info.lowercased().contains("biology") || info.lowercased().contains("physics")) {
            sectionRtn = Section.science
            info = String(info.replacingOccurrences(of: "/", with: " "))
        }
        if sectionRtn == nil && (info.lowercased().contains("spanish") || info.lowercased().contains("french")) {
            sectionRtn = Section.language
        }
        
        let thrFound = info.range(of: "through ");
        if thrFound != nil {
            let thrAft = String(info[thrFound!.upperBound...])
            for subject: Subject in Subject.getAll().values {
                if sectionRtn == subject.section {
                    for level: String in subject.levels {
                        if thrAft.lowercased().contains(level.lowercased()) {
                            subjRangeRtn.append(SubjectRange(subject: subject, maxLevel: level))
                            break
                        }
                    }
                }
            }
        } else {
            for subject: Subject in Subject.getAll().values {
                if sectionRtn == subject.section {
                    var applLvl = [String]()
                    for level: String in subject.levels {
                        if info.lowercased().contains(level.lowercased()) {
                            applLvl.append(level)
                        }
                    }
                    if applLvl.count != 0 {
                        subjRangeRtn.append(SubjectRange(subject: subject, applicableLevels: applLvl))
                    }
                }
            }
        }
        
        return (sectionRtn!, subjRangeRtn)
    }
}

