//
//  MockAPIManager.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation
import RxSwift

class MockAPIManager: NetworkingApi {
    func requestFlights() -> Observable<[Ride]> {
        return requestFromFile(name: "testFlight")
    }
    
    func requestTrains() -> Observable<[Ride]> {
        return requestFromFile(name: "testTrain")
    }
    
    func requestBuses() -> Observable<[Ride]> {
        return requestFromFile(name: "testBus")
    }
    
    func requestImage(imageUrlString: String) -> Observable<UIImage> {
        
        return Observable.create { (subscriber: AnyObserver<UIImage>) -> Disposable in
            var resultImage = UIImage()
            if let path = Bundle(for: type(of: self)).path(forResource: "air_berlin", ofType: "png") {
                resultImage = UIImage(contentsOfFile: path) ?? UIImage()
            }
            subscriber.onNext(resultImage)
            return Disposables.create {}
        }
    }
    
    fileprivate func requestFromFile(name: String) -> Observable<[Ride]> {
        let jsonObjects = TestHelpers.jsonObjectsDictionaryFromFile(name: name)
        let rides = [Ride].from(jsonArray: jsonObjects) ?? []
        
        return Observable.create({ (subscriber: AnyObserver<[Ride]>) -> Disposable in
            subscriber.onNext(rides)
            return Disposables.create()
        })
    }
}
