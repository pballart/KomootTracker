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
    
    private let disposeBag = DisposeBag()
    private let globalScheduler = SerialDispatchQueueScheduler(qos: .utility)
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
    
    func bestPhotoFromResponse(responseDTO: FlickrPhotosResponseDTO, centerLocation: Location) -> Photo {
        let locations = responseDTO.photos.photos.compactMap({ (photoDTO) -> Location? in
            guard let lat = Double(photoDTO.latitude), let lon = Double(photoDTO.longitude) else { return nil }
            return (lat, lon)
        })
        guard let nearestIndex = self.locationManager.nearestLocation(locations: locations, from: centerLocation) else {
            return Photo()
        }
        let nearestPhotoDTO = responseDTO.photos.photos[nearestIndex]
        return Photo().loadValue(id: nearestPhotoDTO.id, url: nearestPhotoDTO.imageURL, fetchDate: Date())
    }
}

extension RouteTrackerPresenter: LocationManagerDelegate {
    func didUpdateLocation(lat: Double, lon: Double) {
        print("New location received: \(lat) - \(lon)")
        provider.searchPhotoBy(latitude: lat, longitude: lon, minDate: minDate)
            .filter({ (responseDTO) -> Bool in
                return responseDTO.photos.photos.count > 0
            })
            .subscribeOn(globalScheduler)
            .map({ (responseDTO) -> Photo in
                return self.bestPhotoFromResponse(responseDTO: responseDTO, centerLocation: (lat, lon))
            })
            .subscribe(Realm.rx.add())
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
