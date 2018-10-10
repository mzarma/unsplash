//
//  PhonePhotoDetailViewFactory.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 10/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhonePhotoDetailViewFactory: PhotoDetailViewFactory {
    private let imageProvider: ImageProvider
    
    init(imageProvider: ImageProvider) {
        self.imageProvider = imageProvider
    }
    
    func makePhotoDetailView(for photo: CorePhoto) -> UIViewController {
        let photo = PhotoPresenter.presentablePhoto(from: photo)
        let dataSourceDelegate = PhotoDetailDataSourceDelegate(photo: photo, imageProvider: imageProvider)
        let photoDetailView = PhotoDetailViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
        return photoDetailView
    }
}
