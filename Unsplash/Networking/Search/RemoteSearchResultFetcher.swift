//
//  RemoteSearchResultFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 04/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum RemoteSearchResultFetcherError: Error {
    case httpClient
    case mapping
}

protocol SearchResultFetcher {
    associatedtype Request
    associatedtype Result
    
    func fetch(request: Request, completion: @escaping (Result) -> Void)
}

final class RemoteSearchResultFetcher: SearchResultFetcher {
    typealias Input = URLRequest
    typealias Output = Result<RemoteSearchResultResponse, RemoteSearchResultFetcherError>

    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(request: Input, completion: @escaping (Output) -> Void) {
        client.execute(request) { result in
            switch result {
            case .success(let data):
                if let searchResult = RemoteSearchResultFetcher.map(data: data) {
                    completion(.success(searchResult))
                } else {
                    completion(.error(.mapping))
                }
            case .error(_): completion(.error(.httpClient))
            }
        }
    }
    
    static private func map(data: Data) -> RemoteSearchResultResponse? {
        return try? JSONDecoder().decode(RemoteSearchResultResponse.self, from: data) 
    }
}
