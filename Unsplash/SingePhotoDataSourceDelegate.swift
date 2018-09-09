//
//  SingePhotoDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 07/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

struct PresentablePhoto {
    let image: UIImage
    let description: String
}

class SinglePhotoDataSourceDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let photo: PresentablePhoto
    private let photoSelection: (PresentablePhoto) -> Void
    
    init(photo: PresentablePhoto, photoSelection: @escaping (PresentablePhoto) -> Void) {
        self.photo = photo
        self.photoSelection = photoSelection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
