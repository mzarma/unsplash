//
//  RemotePhotoFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum PhotoFetcherResult {
    case success(Data)
    case error
}

protocol PhotoFetcher {
    associatedtype Request
    
    func fetch(request: Request, completion: @escaping (PhotoFetcherResult) -> Void)
}

final class RemotePhotoFetcher: PhotoFetcher {
    typealias Request = URLRequest

    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }

    func fetch(request: URLRequest, completion: @escaping (PhotoFetcherResult) -> Void) {
        client.execute(request) { result in
            switch result {
            case .success(let data): completion(.success(data))
            case .error(_): completion(.error)
            }
        }
    }
}
