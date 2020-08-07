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
                        Text(TutorUtils.sectAsCsv(tutor))
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
                    HStack {
                        Text("Grade:")
                        Text("\(tutor.grade.rawValue)")
                        Text(String("(" + "\(tutor.grade)".toCase(String.Case.title) + ")"))
                    }
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

struct TutorResourcesView: View {
    var body: some View {
        VStack {
            Text("Tutor Resources")
            HStack {
                VStack {
                    Text("Tutoring Guide")
                        .bold()
                    Text("In this document, you will be able to find a basic guide for tutoring, and the links to give to the tutee, a link to log your hours, and a session red flag form.")
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/11q2_DxQ0ZtA9C1SjqNrBpew9eBjVcC3dmUmeYiWexlk/edit?usp=sharing")!)
                    }) {
                        Text("Access Here")
                    }
                }
                VStack {
                    Text("Session Log")
                        .bold()
                    Text("Use this link to log your hours after each session. Make sure to ask the tutee who their teacher is and include a brief description of what you did during the session.")
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://tinyurl.com/OnlineTutoringSessionLog")!)
                    }) {
                        Text("Access Here")
                    }
                }
            }
            HStack {
                VStack {
                    Text("Feedback Form")
                        .bold()
                    Text("At the end of your session, please give this link to the tutee requesting if they could please fill out this general feedback form.")
                        .font(.body)
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://tinyurl.com/OnlineTutoringFeedback")!)
                    }) {
                        Text("Access Here")
                    }
                }
                VStack {
                    Text("Red Flag Form")
                        .bold()
                    Text("If during your session something made you feel uncomfortable and that merits the attention of an adult, please fill out this form immediately.")
                        .font(.body)
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://tinyurl.com/OnlineTutoringRedFlag")!)
                    }) {
                        Text("Access Here")
                    }
                }
            }
        .padding(30)
        }
    }
}

struct TutorResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        TutorResourcesView()
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
