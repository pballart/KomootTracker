//
//  ViewController.swift
//  KomootTracker
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit
import Moya

class RouteTrackerView: UIViewController {
    
    let provider = FlickrService(provider: MoyaProvider<SearchEndpoint>(plugins: [NetworkLoggerPlugin(cURL: true)]))
    @IBOutlet var startButton: UIBarButtonItem!
    var locationManager = LocationManager()
    var isPendingToStart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }

    @IBAction func startRoute(_ sender: UIBarButtonItem) {
        if locationManager.isTrackingLocation {
            locationManager.stopUpdatingLocation()
            updateStartButtonTitle(start: false)
        } else {
            switch locationManager.locationStatus() {
            case .notDetermined:
                isPendingToStart = true
                locationManager.requestLocationPermission()
            case .notEnabled:
                isPendingToStart = false
                showEnableLocationServiesAlert()
            case .rejected:
                isPendingToStart = false
                showAuthorizeLocationServiesAlert()
            case .authorized:
                isPendingToStart = false
                locationManager.startUpdatingLocation()
                updateStartButtonTitle(start: true)
            }
        }
    }
    
    private func showEnableLocationServiesAlert() {
        let alert = UIAlertController(title: "Enable location",
                                      message: "This app needs location services to be enabled.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAuthorizeLocationServiesAlert() {
        let alert = UIAlertController(title: "Enable location",
                                      message: "This app needs to be always authorized to use location services.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func updateStartButtonTitle(start: Bool) {
        startButton.title = start ? "Stop" : "Start"
    }
}

extension RouteTrackerView: LocationManagerDelegate {
    func didUpdateLocation(lat: Double, lon: Double) {
        print("New location received: \(lat) - \(lon)")
    }
    
    func didChangeAuthorizationStatus(status: LocationStatus) {
        if status == .authorized && isPendingToStart {
            isPendingToStart = false
            locationManager.startUpdatingLocation()
            updateStartButtonTitle(start: true)
        }
    }
}
