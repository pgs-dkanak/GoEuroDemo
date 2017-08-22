//
//  RideTests.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import XCTest
//@testable import GoEuroDemo

class RideTests: XCTestCase {
    
    var jsonObjects: [[String:Any]] = [[:]]
    var oneJsonObject: [String:Any] = [:]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        jsonObjects = TestHelpers.jsonObjectsDictionaryFromFile(name: "testBus")
        oneJsonObject = TestHelpers.singleJSONObjectDictionaryFromFile(name: "one")
    }
    
    func testRideCanBeConstructedFromJSON() {
        let one = Ride(json: oneJsonObject)
        XCTAssertTrue(one != nil)
    }
    
    func testRideIsParsedCorrectly() {
        let one = Ride(json: oneJsonObject)
        
        let url = "http://cdn-goeuro.com/static_content/web/logos/{size}/meinfernbus_flixbus.png"
        let size = 63
        let providerLogoUrl = url.replacingOccurrences(of: "{size}", with:"\(size)").replacingOccurrences(of: "http", with: "https")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let departure_time = formatter.date(from: oneJsonObject[Ride.Key.departure_time] as? String ?? "") ?? Date()
        let arrival_time = formatter.date(from: oneJsonObject[Ride.Key.arrival_time] as? String ?? "") ?? Date()
        
        XCTAssertTrue(one?.id == 1)
        XCTAssertTrue(one?.providerLogoUrl == providerLogoUrl)
        XCTAssertTrue(one?.price == 46.37)
        XCTAssertTrue(((one?.departureTime) != nil))
        XCTAssertTrue(one?.departureTime == departure_time)
        XCTAssertTrue(one?.arrivalTime != nil)
        XCTAssertTrue(one?.arrivalTime == arrival_time)
        XCTAssertTrue(one?.numberOfStops == 1)
    }
    
    func testRideParsingMultipleObjectsFromArray() {
        let rides = [Ride].from(jsonArray: jsonObjects) ?? []
        XCTAssertTrue(rides.count == 4)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
