//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var showInfo = false
    @State private var showCopyright = false
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
                        Text(String.blank())
                            .font(.system(size: 32))
                        Text(String.blank())
                            .font(.system(size: 32))
                        Button(action: {
                            self.showInfo.toggle()
                        }) {
                            WebButton.create("Info")
                        }
                    }
                    .padding(EdgeInsets(top: scrWidth * pagePadding, leading: 0, bottom: scrWidth * pagePadding, trailing: 0))
                }
                .navigationBarItems(trailing: Button(action: {
                    self.showCopyright.toggle()
                }) {
                    Image(systemName: "ellipsis")
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle(Text(""), displayMode: .inline)
            if showCopyright {
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
                            Text(String.blank())
                                .font(.system(size: 12))
                            Text("Content: Copyright © 2020 Charger Academy. All rights reserved.")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        .padding(EdgeInsets(top: aboutMidPadding, leading: 0, bottom: aboutMidPadding, trailing: 0))
                        Button("Close", action: {
                            self.showCopyright.toggle()
                        })
                    }.padding()
                }
                .frame(width: 470, height: 150, alignment: .center)
                .cornerRadius(15)
            }
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
                            Text("Dos Pueblos High School's Entrepreneurship Club and DPHS Peer Academic Support Services (PASS) have collaborated to offer this tutoring site in order to assist high school students within the Santa Barbara Unified School District who need additional support in core coursework (Math, English, Languages, Sciences, Social Studies) and during the transition to online instruction due to the recent coronavirus pandemic.")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                            Text(String.blank())
                                .font(.system(size: 14))
                            Text("Thank you for supporting Charger.Academy!")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Image("mtcbt-sponsor")
                                    .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 90, alignment: .center)
                        }.padding(EdgeInsets(top: aboutMidPadding, leading: 0, bottom: aboutMidPadding, trailing: 0))
                        Button("Close", action: {
                            self.showInfo.toggle()
                        })
                    }.padding()
                }
                .frame(width: 550, height: 370, alignment: .center)
                .cornerRadius(15)
            }
        }
    }
}
