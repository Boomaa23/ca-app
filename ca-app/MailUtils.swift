//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation
import UIKit
import MessageUI
import SwiftUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    init(to: [String], body: String, subject: String) {
        super.init(nibName: nil, bundle: nil)
        send(to, body, subject)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func send(_ to: [String],_ body: String,_ subject: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(to)
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: true)
            present(mail, animated: true)
        } else {
            let errMsg = UITextView()
            //TODO fix this on-error display
            errMsg.text = "Your device does not support email. Please enable it in Settings."
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

struct MailView: UIViewControllerRepresentable {
    let to: [String]
    let body: String
    let subject: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MailViewController {
        return MailViewController(to: to, body: body, subject: subject)
    }
    
    func updateUIViewController(_ uiViewController: MailViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

struct MailView_Previews: PreviewProvider {
    static var previews: some View {
        MailView(to: [String](), body: String(), subject: String())
    }
}

class MailUtils {
    static func createBugReportBody() -> String {
        return "Charger.Academy iOS App Bug Report\n" +
            "----------------------------------" +
            "Date: " + ISO8601DateFormatter().string(from: Date()) + "\n" +
            "Name (optional): \n" +
            "Email (optional): \n" +
            "Issue Title: \n" +
            "Issue Description: \n"
    }
}

