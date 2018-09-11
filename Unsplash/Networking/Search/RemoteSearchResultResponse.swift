//
//  RemoteSearchResultResponse.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct RemoteSearchResultResponse: Equatable, Codable {
    let totalPhotos: Int
    let totalPages: Int
    let photos: [RemotePhotoResponse]
    
    enum CodingKeys: String, CodingKey {
        case totalPhotos = "total"
        case totalPages = "total_pages"
        case photos = "results"
    }
}
