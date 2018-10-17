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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    private func configuredPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath, photo: PresentablePhoto) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomPhotoCell", for: indexPath) as! RandomPhotoCell
        cell.text = photo.description
        imageProvider.fetchImage(for: photo.thumbnailImageURLString) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.photoImage = image
                }
            case .error(_): break
            }
        }
        return cell
    }
    
    private func configuredNoPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoPhotoCell", for: indexPath) as! NoPhotoCell
        cell.text = noPhotoText
        return cell
    }
}
