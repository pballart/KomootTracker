//
//  ViewController.swift
//  KomootTracker
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm
import RealmSwift
import AlamofireImage

class RouteTrackerView: UIViewController, RouteTrackerViewProtocol {
    
    @IBOutlet var startButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    fileprivate var presenter: RouteTrackerPresenterProtocol?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RouteTrackerPresenter(view: self)
        tableView.register(UINib(nibName: "RouteTrackerCell", bundle: nil), forCellReuseIdentifier: "RouteTrackerCellIdentifier")
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        guard let realm = try? Realm() else { return }
        let photos = realm.objects(Photo.self).sorted(byKeyPath: "fetchDate", ascending: false)
        Observable.collection(from: photos)
            .bind(to: tableView.rx.items(cellIdentifier: "RouteTrackerCellIdentifier")) { (row, photo: Photo, cell: RouteTrackerCell) in
                guard let imageURL = URL(string: photo.url) else { return }
                cell.photoImageView.af_setImage(withURL: imageURL)
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func startRoute(_ sender: UIBarButtonItem) {
        presenter?.startButtonPressed()
    }
    
    func updateStartButton(title: String) {
        startButton.title = title
    }
    
    func showEnableLocationServiesAlert() {
        let alert = UIAlertController(title: "Enable location",
                                      message: "This app needs location services to be enabled.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAuthorizeLocationServiesAlert() {
        let alert = UIAlertController(title: "Enable location",
                                      message: "This app needs to be always authorized to use location services.",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension RouteTrackerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
