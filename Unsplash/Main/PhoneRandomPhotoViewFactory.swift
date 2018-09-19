//
//  PhoneRandomPhotoViewFactory.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 13/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

enum PhotoFetcherError: Error {
    case remote
}

final class PhoneRandomPhotoViewFactory<R: RandomPhotoResultFetcher, P: PhotoFetcher>: RandomPhotoViewFactory where R.Result == Result<CoreRandomPhoto, RandomPhotoResultFetcherError>, P.Request == URLRequest, P.Response == Result<Data,PhotoFetcherError>  {
    
    private let randomPhotoFetcher: R
    private let photoFetcher: P
    
    init(_ randomPhotoFetcher: R, _ photoFetcher: P) {
        self.randomPhotoFetcher = randomPhotoFetcher
        self.photoFetcher = photoFetcher
    }
    
    func makeRandomPhotoView(_ selected: @escaping (CoreRandomPhoto, UIImage) -> Void) -> UIViewController {
        var detailImage: UIImage?
        let dataSourceDelegate = RandomPhotoDataSourceDelegate(noPhotoText: "No photo") { presentablePhoto in
            guard let image = detailImage else { return }
            let photo = RandomPhotoPresenter.corePhoto(from: presentablePhoto)
            selected(photo, image)
        }
        
        let viewController = RandomPhotoViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)

        randomPhotoFetcher.fetch { result in
            switch result {
            case .success(let photo):
                guard let url = URL(string: photo.regularImageURLString) else { return }
                let request = URLRequest(url: url)
                self.photoFetcher.fetch(request: request) { result in
                    switch result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else { return }
                        dataSourceDelegate.photo = RandomPhotoPresenter.presentablePhoto(from: photo)
                        dataSourceDelegate.image = image
                        detailImage = image
                        DispatchQueue.main.async {
                            viewController.collectionView.reloadData()
                        }
                    case .error(_): break
                    }
                }
            case .error(_): break
            }
        }
        return viewController
    }
}
