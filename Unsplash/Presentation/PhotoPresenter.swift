//
//  PhotoPresenter.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 27/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhotoPresenter {
    private static let dateFormatter = ISO8601DateFormatter()
    static func presentablePhoto(from photo: CorePhoto) -> PresentablePhoto {
        return PresentablePhoto(
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
            creatorSmallProfileImageURLString: photo.creatorSmallProfileImageURLString,
            creatorMediumProfileImageURLString: photo.creatorMediumProfileImageURLString,
            creatorLargeProfileImageURLString: photo.creatorLargeProfileImageURLString,
            regularImageURLString: photo.regularImageURLString,
            smallImageURLString: photo.smallImageURLString,
            thumbnailImageURLString: photo.thumbnailImageURLString,
            downloadImageLink: photo.downloadImageLink
        )
    }
    
    static func corePhoto(from photo: PresentablePhoto) -> CorePhoto {
        return CorePhoto(
            identifier: photo.identifier,
            dateCreated: dateFormatter.date(from: photo.dateCreated)!,
            width: photo.width,
            height: photo.height,
            colorString: photo.colorString,
            description: photo.description,
            creatorIdentifier: photo.creatorIdentifier,
            creatorUsername: photo.creatorUsername,
            creatorName: photo.creatorName,
            creatorPortfolioURLString: photo.creatorPortfolioURLString,
            creatorSmallProfileImageURLString: photo.creatorSmallProfileImageURLString,
            creatorMediumProfileImageURLString: photo.creatorMediumProfileImageURLString,
            creatorLargeProfileImageURLString: photo.creatorLargeProfileImageURLString,
            regularImageURLString: photo.regularImageURLString,
            smallImageURLString: photo.smallImageURLString,
            thumbnailImageURLString: photo.thumbnailImageURLString,
            downloadImageLink: photo.downloadImageLink
        )
    }
}
