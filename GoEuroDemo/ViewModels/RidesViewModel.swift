//
//  RidesViewModel.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum RideType : Int {
    case train = 0
    case bus = 1
    case flight = 2
    case unknown = 1000
    
    init(n: Int) {
        switch n {
        case 0:
            self = .train
        case 1:
            self = .bus
        case 2:
            self = .flight
        default:
            self = .unknown
        }
    }
}

enum SortType {
    case arrivals
    case departures
    case duration
    case price
    case numberOfStops
    
    func name() -> String {
        switch self {
        case .arrivals:
            return "Arrivals"
        case .departures:
            return "Departures"
        case .duration:
            return "Duration"
        case .price:
            return "Price"
        case .numberOfStops:
            return "Number of Stops"
        }
    }
}

//MARK: -
//MARK: protocols

protocol ViewModelProtocol {}

protocol RidesViewModelInput {
    func setRidesVisible(_ index: Int)
    func didPressCell(_ index: Int)
    func setSortType(sortType: SortType)
    func sortRides()
    func getRideTableViewCellViewModelFor(index: Int) -> RideTableViewCellViewModel
}

protocol RidesViewModelOutput {
    var rides: [Ride] { get }
    var onRidesChanged : Observable<[Ride]> { get }
    var onMessage: Observable<(String, String)> { get }
    var showBusyIndicator: Observable<Bool> { get }
    var sortType: SortType { get }
}

protocol RidesViewModelProtocol: RidesViewModelInput, RidesViewModelOutput, ViewModelProtocol {
}

//MARK: -
//MARK: Rides View Model

@objc
class RidesViewModel: NSObject, RidesViewModelProtocol {
    fileprivate var apiManager: NetworkingApi
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var ridesVisibleType = RideType.train
    var sortType = SortType.departures
    var sortOrderAscending = true
    
    //MARK: -
    //MARK: Variables / Observables
    
    fileprivate var ridesVariable = Variable<[Ride]>([])
    var rides : [Ride] {
        return ridesVariable.value
    }
    var onRidesChanged : Observable<[Ride]>{
        return ridesVariable.asObservable()//.skip(1)
    }
    fileprivate var onMessageVariable = Variable<(String, String)>("","")
    var onMessage: Observable<(String, String)> {
        return onMessageVariable.asObservable().skip(1)
    }
    fileprivate var showBusyIndicatorVariable = Variable<Bool>(false)
    var showBusyIndicator: Observable<Bool> {
        return showBusyIndicatorVariable.asObservable().skip(1)
    }
    
    //MARK: -
    //MARK: public functions
    
    required init(apiManager: NetworkingApi) {
        self.apiManager = apiManager
    }
    
    func getRideTableViewCellViewModelFor(index: Int) -> RideTableViewCellViewModel {
        return RideTableViewCellViewModel(ride: rides[index], apiManager: apiManager)
    }
    
    func getRideTableViewCellViewModelFor(ride: Ride) -> RideTableViewCellViewModel {
        return RideTableViewCellViewModel(ride: ride, apiManager: apiManager)
    }
    
    func setRidesVisible(_ index: Int) {
        ridesVisibleType = RideType(n: index)
        self.showBusyIndicatorVariable.value = true
        requestRides(ridesVisibleType).subscribe(onNext: { [weak self] (rides: [Ride]) in
            self?.ridesVariable.value = rides
            self?.showBusyIndicatorVariable.value = false
            }, onError: { [weak self] (error: Error) in
                self?.showBusyIndicatorVariable.value = false
                self?.onMessageVariable.value = ("Error", error.localizedDescription)
        }).addDisposableTo(disposeBag)
    }
    
    func didPressCell(_ index: Int) {
        let ride = rides[index]
        onMessageVariable.value = ("Transport", "This will cost \(ConfigurationManager.currencySymbol)\(String(format:"%.2f",ride.price)).\nDetails have not been implemented yet.")
    }
    
    private func requestRides(_ type: RideType) -> Observable<[Ride]> {
        switch type {
        case .train:
            return apiManager.requestTrains()
        case .bus:
            return apiManager.requestBuses()
        case .flight:
            return apiManager.requestFlights()
        default:
            return Observable.empty()
        }
    }
    
    func setSortType(sortType: SortType) {
        self.sortType = sortType
        sortRides()
    }
    
    func sortRides() {
        switch sortType {
        case .arrivals:
            ridesVariable.value = rides.sorted { $0.0.arrivalTime.compare($0.1.arrivalTime as Date) == ComparisonResult.orderedAscending }
        case .departures:
            ridesVariable.value = rides.sorted { $0.0.departureTime.compare($0.1.departureTime as Date) == ComparisonResult.orderedAscending }
        case .duration:
            ridesVariable.value = rides.sorted(by: { $0.0.durationInMinutes < $0.1.durationInMinutes })
        case .price:
            ridesVariable.value = rides.sorted(by: { $0.0.price < $0.1.price })
        case .numberOfStops:
            ridesVariable.value = rides.sorted(by: { $0.0.numberOfStops < $0.1.numberOfStops })
        }
    }
    
}
