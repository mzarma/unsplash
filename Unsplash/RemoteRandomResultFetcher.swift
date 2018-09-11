//
//  RemoteRandomResultFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 11/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum RemoteRandomResultFetcherError {
    case httpClient
    case mapping
}

enum RemoteRandomResultFetcherResult {
    case success(RemoteRandomPhoto)
    case error(RemoteRandomResultFetcherError)
}

protocol RandomResultFetcher {
    associatedtype Request
    associatedtype Result
    
    func fetch(request: Request, completion: @escaping (Result) -> Void)
}

final class RemoteRandomResultFetcher: RandomResultFetcher {
    typealias Request = URLRequest
    typealias Result = RemoteRandomResultFetcherResult
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(request: URLRequest, completion: @escaping (RemoteRandomResultFetcherResult) -> Void) {
        client.execute(request) { result in
            switch result {
            case .success(let data):
                if let photo = RemoteRandomResultFetcher.map(data: data) {
                    completion(.success(photo))
                } else {
                    completion(.error(.mapping))
                }
            case .error(_): completion(.error(.httpClient))
            }
        }
    }
    
    static private func map(data: Data) -> RemoteRandomPhoto? {
        return try? JSONDecoder().decode(RemoteRandomPhoto.self, from: data)
    }
}
