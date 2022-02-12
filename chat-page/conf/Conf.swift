//
//  Conf.swift
//  chat-page
//
//  Created by idan on 12/02/2022.
//

import Foundation

class Config {
    #if DEBUG
        static let socketUrl = URL(string: "http://localhost")!
    #else
        static let socketUrl = URL(string: "http://api.example.com")!
    #endif
}
