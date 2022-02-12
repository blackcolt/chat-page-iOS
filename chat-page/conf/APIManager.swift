//
//  APIManager.swift
//  chat-page
//
//  Created by idan on 12/02/2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireMapper
import AlamofireObjectMapper

class APIManager: NSObject {
    private static let registerUser = "registerUser"

    static func register(userName: String, socketId: String, onSuccess: @escaping(UserRegistterResponse) -> Void, onFailure: @escaping(Error) -> Void) {
        Alamofire.request(Config.apiUrl.appendingPathComponent(registerUser),
                          method: .post, parameters: ["userName": userName, "socketId": socketId], encoding: JSONEncoding.default)
            .responseObject { (response: DataResponse<UserRegistterResponse>) in
                if let userResponse = response.result.value {
                    onSuccess(userResponse)
                } else {
                    onFailure(response.error!)
                }
        }
    }
}
