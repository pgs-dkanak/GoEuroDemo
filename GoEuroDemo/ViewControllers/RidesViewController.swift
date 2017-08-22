//
//  RidesViewController.swift
//  GoEuroDemo
//
//  Created by Damian Kanak on 22/08/2017.
//  Copyright © 2017 pgs. All rights reserved.
//

import UIKit
import RxSwift

protocol ViewControllerProtocol {
    var viewModel: ViewModelProtocol { get set }
}

protocol ViewModelContainer {
    associatedtype ViewModelType: ViewModelProtocol
    var viewModel: ViewModelType! { get set }
}

class RidesViewController: UIViewController, ViewModelContainer {
    fileprivate let disposeBag = DisposeBag()
    
    var viewModel: RidesViewModel!
    typealias ViewModelType = RidesViewModel
    var spinner: UIActivityIndicatorView?
    
    //MARK: -
    //MARK: IBoutlets
    
    @IBOutlet weak var ridesTableView: UITableView!
    @IBOutlet weak var rideTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    //MARK: IBActions
    
    @IBAction func didPressSortButton(_ sender: Any) {
        let sortCriteriaAlertController = createSortCriteriaAlertController()
        self.present(sortCriteriaAlertController, animated: true, completion: nil)
    }
    
    @IBAction func didChangeSegmentedControlValue(_ sender: Any) {
        viewModel.setRidesVisible(rideTypeSegmentedControl.selectedSegmentIndex)
    }

    //MARK: -
    //MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.onRidesChanged.subscribe(onNext: {[weak self] _ in
            self?.ridesTableView.reloadData()
        }).addDisposableTo(disposeBag)
        
        viewModel.onMessage.subscribe(onNext: { (message: (String, String)) in
            UIAlertView(title: message.0, message: message.1, delegate: nil, cancelButtonTitle: "OK").show()
        }, onError: { (error: Error) in
            UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
        }).addDisposableTo(disposeBag)
        
        viewModel.showBusyIndicator.subscribe(onNext: { [weak self] (show: Bool) in
            self?.activityIndicator(show: show)
        }).addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setRidesVisible(RideType.train.rawValue)
    }
    
    //MARK: -
    //MARK: private functions
    
    fileprivate func activityIndicator(show: Bool) {
        if show {
            let width: CGFloat = 80
            let height:CGFloat = 80
            let activityIndicatorFrame = CGRect(x: CGFloat(view.center.x) - CGFloat(width/2), y: view.center.y - CGFloat(height/2), width: width, height: height)
            let spinner = UIActivityIndicatorView(frame: activityIndicatorFrame)
            spinner.backgroundColor = UIColor.gray
            spinner.alpha = 0.5
            spinner.layer.cornerRadius = 10
            spinner.hidesWhenStopped = true
            spinner.startAnimating()
            view.addSubview(spinner)
            self.spinner = spinner
        } else {
            if let spinner = self.spinner {
                spinner.stopAnimating()
                self.spinner = nil
            }
        }
    }
    
    fileprivate func createSortCriteriaAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Sort criteria", message: nil, preferredStyle: .actionSheet)
        
        let sortByDepartureTime = UIAlertAction(title: "Departure time", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel.setSortType(sortType: .departures)
        }
        let sortByArrivalTime = UIAlertAction(title: "Arrival time", style: .default) { [weak self](action: UIAlertAction) in
            self?.viewModel.setSortType(sortType: .arrivals)
        }
        let sortByDuration = UIAlertAction(title: "Duration", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel.setSortType(sortType: .duration)
        }
        let sortByPrice = UIAlertAction(title: "Price", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel.setSortType(sortType: .price)
        }
        let sortByNumberOfStops = UIAlertAction(title: "Number of stops", style: .default) { [weak self] (action: UIAlertAction) in
            self?.viewModel.setSortType(sortType: .numberOfStops)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(sortByDepartureTime)
        alertController.addAction(sortByArrivalTime)
        alertController.addAction(sortByDuration)
        alertController.addAction(sortByPrice)
        alertController.addAction(sortByNumberOfStops)
        alertController.addAction(cancel)
        return alertController
    }
}

// MARK: UITableViewDataSource

extension RidesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideTableViewCell", for: indexPath) as! RideTableViewCell
        let cellViewModel = viewModel.getRideTableViewCellViewModelFor(index: indexPath.row)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animateCell(cell, andDuration: 0.3)
    }
}

// MARK: UITableViewDelegate

extension RidesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didPressCell(indexPath.row)
    }
}

// MARK: Cell animation

extension RidesViewController {
    func animateCell(_ cell: UITableViewCell, andDuration duration: TimeInterval) {
        
        let TransformCurl = { (layer: CALayer) -> CATransform3D in
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -500
            transform = CATransform3DTranslate(transform, -layer.bounds.size.width/2.0, 0.0, 0.0)
            transform = CATransform3DRotate(transform, CGFloat(Double.pi)/2.0, 0.0, 1.0, 0.0)
            transform = CATransform3DTranslate(transform, layer.bounds.size.width/2.0, 0.0, 0.0)
            
            return transform
        }
        
        let view = cell.contentView
        view.layer.transform = TransformCurl(cell.layer)
        view.layer.opacity = 0.8
        
        UIView.animate(withDuration: duration, animations: {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        })
    }
}
