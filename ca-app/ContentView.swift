//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    let scrWidth = UIScreen.main.bounds.width
 
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            TutorView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Tutors")
                    }
                }
                .tag(1)
            Text("SESSIONS")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "plus")
                            Text("Sessions")
                        }
                    }
                    .tag(2)
            SessionView()
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Group Sessions")
                        }
                    }
                    .tag(3)
            TutorResourcesView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "doc.on.doc.fill")
                        Text("Tutor Resources")
                    }
                }
                .tag(4)
            Text("FEEDBACK")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "ant.fill")
                        Text("Feedback")
                    }
                }
                .tag(5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
