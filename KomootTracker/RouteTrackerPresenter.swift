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
    fileprivate let provider = FlickrService(provider: MoyaProvider<SearchEndpoint>())
    fileprivate var locationManager = LocationManager()
    
    var isPendingToStart = false
    let minDate = Date().addingTimeInterval(-3600*24*365).timeIntervalSince1970

    init(view: RouteTrackerViewProtocol) {
        self.view = view
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
    
    private func savePhotoToDB(_ photoDTO: PhotoDTO) {
        let photo = Photo()
        photo.loadValue(id: photoDTO.id, url: photoDTO.imageURL, fetchDate: Date())
        let realm = try! Realm()
        try! realm.write {
            realm.add(photo)
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
        provider.searchPhotoBy(latitude: lat, longitude: lon, minDate: minDate) { (result) in
            switch result {
            case .success(let searchDTO):
                guard let photo = searchDTO.photos.photos.first else { return }
                self.savePhotoToDB(photo)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didChangeAuthorizationStatus(status: LocationStatus) {
        if status == .authorized && isPendingToStart {
            isPendingToStart = false
            locationManager.startUpdatingLocation()
            view.updateStartButton(title: "Stop")
        }
    }
}
