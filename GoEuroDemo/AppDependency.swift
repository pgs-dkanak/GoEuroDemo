//
//  AppDependency.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import Foundation
import UIKit

    // AppDependency object is intended to be an Objective-C facade object, as it is impossible to create RidesViewModel from Objective-C directly. This is due to usage of NetworkingAPI protocol within RidesViewModel initializer, which is swift-only protocol. This is neat workaround that makes possible to manage Swift-only objects from Objective-C code.

class AppDependency: NSObject {
    
    let apiManager = APIManager()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func createRidesViewModel() -> RidesViewModel {
        return RidesViewModel(apiManager: apiManager)
    }
    
    func createMainViewController() -> UIViewController {
        let vc = storyboard.instantiateInitialViewController() as! RidesViewController
        vc.viewModel = RidesViewModel(apiManager: apiManager)
        return vc
    }
}
