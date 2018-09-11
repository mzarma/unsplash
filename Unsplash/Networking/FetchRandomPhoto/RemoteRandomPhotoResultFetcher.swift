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

protocol RandomResultFetcher {
    associatedtype Request
    associatedtype Result
    
    func fetch(request: Request, completion: @escaping (Result) -> Void)
}

final class RemoteRandomPhotoResultFetcher: RandomResultFetcher {
    typealias Input = URLRequest
    typealias Output = Result<RemotePhotoResponse, RemoteRandomResultFetcherError>
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(request: Input, completion: @escaping (Output) -> Void) {
        client.execute(request) { result in
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
    
    static private func map(data: Data) -> RemotePhotoResponse? {
        return try? JSONDecoder().decode(RemotePhotoResponse.self, from: data)
    }
}
