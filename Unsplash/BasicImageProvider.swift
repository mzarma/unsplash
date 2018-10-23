//
//  BasicImageProvider.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 02/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol ImageProvider {
    func fetchImage(for urlString: String, completion: @escaping (Result<UIImage, ImageProviderError>) -> Void)
}

enum ImageProviderError: Error {
    case invalidURL
    case remote
    case invalidImageData
}

final class BasicImageProvider<F: PhotoFetcher>: ImageProvider where F.Request == URLRequest, F.Response == Result<Data, PhotoFetcherError> {
    
    typealias Output = Result<UIImage, ImageProviderError>
    
    private let fetcher: F
    private var cache = Dictionary<String, UIImage>()
    
    init(_ fetcher: F) {
        self.fetcher = fetcher
    }
    
    func fetchImage(for urlString: String, completion: @escaping (Output) -> Void) {
        if let image = cache[urlString] {
            return completion(.success(image))
        }
        
        guard let url = URL(string: urlString) else {
            return completion(.error(.invalidURL))
        }
        
        fetcher.fetch(request: URLRequest(url: url)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                   return completion(.error(.invalidImageData))
                }
                self?.cache[urlString] = image
                completion(.success(image))
            case .error(_): completion(.error(.remote))
            }
        }
    }
}
