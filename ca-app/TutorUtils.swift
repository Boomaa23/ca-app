//
//  TutorUtils.swift
//  ca-app
//
//  Created by Nikhil on 6/18/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import Foundation

class TutorUtils {
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
