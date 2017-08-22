//
//  APIManager.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

/*
 This is concrete implementation of NetworkingApi
 */

import Foundation
import Alamofire
import RxSwift

class APIManager : NSObject {
    // request uses global AlamoFire request function as SessionManager would be too much overkill for such a small project
    
    func requestJsonArray<T: JSONDecodable>(_ urlString: URLConvertible) -> Observable<[T]> {
        return Observable.create({ (subscriber: AnyObserver<[T]>) -> Disposable in
            let req = request(urlString, method: .get).responseJSON(completionHandler: { (response: DataResponse<Any>) in
                if let error = response.error {
                    subscriber.onError(error)
                } else if let json = response.value {
                    let jsonTable = json as? NSArray ?? []
                    let array = [T].from(jsonArray: jsonTable as! [[String : Any]]) ?? []
                    subscriber.onNext(array)
                }
            })
            
            return Disposables.create {
                req.cancel()
            }
        })
    }
}

extension APIManager: NetworkingApi {
    func requestFlights() -> Observable<[Ride]> {
        return requestJsonArray(RideType.flight.url)
    }
    func requestTrains() -> Observable<[Ride]> {
        return requestJsonArray(RideType.train.url)
    }
    func requestBuses() -> Observable<[Ride]> {
        return requestJsonArray(RideType.bus.url)
    }
    
    func requestImage(imageUrlString: String) -> Observable<UIImage> {
        return Observable.create { (subscriber: AnyObserver<UIImage>) -> Disposable in
            let req = request(imageUrlString, method: .get).responseData { (response: DataResponse<Data>) in
                if let error = response.error {
                    subscriber.onError(error)
                } else if let imageData = response.value {
                    let image = UIImage(data: imageData) ?? UIImage()
                    subscriber.onNext(image)
                }
            }
            
            return Disposables.create {
                req.cancel()
            }
        }
    }
}

extension RideType {
    var url: URLConvertible {
        switch self {
        case .bus:
            return "https://api.myjson.com/bins/37yzm"
        case .train:
            return "https://api.myjson.com/bins/3zmcy"
        case .flight:
            return "https://api.myjson.com/bins/w60i"
        default:
            return ""
        }
    }
}

