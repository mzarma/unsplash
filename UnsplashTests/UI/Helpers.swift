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

extension RandomPhotoDetailViewController {
    func numberOfRows() -> Int {
        return tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0)
    }
    
    func imageCell() -> ImageCell {
        return tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath(for: 0)) as! ImageCell
    }
    
    func descriptionCell() -> UITableViewCell {
        return tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath(for: 1))
    }
    
    func dateCreatedCell() -> UITableViewCell {
        return tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath(for: 2))
    }

    func creatorNameCell() -> UITableViewCell {
        return tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath(for: 3))
    }

    func creatorPortfolioURLCell() -> UITableViewCell {
        return tableView.dataSource!.tableView(tableView, cellForRowAt: indexPath(for: 4))
    }
    
    func indexPath(for row: Int) -> IndexPath {
        return IndexPath(row: row, section: 0)
    }
}

extension PhotoListViewController {
    func numberOfItems() -> Int {
        return collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func noPhotoCell() -> NoPhotoCell {
        return collectionView.dataSource!.collectionView(collectionView, cellForItemAt: indexPath(for: 0)) as! NoPhotoCell
    }
    
    func photoCell(for item: Int) -> PhotoCell {
        return collectionView.dataSource!.collectionView(collectionView, cellForItemAt: indexPath(for: item)) as! PhotoCell
    }
    
    func selectItem(_ item: Int) {
        collectionView.delegate!.collectionView!(collectionView, didSelectItemAt: indexPath(for: item))
    }
    
    func indexPath(for item: Int) -> IndexPath {
        return IndexPath(item: item, section: 0)
    }
}

extension SearchViewController {
    func clickSearchButton(with term: String) {
        searchBar.text = term
        searchBar.delegate!.searchBarSearchButtonClicked!(searchBar)
    }
}

func presentableRandomPhoto(identifier: String = "", dateCreated: String = "", description: String = "", creatorName: String = "", creatorPortfolioURLString: String = "", regularImageURLString: String = "") -> PresentableRandomPhoto {
    return PresentableRandomPhoto(
        identifier: identifier,
        dateCreated: dateCreated,
        width: 0,
        height: 0,
        colorString: "",
        description: description,
        creatorIdentifier: "",
        creatorUsername: "",
        creatorName: creatorName,
        creatorPortfolioURLString: creatorPortfolioURLString,
        regularImageURLString: regularImageURLString,
        smallImageURLString: "",
        thumbnailImageURLString: "",
        downloadImageLink: ""
    )
}

func coreRandomPhoto(
    dateCreated: Date = Date(timeIntervalSince1970: 946684800),
    description: String = "",
    creatorName: String = "",
    creatorPortfolioURLString: String = "",
    regularImageURLString: String = "") -> CoreRandomPhoto {
    return CoreRandomPhoto(
        identifier: "an identifier",
        dateCreated: dateCreated,
        width: 150,
        height: 150,
        colorString: "a color string",
        description: description,
        creatorIdentifier: "creator identifier",
        creatorUsername: "creator username",
        creatorName: creatorName,
        creatorPortfolioURLString: creatorPortfolioURLString,
        regularImageURLString: regularImageURLString,
        smallImageURLString: "smallImageURLString",
        thumbnailImageURLString: "thumbnailImageURLString",
        downloadImageLink: "downloadImageLink")
}

func presentablePhoto(identifier: String = "", dateCreated: String = "2000-01-01T00:00:00Z", description: String = "", creatorName: String = "", creatorPortfolioURLString: String = "", regularImageURLString: String = "") -> PresentablePhoto {
    return PresentablePhoto(
        identifier: identifier,
        dateCreated: dateCreated,
        width: 0,
        height: 0,
        colorString: "",
        description: description,
        creatorIdentifier: "",
        creatorUsername: "",
        creatorName: creatorName,
        creatorPortfolioURLString:
        creatorPortfolioURLString,
        creatorSmallProfileImageURLString: nil,
        creatorMediumProfileImageURLString: nil,
        creatorLargeProfileImageURLString: nil,
        regularImageURLString: regularImageURLString,
        smallImageURLString: "",
        thumbnailImageURLString: "",
        downloadImageLink: ""
    )
}

func corePhoto(identifier: String = "", dateCreated: Date = Date(timeIntervalSince1970: 946684800), description: String = "", thumbnailURLString: String = "") -> CorePhoto {
    return CorePhoto(
        identifier: identifier,
        dateCreated: dateCreated,
        width: 0,
        height: 0,
        colorString: "",
        description: description,
        creatorIdentifier: "",
        creatorUsername: "",
        creatorName: "",
        creatorPortfolioURLString: "",
        creatorSmallProfileImageURLString: "",
        creatorMediumProfileImageURLString: "",
        creatorLargeProfileImageURLString: "",
        regularImageURLString: "",
        smallImageURLString: "",
        thumbnailImageURLString: thumbnailURLString,
        downloadImageLink: ""
    )
}

func testImage(width: Int = 20, height: Int = 20) -> UIImage {
    UIGraphicsBeginImageContext(CGSize(width: 20, height: 20))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
