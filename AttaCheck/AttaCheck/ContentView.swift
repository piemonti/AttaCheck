//
//  ContentView.swift
//  AttaCheck
//
//  Created by Pietro Monti on 09/10/24.
//
import MailKit

class MailExtension: NSObject, MEExtension {
    static func getInstance() -> Any {
        return MailExtension()
    }
}

class ComposeSessionHandler: NSObject, MEComposeSessionHandler {
    
    // Keywords that suggest an attachment
    let attachmentKeywords = [
        "attach",
        "attached",
        "attaching",
        "enclosed",
        "I have included",
        "please find",
        "see attached",
        "sending you",
        "here is the",
        "I'm sending"
    ]
    
    func sessionDidBegin(_ session: MEComposeSession) {
        // Register for notifications when the user attempts to send
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willSendMessage(_:)),
            name: NSNotification.Name("MEComposeSessionWillSendMessage"),
            object: session
        )
    }
    
    func sessionDidEnd(_ session: MEComposeSession) {
        // Clean up by removing the observer
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func willSendMessage(_ notification: Notification) {
        guard let session = notification.object as? MEComposeSession else { return }
        
        // Get the message content
        let messageContent = session.messageBody.string.lowercased()
        
        // Check if any attachment keywords are present
        let hasAttachmentMention = attachmentKeywords.contains { keyword in
            messageContent.contains(keyword.lowercased())
        }
        
        // Get the number of attachments
        let attachmentCount = session.attachments.count
        
        // If attachment is mentioned but none are present, show warning
        if hasAttachmentMention && attachmentCount == 0 {
            let alert = NSAlert()
            alert.messageText = "Missing Attachment?"
            alert.informativeText = "You mentioned an attachment in your email, but no files are attached. Do you want to send anyway?"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Add Attachment")
            alert.addButton(withTitle: "Send Anyway")
            alert.addButton(withTitle: "Cancel")
            
            let response = alert.runModal()
            
            switch response {
            case .alertFirstButtonReturn: // Add Attachment
                // Cancel sending and let user add attachment
                session.cancelSending()
                // Trigger attachment sheet
                session.addAttachment()
            case .alertSecondButtonReturn: // Send Anyway
                // Do nothing, let the message send
                break
            default: // Cancel
                session.cancelSending()
            }
        }
    }
}

class MailExtensionViewController: MEExtensionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
}
