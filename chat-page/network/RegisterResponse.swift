//
//  RegisterResponse.swift
//  chat-page
//
//  Created by idan on 12/02/2022.
//

import UIKit
import ObjectMapper

class UserRegistterResponse: BasicResponse {
    var user: User?
    override func mapping(map: Map) {
        super.mapping(map: map)
        user <- map["user"]
    }
}
