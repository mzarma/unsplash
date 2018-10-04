//
//  PhotoListImageProvider.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 02/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol ImageProvider {
    func fetchImage(for photo: CorePhoto, completion: @escaping (Result<UIImage, ImageProviderError>) -> Void)
}

enum ImageProviderError: Error {
    case invalidURL
    case remote
    case invalidImageData
}

final class PhotoListImageProvider<F: PhotoFetcher>: ImageProvider where F.Request == URLRequest, F.Response == Result<Data, PhotoFetcherError> {
    
    typealias Output = Result<UIImage, ImageProviderError>
    
    private let fetcher: F
    
    init(_ fetcher: F) {
        self.fetcher = fetcher
    }
    
    func fetchImage(for photo: CorePhoto, completion: @escaping (Output) -> Void) {
        guard let url = URL(string: photo.thumbnailImageURLString) else {
            return completion(.error(.invalidURL))
        }
        
        fetcher.fetch(request: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                   return completion(.error(.invalidImageData))
                }
                completion(.success(image))
            case .error(_): completion(.error(.remote))
            }
        }
    }
}
