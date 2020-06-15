//
//  Data.swift
//  ca-app
//
//  Created by Nikhil on 6/14/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import Foundation

struct Tutor {
    let firstName: String
    let lastName: String
    let subjects: [SubjectRange]
    let href: String?
    
    func getRelUrl() -> String {
        return href ?? (firstName.lowercased() + "_" + lastName.lowercased())
    }
    
    func getFullName() -> String {
        return firstName + " " + lastName
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
    let section: Section
    let relation: ClassRelation
    let prefixName: Bool
    let levels: [String]
    
    init(_ baseName: String,_ section: Section,_ relation: ClassRelation,_ prefixName: Bool,_ levels: [String]) {
        self.baseName = baseName
        self.section = section
        self.relation = relation
        self.prefixName = prefixName
        self.levels = levels
    }
    
    static func getAll() -> [String: Subject] {
        return [
            "tech": Subject("tech", Section.tech, ClassRelation.distinct, false, []),
            "mathCommon": Subject("mathCommon", Section.math, ClassRelation.linear, true,
                    ["1 Support", "1", "1 Enrichment", "2 Support", "2 Enrichment", "2", "3", "2/3 Compaction", "Pre-Calculus", "3/Pre-Calculus"]),
            "mathCalculus": Subject("mathCalculus", Section.math, ClassRelation.linear, false,
                    ["SBCC 150", "AP Calculus AB", "SBCC 160"]),
            "mathOther": Subject("mathOther", Section.math, ClassRelation.distinct, false,
                    ["SBCC 117", "AP Statistics", "Trigonometry", "IB Math", "Math Modeling"]),
            "chemistry": Subject("chemistry", Section.science, ClassRelation.linear, false,
                    ["Chemistry", "Honors Chemistry", "AP Chemistry"]),
            "biology": Subject("biology", Section.science, ClassRelation.distinct, false,
                    ["Biology", "AP Biology", "IB Biology", "Medical Biology", "AP Environmental Science"]),
            "physics": Subject("physics", Section.science, ClassRelation.linear, false,
                    ["Conceptual Physics", "Physics", "AP Physics 1", "AP Physics 2"]),
            "english": Subject("english", Section.english, ClassRelation.linear, true,
                    ["Support", "Literacy", "9", "9 Honors", "10", "10 Honors", "11", "12", "AP Language", "AP Literature", "IB Lit"]),
            "worldHistory": Subject("worldHistory", Section.history, ClassRelation.linear, true, ["", "AP"]),
            "usHistory": Subject("usHistory", Section.history, ClassRelation.linear, true, ["", "AP"]),
            "spanish": Subject("french", Section.language, ClassRelation.linear, true,
                    ["1", "2", "3", "AP", "IB 1", "IB 2"]),
            "french": Subject("spanish", Section.language, ClassRelation.linear, true,
                    ["1", "2", "2 Native Speakers", "3", "3 Native Speakers", "AP", "IB 1", "IB 2"]),
        ]
    }
}

enum Section : CaseIterable {
    case tech, math, science, english, history, language, other
}

enum ClassRelation : CaseIterable {
    case linear, distinct
}

enum Grade : Int {
    case freshman = 9
    case sophomore = 10
    case junior = 11
    case senior = 12
}
