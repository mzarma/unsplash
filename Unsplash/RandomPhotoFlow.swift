//
//  RandomPhotoFlow.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 18/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol RandomPhotoViewFactory {
    func makeRandomPhotoView(_ selected: @escaping (CoreRandomPhoto) -> Void) -> UIViewController
}

protocol RandomPhotoDetailViewFactory {
    func makeRandomPhotoDetailView(for photo: CoreRandomPhoto) -> UIViewController
}

final class RandomPhotoFlow {
    private let navigationController: UINavigationController
    private let photoViewFactory: RandomPhotoViewFactory
    private let photoDetailViewFactory: RandomPhotoDetailViewFactory
    
    init(navigationController: UINavigationController,
         photoViewFactory: RandomPhotoViewFactory,
         photoDetailViewFactory: RandomPhotoDetailViewFactory) {
        self.navigationController = navigationController
        self.photoViewFactory = photoViewFactory
        self.photoDetailViewFactory = photoDetailViewFactory
    }
    
    func start() {
        let photoView = photoViewFactory.makeRandomPhotoView { [weak self] photo in
            guard let sSelf = self else { return }
            let photoDetailView = sSelf.photoDetailViewFactory.makeRandomPhotoDetailView(for: photo)
            sSelf.navigationController.pushViewController(photoDetailView, animated: true)
        }
        navigationController.setViewControllers([photoView], animated: false)
    }
}
