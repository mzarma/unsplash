//
//  PhotoListFlow.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 10/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol PhotoListViewFactory {
    func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController
}

protocol PhotoDetailViewFactory {
    func makePhotoDetailView(for photo: CorePhoto) -> UIViewController
}

final class PhotoListFlow {
    private let navigation: UINavigationController
    private let photoListViewFactory: PhotoListViewFactory
    private let photoDetailViewFactory: PhotoDetailViewFactory
    
    init(navigation: UINavigationController, photoListViewFactory: PhotoListViewFactory, photoDetailViewFactory: PhotoDetailViewFactory) {
        self.navigation = navigation
        self.photoListViewFactory = photoListViewFactory
        self.photoDetailViewFactory = photoDetailViewFactory
    }
    
    func start() {
        let photoListView = photoListViewFactory.makePhotoListView { [weak self] photo in
            guard let self = self else { return }
            let photoDetailView = self.photoDetailViewFactory.makePhotoDetailView(for: photo)
            self.navigation.pushViewController(photoDetailView, animated: true)
        }
        navigation.setViewControllers([photoListView], animated: false)
    }
}

