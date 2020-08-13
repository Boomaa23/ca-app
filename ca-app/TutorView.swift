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
                Button(action: {
                    self.populateCheckMap(false)
                    self.pushTutors.removeAll()
                }) {
                    Image(systemName: "xmark.square")
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
            HStack(alignment: .top) {
                Image(uiImage: tutor.imageUrl.downloadSquare("\(imgVal)"))
                    .toSquareSize(imgVal)
                    .cornerRadius(imgVal / 2)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                VStack(alignment: .leading) {
                    Text(tutor.getFullName()).bold()
                    HStack {
                        Text("Grade: \(tutor.grade.rawValue) (" + "\(tutor.grade)".toCase(String.Case.title) + ")").italic()
                    }
                    Text(TutorUtils.sectAsCsv(tutor))
                        .foregroundColor(.gray)
                    HStack {
                        Text("Session Signup:")
                        Text.createLink(tutor.getCalendlyUrl().toNonNil())
                    }
                    HStack {
                        Text("Zoom Link:")
                        Text.createLink(tutor.getZoomUrl().toNonNil())
                    }
                    SBUnifiedWarning(text: tutor.getZoomUrl().toNonNil())
                }
            }
            HStack {
                Button(action: {
                    self.showPullup.toggle()
                }) {
                    Image(systemName: "plus")
                    Text("Request Session")
                }
                .sheet(isPresented: $showPullup, content: {
                    MailView(to: [self.tutor.getEmail().toNonNil(String.blank())], body: "BLAH BLAH BLAH<br>BLAH BLAH")
                })
                .cornerRadius(12)
                .foregroundColor(.blue)
            }
        }.padding(40)
    }
}

struct TutorResourcesView: View {
    var body: some View {
        VStack {
            //TODO make this access dynamic
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
