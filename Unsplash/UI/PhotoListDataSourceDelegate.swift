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
        return photos.count > 0 ? photos.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configuredNoPhotoCell(collectionView, at: indexPath)
    }
    
    private func configuredNoPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoPhotoCell", for: indexPath) as! NoPhotoCell
        cell.text = noPhotoText
        return cell
    }
}
