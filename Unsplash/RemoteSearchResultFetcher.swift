//
//  RemoteSearchResultFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 04/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let identifier: String
    let dateCreated: Date
    let width: Int
    let height: Int
    let colorString: String
    let description: String
    let creator: Creator
    let regularImageURLString: String
    let smallImageURLString: String
    let thumbnailImageURLString: String
    let downloadImageLink: String
    
    struct Creator: Codable {
        let identifier: String
        let username: String
        let name: String
        let portfolioURLString: String
        let smallProfileImageURLString: String
        let mediumProfileImageURLString: String
        let largeProfileImageURLString: String
        let creatorPhotosURLString: String
    }
}

struct SearchResult: Codable {
    let totalPhotos: Int
    let totalPages: Int
    let photos: [Photo]
}

enum RemoteSearchResultFetcherError {
    case httpClient
    case mapping
}

enum RemoteSearchResultFetcherResult {
    case success(SearchResult)
    case error(RemoteSearchResultFetcherError)
}

protocol SearchResultFetcher {
    associatedtype Request
    associatedtype Result
    
    func fetch(request: Request, completion: @escaping (Result) -> Void)
}

final class RemoteSearchResultFetcher: SearchResultFetcher {
    typealias Request = URLRequest
    typealias Result = RemoteSearchResultFetcherResult
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(request: URLRequest, completion: @escaping (RemoteSearchResultFetcherResult) -> Void) {
        client.execute(request) { result in
            switch result {
            case .success(let data):
                do {
                    _ = try JSONSerialization.jsonObject(with: data)
                } catch {
                    completion(.error(.mapping))
                }
            case .error(_): completion(.error(.httpClient))
            }
        }
    }
}
