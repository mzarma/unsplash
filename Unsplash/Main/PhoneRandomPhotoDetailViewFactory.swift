//
//  PhoneRandomPhotoDetailViewFactory.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhoneRandomPhotoDetailViewFactory: RandomPhotoDetailViewFactory {
    func makeRandomPhotoDetailView(for photo: CoreRandomPhoto, image: UIImage) -> UIViewController {
        let photo = RandomPhotoPresenter.presentablePhoto(from: photo)
        let dataSourceDelegate = RandomPhotoDetailDataSourceDelegate(photo: photo, image: image)
        let viewController = RandomPhotoDetailViewController(
            dataSource: dataSourceDelegate,
            delegate: dataSourceDelegate
        )
        return viewController
    }
}
