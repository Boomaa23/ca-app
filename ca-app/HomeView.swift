//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var showInfo = false
    private let scrWidth: CGFloat = UIScreen.main.bounds.width
    private let scrHeight: CGFloat = UIScreen.main.bounds.height
    private let logoPadding: CGFloat = 0.3
    private let pagePadding: CGFloat = 0.18
    private let aboutMidPadding: CGFloat = 10
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    VStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: ContentMode.fit)
                            .padding(EdgeInsets(top: 0, leading: scrWidth * logoPadding, bottom: 0, trailing: scrWidth * logoPadding))
                        Text("Charger Academy").font(.largeTitle)
                        Text("DPHS Online Tutoring").font(.headline)
                    }
                    .padding(EdgeInsets(top: scrWidth * pagePadding, leading: 0, bottom: scrWidth * pagePadding, trailing: 0))
                }
                .navigationBarItems(trailing: Button(action: {
                    self.showInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle(Text(""), displayMode: .inline)
            if showInfo {
                ZStack {
                    Color.gray
                }.opacity(0.5)
                ZStack {
                    Color.white
                    VStack(alignment: .center) {
                        Text("Charger Academy iOS App")
                            .font(.headline)
                        VStack {
                            Text("Code: Copyright © 2020 Nikhil Ograin. All rights reserved.")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Text("Content: Copyright © 2020 Charger Academy. All rights reserved.")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Text("")
                                .font(.system(size: 12))
                            Text("Charger Academy is a 501(c)(3) nonprofit tutoring service formed through the partnership of Dos Pueblos High School's Entrepreneurship Club and DPHS Peer Academic Support Services (PASS). The goal of Charger Academy is to assist high school students within the Santa Barbara Unified School District who need additional support in core coursework (Math, English, Languages, Sciences, and Social Studies) during the transition to online instruction due to the coronavirus pandemic.")
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                        .padding(EdgeInsets(top: aboutMidPadding, leading: 0, bottom: aboutMidPadding, trailing: 0))
                        Button("Close", action: {
                            self.showInfo.toggle()
                        })
                    }.padding()
                }
                .frame(width: 460, height: 250, alignment: .center)
                .cornerRadius(15)
            }
        }
    }
}
	
