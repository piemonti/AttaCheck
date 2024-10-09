//
//  ContentView.swift
//  AttaCheck
//
//  Created by Pietro Monti on 09/10/24.
//

import SwiftUI
import MailKit


struct ContentView: View {
    // Define the compose session
    var composeSession: MEComposeSession?
    
    var body: some View {
        Text("Hello, MailKit!")
    }
    
    func checkForAttachmentPhrase() {
        guard let session = composeSession else { return }
        
        let body = session.mailMessage.body
        
        // Define phrases to look for
        let attachmentPhrases = [
            "I attach this document",
            "Please find the attachment",
            "attached is the document"
        ]
        
        // Check if the body contains any of the phrases
        for phrase in attachmentPhrases {
            if body.contains(phrase) {
                if session.mailMessage.attachments.isEmpty {
                    showWarning()
                    break
                }
            }
        }
    }
    
    func showWarning() {
        // Show an alert to the user
        print("Warning: No attachment found.")
    }
}
#Preview {
    ContentView()
}
