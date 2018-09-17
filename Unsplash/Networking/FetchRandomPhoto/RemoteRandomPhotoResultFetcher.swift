//
//  RemoteRandomPhotoResultFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 11/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum RandomPhotoResultFetcherError: Error {
    case remote
}

protocol RandomPhotoResultFetcher {
    associatedtype Result
    
    func fetch(_ completion: @escaping (Result) -> Void)
}

final class RemoteRandomPhotoResultFetcher: RandomPhotoResultFetcher {
    typealias Output = Result<RemoteRandomPhotoResponse, RandomPhotoResultFetcherError>
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(_ completion: @escaping (Output) -> Void) {
        client.execute(URLRequestFactory.random()) { result in
            switch result {
            case .success(let data):
                if let photo = RemoteRandomPhotoResultFetcher.map(data: data) {
                    completion(.success(photo))
                } else {
                    completion(.error(.remote))
                }
            case .error(_): completion(.error(.remote))
            }
        }
    }
    
    static private func map(data: Data) -> RemoteRandomPhotoResponse? {
        return try? JSONDecoder().decode(RemoteRandomPhotoResponse.self, from: data)
    }
}
