//
//  RideTableViewCellViewModel.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation
import RxSwift

class RideTableViewCellViewModel {
    fileprivate let disposeBag = DisposeBag()
    
    let apiManager: NetworkingApi
    var ride: Ride
    
    init(ride: Ride, apiManager: NetworkingApi) {
        self.ride = ride
        self.apiManager = apiManager
    }
    
    //MARK: public functions
    
    func departureAndArrival() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let departure = formatter.string(from: ride.departureTime as Date)
        let arrival = formatter.string(from: ride.arrivalTime as Date)
        return departure + " - " + arrival
    }
    
    func ridePrice() -> NSAttributedString {
        let priceIntegerFormatter = ConfigurationManager.priceIntegerFormatter
        let priceFractionFormatter = ConfigurationManager.priceFractionFormatter
        let priceInteger = priceIntegerFormatter.string(from: NSNumber(value: ride.price)) ?? ""
        let priceDecimal = priceFractionFormatter.string(from: NSNumber(value: ride.price)) ?? ""
        
        let integerFont = ConfigurationManager.font1
        let integerStringAttributes = [NSFontAttributeName : integerFont]
        let integerPart = NSMutableAttributedString(string: priceInteger, attributes: integerStringAttributes)
        let decimalFont = ConfigurationManager.font2
        let decimalStringAttributes = [NSFontAttributeName : decimalFont]
        let decimalPart = NSAttributedString(string: priceDecimal, attributes: decimalStringAttributes)
        integerPart.append(decimalPart)
        
        return integerPart
    }
    
    func rideDuration() -> String {
        let components = (Calendar.current as NSCalendar).components([.hour, .minute], from: ride.departureTime, to: ride.arrivalTime, options: [])
        let result = "\(components.hour ?? 0):\(components.minute ?? 0 > 9 ? "" : "0")\(components.minute ?? 0)h"
        return result
    }
    
    func numberOfStops() -> String {
        if ride.numberOfStops == 0 {
            return "Direct"
        } else {
            return "\(ride.numberOfStops) stop\(ride.numberOfStops>1 ? "s" : "")"
        }
    }
    
    //MARK: network operations
    
    func downloadProviderLogoImage(handler: @escaping (UIImage)->Void) {
        apiManager.requestImage(imageUrlString: ride.providerLogoUrl).subscribe(onNext: { (downloadedImage: UIImage) in
            handler(downloadedImage)
        }).addDisposableTo(disposeBag)
    }
}
