//
//  RidesViewModelTests.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import XCTest
import RxSwift

class RidesViewModelTests: XCTestCase {
    let ridesViewModel: RidesViewModel = RidesViewModel(apiManager: MockAPIManager())
    let disposeBag = DisposeBag()
    
    let buses = [Ride].from(jsonArray: TestHelpers.jsonObjectsDictionaryFromFile(name: "testBus")) ?? []
    let trains = [Ride].from(jsonArray: TestHelpers.jsonObjectsDictionaryFromFile(name: "testTrain")) ?? []
    let flights = [Ride].from(jsonArray: TestHelpers.jsonObjectsDictionaryFromFile(name: "testFlight")) ?? []
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testRequestFlights() {
        ridesViewModel.setRidesVisible(RideType.flight.rawValue)
        ridesViewModel.onRidesChanged.subscribe(onNext: { [weak self] (rides: [Ride]) in
            guard let strongSelf = self else {
                XCTAssert(false, "self is nil")
                return
            }
            XCTAssert(rides == strongSelf.flights)
        }).addDisposableTo(disposeBag)
    }
    
    func testRequestTrains() {
        ridesViewModel.setRidesVisible(RideType.train.rawValue)
        ridesViewModel.onRidesChanged.subscribe(onNext: { [weak self] (rides: [Ride]) in
            guard let strongSelf = self else {
                XCTAssert(false, "self is nil")
                return
            }
            XCTAssert(rides == strongSelf.trains)
        }).addDisposableTo(disposeBag)
    }
    
    func testRequestBuses() {
        ridesViewModel.setRidesVisible(RideType.bus.rawValue)
        ridesViewModel.onRidesChanged.subscribe(onNext: { [weak self] (rides: [Ride]) in
            guard let strongSelf = self else {
                XCTAssert(false, "self is nil")
                return
            }
            XCTAssert(rides == strongSelf.buses)
        }).addDisposableTo(disposeBag)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
