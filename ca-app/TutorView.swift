//
//  TutorView.swift
//  ca-app
//
//  Created by Nikhil on 6/18/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import SwiftUI

struct TutorView: View {
    static let tutorImgSize: CGFloat = 60
    
    var body: some View {
        NavigationView {
            List(Tutor.allTutors, id: \.self) { tutor in
                NavigationLink(destination: TutorInfoPage(tutor: tutor)) {
                    Image(uiImage: tutor.imageUrl.downloadSquare())
                        .toSquareSize(TutorView.tutorImgSize)
                        .cornerRadius(TutorView.tutorImgSize / 2)
                        .padding(5)
                    VStack(alignment: .leading) {
                        Text(tutor.getFullName())
                        Text(TutorUtils.subjAsCsv(tutor))
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle(Text("Tutors"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TutorView_Previews: PreviewProvider {
    static var previews: some View {
        TutorView()
    }
}

struct TutorInfoPage: View {
    let tutor: Tutor
    private let imgVal: CGFloat = 120
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(uiImage: tutor.imageUrl.downloadSquare("\(imgVal)"))
                    .toSquareSize(imgVal)
                    .cornerRadius(imgVal / 2)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                VStack(alignment: .leading) {
                    Text(tutor.getFullName()).bold()
                    Text(TutorUtils.subjAsCsv(tutor))
                        .foregroundColor(.gray)
                    HStack {
                        Text("Session Signup: ")
                        Text.createLink(tutor.getCalendlyUrl().toNonNil())
                    }
                    HStack {
                        Text("Zoom Link: ")
                        Text.createLink(tutor.getZoomUrl().toNonNil())
                    }
                    SBUnifiedWarning(text: tutor.getZoomUrl().toNonNil())
                }
            }
        }.padding(40)
    }
}

struct SBUnifiedWarning: View {
    let text: String
    
    var body: some View {
        HStack {
            if text.contains("sbunified") {
                Text("WARNING: ").bold()
                Text("SBUnified Zoom account required")
            }
        }
    }
}
