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
    func startButtonPressed()
}

class RouteTrackerPresenter: RouteTrackerPresenterProtocol {
    private weak var view: RouteTrackerViewProtocol?
    private let provider: FlickrServiceProtocol
    private let locationManager: LocationManagerProtocol
    
    let disposeBag = DisposeBag()
    var isPendingToStart = false
    
    //Fetch images taken in the latests 6 months
    let minDate = Date().addingTimeInterval(-3600*24*30*6).timeIntervalSince1970
    
    init(view: RouteTrackerViewProtocol,
         provider: FlickrServiceProtocol = FlickrService(provider: MoyaProvider<SearchEndpoint>()),
         locationManager: LocationManagerProtocol = LocationManager()) {
        self.view = view
        self.provider = provider
        self.locationManager = locationManager
        self.locationManager.delegate = self
    }
    
    func startButtonPressed() {
        if locationManager.isTrackingLocation {
            locationManager.stopUpdatingLocation()
            view?.updateStartButton(title: "Start")
        } else {
            switch locationManager.locationStatus() {
            case .notDetermined:
                isPendingToStart = true
                locationManager.requestLocationPermission()
            case .notEnabled:
                isPendingToStart = false
                view?.showEnableLocationServiesAlert()
            case .rejected:
                isPendingToStart = false
                view?.showAuthorizeLocationServiesAlert()
            case .authorized:
                isPendingToStart = false
                cleanDataBase()
                locationManager.startUpdatingLocation()
                view?.updateStartButton(title: "Stop")
            }
        }
    }
    
    private func cleanDataBase() {
        guard let realm = try? Realm() else { return }
        let photos = realm.objects(Photo.self)
        do {
            try realm.write {
                realm.delete(photos)
            }
        } catch { }
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
            view?.updateStartButton(title: "Stop")
        }
    }
}
