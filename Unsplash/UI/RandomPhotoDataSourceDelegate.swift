//
//  RandomPhotoDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 07/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

struct PresentableRandomPhoto: Equatable {
    let description: String
}

final class RandomPhotoDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var photo: PresentableRandomPhoto?
    var image: UIImage?
    
    private let noPhotoText: String
    private let photoSelection: (PresentableRandomPhoto) -> Void
    
    init(noPhotoText: String, photoSelection: @escaping (PresentableRandomPhoto) -> Void) {
        self.noPhotoText = noPhotoText
        self.photoSelection = photoSelection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let photo = photo, let image = image {
            return configuredPhotoCell(collectionView, at: indexPath, image: image, description: photo.description)
        }
        
        return configuredNoPhotoCell(collectionView, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = photo, image != nil else { return }
        photoSelection(photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    private func configuredPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath, image: UIImage, description: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.photoImage = image
        cell.text = description
        return cell
    }
    
    private func configuredNoPhotoCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoPhotoCell", for: indexPath) as! NoPhotoCell
        cell.text = noPhotoText
        return cell
    }
}
