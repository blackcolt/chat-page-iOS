//
//  Message.swift
//  moadonim
//
//  Created by Idan Magled on 10/02/2020.
//  Copyright © 2020 com.moadonim.www. All rights reserved.
//
import UIKit
import MessageKit
//import ObjectMapper

class Message: MessageType {
    var sender: SenderType
    var messageText: String?
    var messageId: String = ""
    var messageIdInt: Int?
    var sentDate: Date = Date()
    var sentDateString: String?
    var kind: MessageKind = .text("")
    init(messageText: String, sender: SenderType){
        self.messageText = messageText
        self.sender = sender
        self.kind = .text(messageText)
    }
//    var sender: SenderType = User.shared!
//    override func mapping(map: Map) {
//        super.mapping(map: map)
//        user <- map["user"]
//        sender = user ?? User.shared!
//        messageIdInt <- map["id"]
//        messageText <- map["message"]
//        kind = .text(messageText ?? "")
//        messageId = "\(messageIdInt ?? 0)"
//        sentDateString <- map["created_at"]
//        sentDate = HelperFunctions.stringToDate(dateString: sentDateString ?? "") ?? Date()
//    }
}
