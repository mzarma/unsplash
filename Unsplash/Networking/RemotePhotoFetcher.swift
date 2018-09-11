//
//  RemotePhotoFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum RemotePhotoFetcherError: Error {
    case network
}

protocol PhotoFetcher {
    associatedtype Request
    associatedtype Response
    
    func fetch(request: Request, completion: @escaping (Response) -> Void)
}

final class RemotePhotoFetcher: PhotoFetcher {
    typealias Input = URLRequest
    typealias Output = Result<Data, RemotePhotoFetcherError>
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }

    func fetch(request: Input, completion: @escaping (Output) -> Void) {
        client.execute(request) { result in
            switch result {
            case .success(let data): completion(.success(data))
            case .error(_): completion(.error(.network))
            }
        }
    }
}
