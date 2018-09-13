//
//  RemoteRandomPhotoResultFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 11/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum RemoteRandomResultFetcherError: Error {
    case httpClient
    case mapping
}

protocol RandomPhotoResultFetcher {
    associatedtype Result
    
    func fetch(_ completion: @escaping (Result) -> Void)
}

final class RemoteRandomPhotoResultFetcher: RandomPhotoResultFetcher {
    typealias Output = Result<RemoteRandomPhotoResponse, RemoteRandomResultFetcherError>
    
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
                    completion(.error(.mapping))
                }
            case .error(_): completion(.error(.httpClient))
            }
        }
    }
    
    static private func map(data: Data) -> RemoteRandomPhotoResponse? {
        return try? JSONDecoder().decode(RemoteRandomPhotoResponse.self, from: data)
    }
}
