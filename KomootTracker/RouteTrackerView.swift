//
//  ViewController.swift
//  KomootTracker
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit

class RouteTrackerView: UIViewController, RouteTrackerViewProtocol {
    
    @IBOutlet var startButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    fileprivate var presenter: RouteTrackerPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RouteTrackerPresenter(view: self)
        presenter?.viewDidLoad()
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
