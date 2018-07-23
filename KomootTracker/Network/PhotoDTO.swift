//
//  PhotoDTO.swift
//  KomootTracker
//
//  Created by Pau Ballart on 21/07/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation

struct PhotoDTO: Decodable {
    let id: String
    let owner: String?
    let secret: String
    let server: String
    let farm: Int
    let title: String?
    let latitude: String
    let longitude: String
    var imageURL: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    init(id: String, owner: String?, secret: String, server: String,
         farm: Int, title: String?,  latitude: String, longitude: String) {
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case latitude
        case longitude
    }
}

struct SearchPhotoDTO: Decodable {
    let page: Int?
    let pages: Int?
    let perPage: Int?
    let total: String?
    let photos: [PhotoDTO]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case total
        case photos = "photo"
    }
}

struct FlickrPhotosResponseDTO: Decodable {
    let photos: SearchPhotoDTO
    let stat: String
}
