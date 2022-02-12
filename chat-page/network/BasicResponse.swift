//
//  BasicResponse.swift
//  chat-page
//
//  Created by idan on 12/02/2022.
//

import UIKit
import ObjectMapper

class BasicResponse: Mappable {
    var success: Bool?
    var message: String?
    var errors: [String]?
    var version: String?
    var errorMessage: String?
    required init?(map: Map) {}
     func mapping(map: Map) {
        errors <- map["errors"]
        success <- map["success"]
        version <- map["version"]
        message <- map["message"]
        errorMessage <- map["error_message"]
    }
}
