//
//  PhotoListImageProvider.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 02/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol ImageProvider_ {
    associatedtype Response
    
    func fetchImage(for photo: CorePhoto, completion: @escaping (Response) -> Void)
}

enum ImageProviderError: Error {
    case invalidURL
    case remote
}

final class PhotoListImageProvider<F: PhotoFetcher>: ImageProvider_ where F.Request == URLRequest, F.Response == Result<Data, PhotoFetcherError> {
    
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
            case .success(_): break
            case .error(_): completion(.error(.remote))
            }
        }
    }
}
