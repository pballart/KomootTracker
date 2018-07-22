//
//  Photo.swift
//  KomootTracker
//
//  Created by Pau Ballart on 22/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var fetchDate: Date = Date(timeIntervalSince1970: 1)
    
    func loadValue(id: String, url: String, fetchDate: Date) -> Photo {
        self.id = id
        self.url = url
        self.fetchDate = fetchDate
        return self
    }
}
