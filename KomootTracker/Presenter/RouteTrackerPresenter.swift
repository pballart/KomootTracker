//
//  RouteTrackerPresenter.swift
//  KomootTracker
//
//  Created by Pau Ballart on 22/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya
import RealmSwift
import RxSwift

protocol RouteTrackerViewProtocol: class {
    func updateStartButton(title: String)
    func showEnableLocationServiesAlert()
    func showAuthorizeLocationServiesAlert()
}

protocol RouteTrackerPresenterProtocol: class {
    func viewDidLoad()
    func startButtonPressed()
}

class RouteTrackerPresenter: RouteTrackerPresenterProtocol {
    fileprivate weak var view: RouteTrackerViewProtocol!
    fileprivate let provider: FlickrServiceProtocol
    fileprivate var locationManager = LocationManager()
    
    let disposeBag = DisposeBag()
    var isPendingToStart = false
    
    //Fetch images taken in the latests 6 months
    let minDate = Date().addingTimeInterval(-3600*24*30*6).timeIntervalSince1970

    init(view: RouteTrackerViewProtocol) {
        self.view = view
        provider = FlickrService(provider: MoyaProvider<SearchEndpoint>())
    }
    
    func viewDidLoad() {
        locationManager.delegate = self
    }
    
    func startButtonPressed() {
        if locationManager.isTrackingLocation {
            locationManager.stopUpdatingLocation()
            view.updateStartButton(title: "Start")
        } else {
            switch locationManager.locationStatus() {
            case .notDetermined:
                isPendingToStart = true
                locationManager.requestLocationPermission()
            case .notEnabled:
                isPendingToStart = false
                view.showEnableLocationServiesAlert()
            case .rejected:
                isPendingToStart = false
                view.showAuthorizeLocationServiesAlert()
            case .authorized:
                isPendingToStart = false
                cleanDataBase()
                locationManager.startUpdatingLocation()
                view.updateStartButton(title: "Stop")
            }
        }
    }
    
    private func cleanDataBase() {
        let realm = try! Realm()
        let photos = realm.objects(Photo.self)
        try! realm.write {
            realm.delete(photos)
        }
    }
    
}

extension RouteTrackerPresenter: LocationManagerDelegate {
    func didUpdateLocation(lat: Double, lon: Double) {
        print("New location received: \(lat) - \(lon)")
        provider.searchPhotoBy(latitude: lat, longitude: lon, minDate: minDate).filter({ (responseDTO) -> Bool in
            return responseDTO.photos.photos.count > 0
        }).map({ (responseDTO) -> Photo in
            return self.locationManager.nearestPhotoFrom(latitude: lat, longitude: lon, photos: responseDTO.photos.photos)
        }).subscribe(Realm.rx.add())
        .disposed(by: disposeBag)
    }
    
    func didChangeAuthorizationStatus(status: LocationStatus) {
        if status == .authorized && isPendingToStart {
            isPendingToStart = false
            locationManager.startUpdatingLocation()
            view.updateStartButton(title: "Stop")
        }
    }
}
