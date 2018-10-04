//
//  PresentableRandomPhoto.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 19/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct PresentableRandomPhoto: Equatable {
    let identifier: String
    let dateCreated: String
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

extension PresentableRandomPhoto {
    var coreRandomPhoto: CoreRandomPhoto {
        return CoreRandomPhoto(
            identifier: identifier,
            dateCreated: ISO8601DateFormatter().date(from: dateCreated)!,
            width: width,
            height: height,
            colorString: colorString,
            description: description,
            creatorIdentifier: creatorIdentifier,
            creatorUsername: creatorUsername,
            creatorName: creatorName,
            creatorPortfolioURLString: creatorPortfolioURLString,
            regularImageURLString: regularImageURLString,
            smallImageURLString: smallImageURLString,
            thumbnailImageURLString: thumbnailImageURLString,
            downloadImageLink: downloadImageLink
        )
    }
}
