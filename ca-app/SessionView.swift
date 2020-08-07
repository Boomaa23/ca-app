//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

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
