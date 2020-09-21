//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import SwiftUI

struct TutorView: View {
    static let tutorImgSize: CGFloat = 60
    @State var pushTutors: [Tutor] = Parser.initTutors()
    @State var showFilter: Bool = false
    let popoverPad: CGFloat = 10
    
    var body: some View {
        NavigationView {
            List(self.pushTutors, id: \.self) { tutor in
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
            .navigationBarItems(leading: HStack {
                VStack {
                    Text("Filter")
                        .font(.system(size: 12))
                        .padding(.bottom, 0)
                        .foregroundColor(.gray)
                    Button(action: {
                        self.showFilter.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }.popover(isPresented: self.$showFilter, arrowEdge: .top, content: {
                        ScrollView(.vertical) {
                            VStack(alignment: .leading, spacing: self.popoverPad, content: {
                                ForEach(Array(Subject.allClasses.values), id: \.self) { subject in
                                    ForEach(subject.levels, id: \.self) { level in
                                        CheckboxLabel(label: subject.withPrefix(level), tutorView: self)
                                    }
                                }
                            })
                            .padding(EdgeInsets(top: self.popoverPad, leading: self.popoverPad,
                                                bottom: self.popoverPad, trailing: self.popoverPad))
                        }
                        .frame(width: 200, height: 350, alignment: .leading)
                    })
                }
                VStack {
                    Text("Select")
                        .font(.system(size: 12))
                        .padding(.bottom, 0)
                        .foregroundColor(.gray)
                    Button(action: {
                        if (self.pushTutors.count < Tutor.allTutors.count) {
                            self.populateCheckMap(true)
                            self.pushTutors.removeAll()
                            self.pushTutors.append(contentsOf: Tutor.allTutors)
                        } else {
                            self.populateCheckMap(false)
                            self.pushTutors.removeAll()
                        }
                    }) {
                        Image(systemName: self.pushTutors.count == 0 ? "square" :
                            self.pushTutors.count == Tutor.allTutors.count ? "checkmark.square" : "square.fill")
                    }
                }
            }, trailing: Button(action: {
                self.pushTutors.removeAll()
                self.pushTutors.append(contentsOf: Parser.initTutors())
                self.populateCheckMap(true)
            }) {
                Image(systemName: "arrow.clockwise")
            })
            .navigationBarTitle(Text("Tutors"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func populateCheckMap(_ value: Bool) {
        if CheckboxLabel.checkMap.count == 0 {
            for subject: Subject in Subject.allClasses.values {
                for level: String in subject.levels {
                    CheckboxLabel.checkMap[subject.withPrefix(level)] = value
                }
            }
        } else {
            for i: String in CheckboxLabel.checkMap.keys {
                CheckboxLabel.checkMap[i] = value
            }
        }
    }
}

struct TutorView_Previews: PreviewProvider {
    static var previews: some View {
        TutorView()
    }
}

struct CheckboxLabel: View {
    static var checkMap = [String: Bool]()
    @State var isMarked: Bool
    let size: CGFloat = 15
    let label: String
    let tutorView: TutorView
    
    init(label: String, tutorView: TutorView) {
        self.label = label
        self.tutorView = tutorView
        if CheckboxLabel.checkMap[label] == nil {
            CheckboxLabel.checkMap[label] = true
        }
        _isMarked = State(initialValue: CheckboxLabel.checkMap[label]!);
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.isMarked.toggle()
                CheckboxLabel.checkMap[self.label] = self.isMarked
                self.refreshMatching()
            }) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
            }
            Text(self.label)
                .font(Font.system(size: self.size))
        }
    }
    
    func refreshMatching() {
        self.tutorView.pushTutors.removeAll()
        for tutor: Tutor in Tutor.allTutors {
            for subjectRange: SubjectRange in tutor.subjects {
                for level: String in subjectRange.applicableLevels {
                    if CheckboxLabel.checkMap[subjectRange.subject.withPrefix(level)]! {
                        self.tutorView.pushTutors.append(tutor)
                        break
                    }
                }
                if self.tutorView.pushTutors.contains(tutor) {
                    break
                }
            }
        }
    }
}

struct TutorInfoPage: View {
    @State private var showPullup: Bool = false
    let tutor: Tutor
    private let imgVal: CGFloat = 120
    
    var body: some View {
        VStack {
            if UIDevice.current.userInterfaceIdiom == .pad {
                HStack(alignment: .top) {
                    getImage()
                        .padding(.trailing, 20)
                    getClassStack()
                }
            } else {
                VStack {
                    getImage()
                        .padding(.bottom, 20)
                    getClassStack()
                }
            }
            HStack {
                Button(action: {
                    UIApplication.shared.open(URL(string: self.tutor.getCalendlyUrl().toNonNil(String.blank()))!)
                }) {
                    Image(systemName: "plus")
                    Text("Request Session")
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 40))
                Button(action: {
                    self.showPullup.toggle()
                }) {
                    Image(systemName: "envelope")
                    Text("Contact Tutor")
                }
                .sheet(isPresented: $showPullup, content: {
                    MailView(to: [self.tutor.getEmail().toNonNil(String.blank())], body: "BLAH BLAH BLAH<br>BLAH BLAH", subject: "")
                })
                .cornerRadius(12)
                .foregroundColor(.blue)
            }
            .padding(EdgeInsets(top: 25, leading: 0, bottom: 0, trailing: 0))
        }.padding(40)
    }
    
    func getImage() -> some View {
        return Image(uiImage: tutor.imageUrl.downloadSquare("\(imgVal)"))
            .toSquareSize(imgVal)
            .cornerRadius(imgVal / 2)
    }
    
    func getClassStack() -> some View {
        return VStack(alignment: .leading) {
            Text(tutor.getFullName()).bold()
            HStack {
                Text("Grade: \(tutor.grade.rawValue) (" + "\(tutor.grade)".toCase(String.Case.title) + ")").italic()
            }
            Text(TutorUtils.sectAsCsv(tutor))
                .foregroundColor(.gray)
            HStack {
                Text("Zoom Link:")
                Text.createLink(tutor.getZoomUrl().toNonNil())
            }
            SBUnifiedWarning(text: tutor.getZoomUrl().toNonNil())
        }
    }
}

struct TutorResourcesView: View {
    private var allResources = Parser.getTutorResources()
    
    var body: some View {
        ScrollView {
            ForEach(allResources, id: \.self) { resource in
                VStack {
                    Text(resource.title).bold()
                        .padding(.bottom, 10)
                    Text(resource.desc).font(.body)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        UIApplication.shared.open(URL(string: resource.url)!)
                    }) {
                        WebButton.create("Access Here").font(.body)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(UIScreen.main.bounds.height * 0.05)
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
            if text.lowercased().contains("sbunified") {
                Text("WARNING: ").bold()
                Text("SBUnified Zoom account required")
            }
        }
    }
}

class WebButton {
    static func create(_ text: String) -> some View {
        return Text(text)
            .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50))
            .foregroundColor(.white)
            .background(Color.init(red: 0, green: 51 / 255, blue: 102 / 255))
            .cornerRadius(40)
    }
}
