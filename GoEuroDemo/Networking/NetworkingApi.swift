//
//  NetworkingApi.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkingApi {
    func requestImage(imageUrlString: String) -> Observable<UIImage>
    
    // functions below are exposed in protocol as this hides predefined Urls for: flightsUrl, trainsUrl, busesUrl. Those should be hidden in the implementation section of the protocol
    func requestFlights() -> Observable<[Ride]>
    func requestTrains() -> Observable<[Ride]>
    func requestBuses() -> Observable<[Ride]>
}
