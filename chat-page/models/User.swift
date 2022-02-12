//
//  User.swift
//  chat-page
//
//  Created by idan on 12/02/2022.
//

import Foundation
import MessageKit

class User: SenderType {
    var senderId: String
    var displayName: String
    
    init(){
        self.senderId = "1"
        self.displayName = "idan"
    }
}
