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
