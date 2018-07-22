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
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int //TODO map to ispublic
    let isFriend: Int //TODO map to isfriend
    let isFamily: Int //TODO map to isfamily
    var imageURL: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

struct SearchPhotoDTO: Decodable {
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    let photos: [PhotoDTO] //TODO map to photo
}
