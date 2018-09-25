//
//  PhotoListDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhotoListDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var photos = [PresentablePhoto]()
    
    private let noPhotoText: String
    private let photoSelection: (PresentablePhoto) -> Void
    
    init(noPhotoText: String, photoSelection: @escaping (PresentablePhoto) -> Void) {
        self.noPhotoText = noPhotoText
        self.photoSelection = photoSelection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return -1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
