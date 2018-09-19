//
//  Helpers.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 13/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit
@testable import Unsplash

extension RandomPhotoViewController {
    func numberOfItems() -> Int {
        return collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func noPhotoCell() -> NoPhotoCell {
        return collectionView.dataSource!.collectionView(collectionView, cellForItemAt: onlyCell) as! NoPhotoCell
    }
    
    func photoCell() -> PhotoCell {
        return collectionView.dataSource!.collectionView(collectionView, cellForItemAt: onlyCell) as! PhotoCell
    }
    
    func selectItem() {
        collectionView.delegate!.collectionView!(collectionView, didSelectItemAt: onlyCell)
    }
    
    var onlyCell: IndexPath {
        return IndexPath(item: 0, section: 0)
    }
}

func presentableRandomPhoto(description: String = "", regularImageURLString: String = "") -> PresentableRandomPhoto {
    return PresentableRandomPhoto(
        identifier: "",
        dateCreated: "",
        width: 0,
        height: 0,
        colorString: "",
        description: description,
        creatorIdentifier: "",
        creatorUsername: "",
        creatorName: "",
        creatorPortfolioURLString: "",
        regularImageURLString: regularImageURLString,
        smallImageURLString: "",
        thumbnailImageURLString: "",
        downloadImageLink: ""
    )
}

func coreRandomPhoto(
    description: String = "",
    regularImageURLString: String = "") -> CoreRandomPhoto {
    return CoreRandomPhoto(
        identifier: "an identifier",
        dateCreated: Date(timeIntervalSince1970: 946684800),
        width: 150,
        height: 150,
        colorString: "a color string",
        description: description,
        creatorIdentifier: "creator identifier",
        creatorUsername: "creator username",
        creatorName: "creator name",
        creatorPortfolioURLString: "portfolioURLString",
        regularImageURLString: regularImageURLString,
        smallImageURLString: "smallImageURLString",
        thumbnailImageURLString: "thumbnailImageURLString",
        downloadImageLink: "downloadImageLink")
}
