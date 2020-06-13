//
// Created by Nikhil on 6/12/20.
// Copyright (c) 2020 Charger Academy. All rights reserved.
//

import Foundation

class RequestHelper {
    static func caGet(relUrl: String) -> String {
        get(url: "https://charger.academy/\(relUrl)")
    }

    static func get(url: String) -> String {
        do {
            return try String(contentsOf: URL(string: url)!)
        } catch let error {
            print(error)
        }
        return String()
    }
}

class Parser {
    static func getTutors() -> [String: [String]] {
        let raw: String = RequestHelper.caGet(relUrl: "tutors")
    }
}