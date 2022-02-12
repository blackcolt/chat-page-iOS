//
//  Conf.swift
//  chat-page
//
//  Created by idan on 12/02/2022.
//

import Foundation

class Config {
    #if DEBUG
        static let baseUrl = URL(string: "http://localhost")!
    #else
        static let baseUrl =  URL(string: "http://idan-magled.duckdns.org/")!
    #endif
    static let apiUrl = baseUrl.appendingPathComponent("/api/")
    static let socketUrl = baseUrl
}
