//
//  Message.swift
//  GymO
//
//  Created by Kean Wei Wong on 27/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType{
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, sender:Sender, messageId: String, date: Date){
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(attributedText:  NSAttributedString, sender:Sender, messageId: String, date: Date){
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    init(emoji: String, sender:Sender, messageId: String, date: Date){
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
    
}

extension MessageType {
    
    func getMessage() -> Any {
        switch self.kind {
        case .attributedText(let attributedText):
            return attributedText as NSAttributedString
        case .text(let text):
            return text
        case .emoji(let emoji):
            return emoji
        case .custom(let custom):
            return custom!
        case .photo(let photo):
            return photo
        case .video(let video):
            return video
        default:
            return "getMessage problem"
        }
    }
}
