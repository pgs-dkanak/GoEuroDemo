//
//  ConfigurationManager.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation
import UIKit

// ConfigurationManager holds basic settings. Mostly price formatting and fonts 

class ConfigurationManager {
    static var font1 = UIFont.systemFont(ofSize: 18)
    static var font2 = UIFont.systemFont(ofSize: 12)
    static var currencySymbol = "\u{20AC}"
    
    static var priceIntegerFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = ConfigurationManager.currencySymbol
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = .floor
        return formatter
    }()
    
    static  var priceFractionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.maximumIntegerDigits = 0
        return formatter
    }()
}
