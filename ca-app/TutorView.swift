//
//  TutorView.swift
//  ca-app
//
//  Created by Nikhil on 6/18/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import SwiftUI

struct TutorView: View {
    static let tutors = Parser.getTutors().sorted{$0.self < $1.self}.map{$0.value}
    static let sections = TutorUtils.sortBySection(tutors)
    static let sectionKeys = sections.map{$0.key}
    static let sectionValues = sections.map{$0.value}
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(TutorView.sectionKeys.indices, id: \.self) { section in
                    VStack {
                        Text(TutorView.sectionKeys[section].rawValue)
                        ForEach(TutorView.sectionValues[section].indices) { tutor in
                            Text(TutorView.sectionValues[section][tutor].getFullName())
                        }
                    }
                }
            }
            
        }
    }
}

struct TutorView_Previews: PreviewProvider {
    static var previews: some View {
        TutorView()
    }
}
