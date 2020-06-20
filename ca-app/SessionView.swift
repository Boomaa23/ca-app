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
            VStack(alignment: .leading) {
                Text(session.title).bold()
                Text(session.dayOfWeek.rawValue.toCase(String.Case.title))
                Text(session.time.toString(false, true))
                Text("Password: " + (session.pw ?? "No Password"))
                Text(session.zoomUrl).foregroundColor(.blue).onTapGesture {
                    UIApplication.shared.open(URL(string: session.zoomUrl)!)
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
