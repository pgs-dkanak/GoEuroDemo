//
//  Ride.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation
import UIKit

protocol JSONDecodable {
    init?(json: [String: Any])
}

extension Array where Element: JSONDecodable {
    static func from(jsonArray: [[String: Any]]) -> [Element]? {
        return jsonArray.flatMap { Element(json: $0) }
    }
}

class Ride: JSONDecodable {
    
    // MARK: -
    // MARK: Constants
    
    struct Key {
        static let id = "id"
        static let provider_logo = "provider_logo"
        static let price_in_euros = "price_in_euros"
        static let departure_time = "departure_time"
        static let arrival_time = "arrival_time"
        static let number_of_stops = "number_of_stops"
    }
    
    struct Constants {
        static let defaultTimeFormat = "HH:mm"
        static let preferredImageSize = 63
    }
    
    //MARK: -
    // MARK: Properties
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = Constants.defaultTimeFormat
        return f
    }()
    
    var id              : Int = 0
    var providerLogoUrl : String = ""
    var price           : Float = 0.0
    var departureTime   : Date = Date()
    var arrivalTime     : Date = Date()
    var numberOfStops   : Int = 0
    var durationInMinutes : Int {
        let components = (Calendar.current as NSCalendar).components([.minute], from: departureTime, to: arrivalTime, options: [])
        let result = components.minute ?? 0
        return result
    } // this looks nice, but could be precalculated at init to save performance
    
    // MARK: -
    // MARK: public finctions
    
    required init?(json: [String: Any]) {
        id              = json[Key.id] as? Int ?? id
        providerLogoUrl = insert(json[Key.provider_logo] as? String ?? providerLogoUrl, size: Constants.preferredImageSize)
        price           = json[Key.price_in_euros] as? Float ?? price
        departureTime   = dateFromString(json[Key.departure_time] as? String ?? "")
        arrivalTime     = dateFromString(json[Key.arrival_time] as? String ?? "")
        numberOfStops   = json[Key.number_of_stops] as? Int ?? numberOfStops
    }
    
    func dateFromString(_ dateString: String) -> Date {
        let result = formatter.date(from: dateString) ?? Date()
        return result
    }
    
    func insert(_ urlString: String, size: Int) -> String {
        let result = urlString.replacingOccurrences(of: "{size}", with: "\(size)")
        return result.replacingOccurrences(of: "http", with: "https")
    }
}

extension Ride: Equatable {
    static func ==(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.id == rhs.id &&
            lhs.providerLogoUrl == rhs.providerLogoUrl &&
            lhs.price == rhs.price &&
            lhs.departureTime == rhs.departureTime &&
            lhs.numberOfStops == rhs.numberOfStops
    }
}

extension Array where Element: Ride {
    static func ==(lhs: [Ride], rhs: [Ride]) -> Bool {
        var isEqual = true
        for (left, right) in zip(lhs, rhs) {
            if left != right {
                isEqual = false
                break
            }
        }
        return isEqual
    }
}
