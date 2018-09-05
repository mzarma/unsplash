//
//  SearchResult.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct SearchResult: Equatable, Codable {
    let totalPhotos: Int
    let totalPages: Int
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case totalPhotos = "total"
        case totalPages = "total_pages"
        case photos = "results"
    }
}
