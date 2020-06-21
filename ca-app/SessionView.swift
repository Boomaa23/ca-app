//
//  SessionView.swift
//  ca-app
//
//  Created by Nikhil on 6/20/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import SwiftUI

struct SessionView: View {
    var body: some View {
        List(GroupSession.allSessions, id: \.self) { session in
            HStack {
                Image(uiImage: session.imageUrl.downloadSquare())
                    .toSquareSize(TutorView.tutorImgSize)
                    .cornerRadius(TutorView.tutorImgSize / 2)
                    .padding(10)
                VStack(alignment: .leading) {
                    Text(session.title).bold()
                    Text(session.dayOfWeek.rawValue.toCase(String.Case.title))
                    Text(session.time.toString(false, true))
                    Text("Password: " + (session.pw ?? "None"))
                    HStack {
                        Text("Zoom Link: ")
                        Text.createLink(session.zoomUrl)
                    }
                    SBUnifiedWarning(text: session.zoomUrl)
                }
            }
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
