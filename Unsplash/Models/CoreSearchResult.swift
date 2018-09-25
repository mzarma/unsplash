//
//  CoreSearchResult.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct CoreSearchResult: Equatable {
    let totalPhotos: Int
    let totalPages: Int
    let photos: [CorePhoto]
}

