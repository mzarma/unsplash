//
//  PresentablePhoto.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

struct PresentablePhoto: Equatable {
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
    let creatorSmallProfileImageURLString: String?
    let creatorMediumProfileImageURLString: String?
    let creatorLargeProfileImageURLString: String?
    let regularImageURLString: String
    let smallImageURLString: String
    let thumbnailImageURLString: String
    let downloadImageLink: String
    let thumbnailImage: UIImage
}
