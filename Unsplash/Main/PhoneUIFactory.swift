//
//  PhoneUIFactory.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 13/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

enum RandomPhotoFetcherResultError: Error {
    case fetching
}

enum PhotoFetcherError: Error {
    case fetching
}

protocol RandomPhotoViewFactory {
    func makeRandomPhotoView(_ selected: @escaping (PresentablePhoto) -> Void) -> UIViewController
}

final class PhoneUIFactory<R: RandomPhotoResultFetcher, P: PhotoFetcher>: RandomPhotoViewFactory where R.Result == Result<GeneralPhoto, RandomPhotoFetcherResultError>, P.Request == URLRequest, P.Response == Result<Data,PhotoFetcherError>  {
    
    private let randomPhotoFetcher: R
    private let photoFetcher: P
    
    init(_ randomPhotoFetcher: R, _ photoFetcher: P) {
        self.randomPhotoFetcher = randomPhotoFetcher
        self.photoFetcher = photoFetcher
    }
    
    func makeRandomPhotoView(_ selected: @escaping (PresentablePhoto) -> Void) -> UIViewController {
        let dataSourceDelegate = RandomPhotoDataSourceDelegate(noPhotoText: "No photo") { photo in
            selected(photo)
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
                        dataSourceDelegate.photo = PresentablePhoto(description: photo.description)
                        dataSourceDelegate.image = image
                    case .error(_): break
                    }
                }
            case .error(_): break
            }
        }
        return viewController
    }
}
