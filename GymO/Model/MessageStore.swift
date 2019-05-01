//
//  MessageStore.swift
//  GymO
//
//  Created by Kean Wei Wong on 27/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import Foundation
import MessageKit

class MessageStore {
    
    static let instance = MessageStore()
    private var messageCache = [Message]()
    
    init() {}
    
    func addMessage(message: Message) {
        messageCache.append(message)
    }
    
    func getMessages() -> [Message] {
        return messageCache
    }
}
