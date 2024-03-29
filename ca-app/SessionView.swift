//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import SwiftUI

struct SessionView: View {
    var body: some View {
        NavigationView {
            List(GroupSession.allSessions, id: \.self) { session in
                HStack {
                    Image(uiImage: session.imageUrl.downloadSquare())
                        .toSquareSize(TutorView.tutorImgSize)
                        .cornerRadius(TutorView.tutorImgSize / 2)
                        .padding(10)
                    VStack(alignment: .leading) {
                        Text(session.title).bold()
                        Text("\(self.listDays(session.daysOfWeek)) \(session.time.toString(false, true, true))")
                        Text("Password: " + (session.pw ?? "None"))
                        HStack {
                            Text(UIDevice.current.userInterfaceIdiom == .pad ? "Zoom Link: " : "Zoom \n Link:")
                            Text.createLink(session.zoomUrl)
                        }
                        SBUnifiedWarning(text: session.zoomUrl)
                    }
                }
            }
            .navigationBarTitle(Text("Group Sessions"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func listDays(_ days: [DayOfWeek]) -> String {
        var out = String()
        for (index, day) in days.enumerated() {
            out += day.rawValue.toCase(String.Case.title)
            if index != days.count - 1 {
                out += ", "
            }
        }
        return out
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
