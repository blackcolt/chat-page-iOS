//
//  User.swift
//  chat-page
//
//  Created by idan on 12/02/2022.
//

import Foundation
import MessageKit
import ObjectMapper

class User: Mappable, SenderType {
    var senderId: String = ""
    var displayName: String = ""
    var socketId: String = ""

    required init?() {}
    required init?(map: Map) {}
    func mapping(map: Map) {
        senderId <- map["_id"]
        socketId <- map["socketId"]
        displayName <- map["userName"]
    }
}
