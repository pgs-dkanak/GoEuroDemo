//
//  RideTableViewCell.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class RideTableViewCell: UITableViewCell {
    
    @IBOutlet weak var providerLogo: UIImageView!
    @IBOutlet weak var departureAndArrivalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var numberOfStopsLabel: UILabel!

    @IBOutlet weak var providerLogoTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var providerLogoWidth: NSLayoutConstraint!
    
    var viewModel: RideTableViewCellViewModel? {
        didSet {
            populateFields()
        }
    }
    
    func populateFields() {
        guard let viewModel = self.viewModel else {
            print("ViewModel should be present to populate cell with data")
            return
        }
        departureAndArrivalLabel.text = viewModel.departureAndArrival()
        priceLabel.attributedText = viewModel.ridePrice()
        durationLabel.text = viewModel.rideDuration()
        numberOfStopsLabel.text = viewModel.numberOfStops()
        viewModel.downloadProviderLogoImage { (logoImage: UIImage) in
            self.providerLogo.image = logoImage
            self.providerLogo.contentMode = .scaleAspectFit
            self.adjustImageToLeftEdge()
        }
    }
    
    func adjustImageToLeftEdge() {
        let shrinkBy = self.providerLogoWidth.constant - (self.providerLogo.image?.size.width ?? 0)
        self.providerLogoTrailingConstraint.constant = shrinkBy>0 ? shrinkBy : 0
    }
}
