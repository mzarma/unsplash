//
//  PhotoListDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol ImageProvider {
    func image(for identifier: String) -> UIImage?
}

final class PhotoListDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var photos = [PresentablePhoto]()
    
    private let noPhotoText: String
    private let imageProvider: ImageProvider
    private let photoSelection: (PresentablePhoto) -> Void
    
    init(noPhotoText: String, imageProvider: ImageProvider, photoSelection: @escaping (PresentablePhoto) -> Void) {
        self.noPhotoText = noPhotoText
        self.imageProvider = imageProvider
        self.photoSelection = photoSelection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count > 0 ? photos.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return photos.count > 0 ?
        configuredPhotoCell(collectionView, at: indexPath, photo: photos[indexPath.row]) :
        configuredNoPhotoCell(collectionView, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !photos.isEmpty else { return }
        photoSelection(photos[indexPath.row])
    }
    
    private func configuredPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath, photo: PresentablePhoto) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.text = photo.description
        cell.photoImage = imageProvider.image(for: photo.identifier)
        return cell
    }
    
    private func configuredNoPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoPhotoCell", for: indexPath) as! NoPhotoCell
        cell.text = noPhotoText
        return cell
    }
}
