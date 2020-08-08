//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation

class TutorUtils {
    static func subjAsCsv(_ tutor: Tutor) -> String {
        var outStr: String = ""
        for (index, subjectRange) in tutor.subjects.enumerated() {
            if subjectRange.subject.prefix.loc != PrefixLocation.none {
                outStr += "\(subjectRange.subject.prefix.value) "
            }
            for (levelIndex, level) in subjectRange.applicableLevels.enumerated() {
                outStr += level + (subjectRange.applicableLevels.count - 1 != levelIndex ? ", " : "")
            }
            outStr += (tutor.subjects.count - 1 != index ? "\n" : "")
        }
        return outStr
    }
    
    static func sectAsCsv(_ tutor: Tutor) -> String {
        var sectSubjMap = [SiteSection: [SubjectRange]]()
        for section in SiteSection.allCases {
            for subjectRange in tutor.subjects {
                if (subjectRange.subject.section == section) {
                    if sectSubjMap[section] == nil {
                        sectSubjMap[section] = [SubjectRange]()
                    }
                    sectSubjMap[section]!.append(subjectRange)
                }
            }
        }
        var outStr: String = ""
        for (index, section) in sectSubjMap.keys.sorted().enumerated() {
            outStr += "\(section.rawValue.toCase(String.Case.title)): "
            let ranges = sectSubjMap[section]!
            var hasFirstEntry = false
            for range in ranges {
                for (index, level) in range.applicableLevels.enumerated() {
                    var lvl = ""
                    switch range.subject.prefix.compaction {
                        case .allButOne:
                            if index == 0 {
                                lvl = range.subject.withPrefix(level)
                            } else {
                                lvl = level
                            }
                            break
                        case .all:
                            lvl = level
                            break
                        case .none:
                            lvl = range.subject.withPrefix(level)
                            break
                    }
                    lvl = lvl.trimmingCharacters(in: .whitespacesAndNewlines)
                    outStr += (hasFirstEntry ? ", \(lvl)" : lvl)
                    hasFirstEntry = true
                }
            }
            if index != (sectSubjMap.count - 1) {
                outStr += "\n"
            }
        }
        
        return outStr
    }
    
    static func csvInSection(_ tutors: [Tutor], section: SiteSection) -> String {
        var out: String = ""
        for tutor: Tutor in tutors {
            for (index, subjectRange) in tutor.subjects.enumerated() {
                if subjectRange.subject.section == section {
                    for level: String in subjectRange.applicableLevels {
                        out += subjectRange.subject.withPrefix(level)
                        if index != tutor.subjects.count - 1 {
                            out += ", "
                        }
                    }
                }
            }
        }
        return out
    }
    
    static func sortBySection(_ tutors: [Tutor]) -> [SiteSection: [Tutor]] {
        var out = [SiteSection: [Tutor]]()
        for tutor: Tutor in tutors {
            for subjectRange in tutor.subjects {
                let index = subjectRange.subject.section
                if out[index] == nil {
                    out[index] = []
                } else {
                    out[index]!.append(tutor)
                }
            }
        }
        return out
    }
}
