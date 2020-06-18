//
//  TutorView2.swift
//  ca-app
//
//  Created by Nikhil on 6/18/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import SwiftUI

struct TutorView: View {
    let tutors = Parser.getTutors().map{$0.value}
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(tutors.indices) { tutor in
                    Text(self.tutors[tutor].getFullName())
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
