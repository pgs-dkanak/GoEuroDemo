//
//  TestHelpers.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation

class TestHelpers {
    static func jsonObjectsDictionaryFromFile(name: String) -> [[String : Any]] {
        var jsonObjects: [[String : Any]] = [[:]]
        if let path = Bundle(for: TestHelpers.self).path(forResource: name, ofType: "json") {
            let jsonString = try! String(contentsOfFile: path)
            let jsonData = jsonString.data(using: String.defaultCStringEncoding)
            jsonObjects = try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [[String : Any]] ?? [[:]]
        }
        return jsonObjects
    }
    
    static func singleJSONObjectDictionaryFromFile(name: String) -> [String : Any] {
        var oneJsonObject: [String : Any] = [:]
        if let pathOne = Bundle(for: TestHelpers.self).path(forResource: name, ofType: "json") {
            let oneJsonString = try! String(contentsOfFile: pathOne)
            let jsonData = oneJsonString.data(using: String.defaultCStringEncoding)
            oneJsonObject = try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String : Any] ?? [:]
        }
        return oneJsonObject
    }
}
