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
    func makePhotoDetailView(for photo: CorePhoto, imageProvider: ImageProvider) -> UIViewController
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
        let photoListView = photoListViewFactory.makePhotoListView { _ in }
        navigation.setViewControllers([photoListView], animated: false)
    }
}

