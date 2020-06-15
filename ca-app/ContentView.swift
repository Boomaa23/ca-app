//
//  ContentView.swift
//  ca-app
//
//  Created by Nikhil on 6/12/20.
//  Copyright © 2020 Charger Academy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text(Parser.getTutors().description)
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                .tag(0)
            Text("TUTORS")
                .font(.title)
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
            Text("GROUP SESSIONS")
                    .font(.title)
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Group Sessions")
                        }
                    }
                    .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
