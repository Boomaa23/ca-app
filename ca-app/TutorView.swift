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
    static let tutorImgSize: CGFloat = 60
    
    var body: some View {
        List(Tutor.allTutors, id: \.self) { tutor in
            Image(uiImage: tutor.getImage())
                .resizable().frame(width: TutorView.tutorImgSize, height: TutorView.tutorImgSize, alignment: .center).cornerRadius(TutorView.tutorImgSize / 2).padding(5)
            VStack(alignment: .leading) {
                Text(tutor.getFullName())
                Text(TutorUtils.subjAsCsv(tutor))
                    .foregroundColor(.gray)
            }
        }
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
