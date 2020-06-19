//
//  TutorView.swift
//  ca-app
//
//  Created by Nikhil on 6/18/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import SwiftUI

struct TutorView: View {
    @State var sectionState: [Int: Bool] = [:]
    static let tutors = Parser.getTutors().sorted{$0.self < $1.self}.map{$0.value}
    static let sections = TutorUtils.sortBySection(tutors)
    static let sectionKeys = sections.map{$0.key}
    static let sectionValues = sections.map{$0.value}
    
    var body: some View {
        List {
            ForEach(TutorView.sectionKeys.indices, id: \.self) { section in
                Section(header:
                    Text(StringUtils.toCase(TutorView.sectionKeys[section].rawValue, StringCases.title)).onTapGesture {
                    self.sectionState[section] = !self.isExpanded(section)
                }) {
                    if self.isExpanded(section){
                        Text(TutorUtils.csvInSection(TutorView.sectionValues[section], section: TutorView.sectionKeys[section]))
                    }
                }
            }
        }
        .navigationBarTitle("").navigationBarHidden(true)
    }
    
    func isExpanded(_ section:Int) -> Bool {
        sectionState[section] ?? false
    }
}

struct TutorView_Previews: PreviewProvider {
    static var previews: some View {
        TutorView()
    }
}
