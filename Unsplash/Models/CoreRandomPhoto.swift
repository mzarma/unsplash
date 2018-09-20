//
//  CoreRandomPhoto.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 17/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct CoreRandomPhoto: Equatable {
    let identifier: String
    let dateCreated: Date
    let width: Int
    let height: Int
    let colorString: String
    let description: String
    let creatorIdentifier: String
    let creatorUsername: String
    let creatorName: String
    let creatorPortfolioURLString: String?
    let regularImageURLString: String
    let smallImageURLString: String
    let thumbnailImageURLString: String
    let downloadImageLink: String
}
