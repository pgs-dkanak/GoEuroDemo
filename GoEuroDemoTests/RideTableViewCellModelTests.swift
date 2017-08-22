//
//  RideTableViewCellModelTests.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import XCTest
import RxSwift


class RideTableViewCellModelTests: XCTestCase {
    let ridesViewModel: RidesViewModel = RidesViewModel(apiManager: MockAPIManager())
    let disposeBag = DisposeBag()
    
    let buses = [Ride].from(jsonArray: TestHelpers.jsonObjectsDictionaryFromFile(name: "testBus")) ?? []
    let flights = [Ride].from(jsonArray: TestHelpers.jsonObjectsDictionaryFromFile(name: "testFlight")) ?? []
    let trains = [Ride].from(jsonArray: TestHelpers.jsonObjectsDictionaryFromFile(name: "testTrain")) ?? []
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBusesRideTableViewCellViewModelRepresentation() {
        ridesViewModel.setRidesVisible(RideType.bus.rawValue)
        ridesViewModel.onRidesChanged.subscribe(onNext: { [weak self] (rides: [Ride]) in
            guard let strongSelf = self else {
                XCTAssert(false, "self is nil")
                return
            }
            
            // extracting cell viewModels from main view model
            let cellViewModels = rides.map({ (ride: Ride) -> RideTableViewCellViewModel in
                return strongSelf.ridesViewModel.getRideTableViewCellViewModelFor(ride: ride)
            })

            let isMatchingRepresentation = strongSelf.hasMatchingRepresentation(cellViewModels: cellViewModels, to: strongSelf.buses)

            XCTAssert(isMatchingRepresentation)
        }).addDisposableTo(disposeBag)
    }
    
    func testFlightsRideTableViewCellViewModelRepresentation() {
        ridesViewModel.setRidesVisible(RideType.flight.rawValue)
        ridesViewModel.onRidesChanged.subscribe(onNext: { [weak self] (rides: [Ride]) in
            guard let strongSelf = self else {
                XCTAssert(false, "self is nil")
                return
            }
            
            // extracting cell viewModels from main view model
            let cellViewModels = rides.map({ (ride: Ride) -> RideTableViewCellViewModel in
                return strongSelf.ridesViewModel.getRideTableViewCellViewModelFor(ride: ride)
            })
            
            let isMatchingRepresentation = strongSelf.hasMatchingRepresentation(cellViewModels: cellViewModels, to: strongSelf.flights)
            
            XCTAssert(isMatchingRepresentation)
        }).addDisposableTo(disposeBag)
    }
    
    func testTrainRideTableViewCellViewModelRepresentation() {
        ridesViewModel.setRidesVisible(RideType.train.rawValue)
        ridesViewModel.onRidesChanged.subscribe(onNext: { [weak self] (rides: [Ride]) in
            guard let strongSelf = self else {
                XCTAssert(false, "self is nil")
                return
            }
            
            // extracting cell viewModels from main view model
            let cellViewModels = rides.map({ (ride: Ride) -> RideTableViewCellViewModel in
                return strongSelf.ridesViewModel.getRideTableViewCellViewModelFor(ride: ride)
            })
            
            let isMatchingRepresentation = strongSelf.hasMatchingRepresentation(cellViewModels: cellViewModels, to: strongSelf.trains)
            
            XCTAssert(isMatchingRepresentation)
        }).addDisposableTo(disposeBag)
    }
}

// MARK: -
// MARK: comparators

extension RideTableViewCellModelTests {
    func hasMatchingRepresentation(cellViewModels: [RideTableViewCellViewModel], to rides: [Ride]) -> Bool {
        let matchingViewModels = zip(cellViewModels, rides).filter({ [weak self] (viewModel: RideTableViewCellViewModel, ride: Ride) -> Bool in
            guard let strongSelf = self else {
                XCTAssert(false, "self is nil")
                return false
            }
            let result = strongSelf.hasMatchingStringRepresentation(viewModel: viewModel, ride: ride)
            return result
        })
        
        return cellViewModels.count == matchingViewModels.count
    }
    
    func hasMatchingStringRepresentation(viewModel: RideTableViewCellViewModel, ride: Ride) -> Bool {
        if viewModel.departureAndArrival() != departureAndArrival(departureTime: ride.departureTime, arrivalTime: ride.arrivalTime) {
            return false
        }
        if viewModel.rideDuration() != rideDuration(departureTime: ride.departureTime, arrivalTime: ride.arrivalTime) {
            return false
        }
        if viewModel.ridePrice() != ridePrice(price: ride.price) {
            return false
        }
        if viewModel.numberOfStops() != numberOfStops(numberOfStops: ride.numberOfStops) {
            return false
        }
        
        return true
    }
}

// MARK: -
// MARK: string formatting functions
// functions below are helper formatting functions which results will enable to see whether RideTableViewCellModel's formatting is consistent with functions below. If tests based on those functions will fail at some point (eg. due to refactor), team will be aware that string formatting have been changed. This will empower team to make concious decision how to move forward upon formatting have been changed

// In short: these functions are formatting strings independently from viewModel. Those results wll be challenged with results of viewModel whether they are consistent

extension RideTableViewCellModelTests {
    func departureAndArrival(departureTime: Date, arrivalTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let departure = formatter.string(from: departureTime as Date)
        let arrival = formatter.string(from: arrivalTime as Date)
        return departure + " - " + arrival
    }
    
    func ridePrice(price: Float) -> NSAttributedString {
        let priceIntegerFormatter = ConfigurationManager.priceIntegerFormatter
        let priceFractionFormatter = ConfigurationManager.priceFractionFormatter
        let priceInteger = priceIntegerFormatter.string(from: NSNumber(value: price)) ?? ""
        let priceDecimal = priceFractionFormatter.string(from: NSNumber(value: price)) ?? ""
        
        let integerFont = ConfigurationManager.font1
        let integerStringAttributes = [NSFontAttributeName : integerFont]
        let integerPart = NSMutableAttributedString(string: priceInteger, attributes: integerStringAttributes)
        let decimalFont = ConfigurationManager.font2
        let decimalStringAttributes = [NSFontAttributeName : decimalFont]
        let decimalPart = NSAttributedString(string: priceDecimal, attributes: decimalStringAttributes)
        integerPart.append(decimalPart)
        
        return integerPart
    }
    
    func rideDuration(departureTime: Date, arrivalTime: Date) -> String {
        let components = (Calendar.current as NSCalendar).components([.hour, .minute], from: departureTime, to: arrivalTime, options: [])
        let result = "\(components.hour ?? 0):\(components.minute ?? 0 > 9 ? "" : "0")\(components.minute ?? 0)h"
        return result
    }
    
    func numberOfStops(numberOfStops: Int) -> String {
        if numberOfStops == 0 {
            return "Direct"
        } else {
            return "\(numberOfStops) stop\(numberOfStops>1 ? "s" : "")"
        }
    }
}
