//
//  RandomPhotoPresenter.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 19/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class RandomPhotoPresenter {
    private static let dateFormatter = ISO8601DateFormatter()
    static func presentablePhoto(from photo: CoreRandomPhoto) -> PresentableRandomPhoto {
        return PresentableRandomPhoto(
            identifier: photo.identifier,
            dateCreated: dateFormatter.string(from: photo.dateCreated),
            width: photo.width,
            height: photo.height,
            colorString: photo.colorString,
            description: photo.description,
            creatorIdentifier: photo.creatorIdentifier,
            creatorUsername: photo.creatorUsername,
            creatorName: photo.creatorName,
            creatorPortfolioURLString: photo.creatorPortfolioURLString,
            regularImageURLString: photo.regularImageURLString,
            smallImageURLString: photo.smallImageURLString,
            thumbnailImageURLString: photo.thumbnailImageURLString,
            downloadImageLink: photo.downloadImageLink
        )
    }
}
