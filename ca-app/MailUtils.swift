//  Charger Academy iOS App
//  Copyright © 2020 Nikhil Ograin. All rights reserved.

import Foundation
import UIKit
import MessageUI
import SwiftUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    init(to: [String], body: String) {
        super.init(nibName: nil, bundle: nil)
        send(to, body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func send(_ to: [String],_ body: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(to)
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
    private let to: [String]
    private let body: String
    
    init(to: [String], body: String) {
        self.to = to
        self.body = body
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MailViewController {
        return MailViewController(to: to, body: body)
    }
    
    func updateUIViewController(_ uiViewController: MailViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

struct MailView_Previews: PreviewProvider {
    static var previews: some View {
        MailView(to: [String](), body: String())
    }
}


