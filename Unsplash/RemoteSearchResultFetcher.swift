//
//  RemoteSearchResultFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 04/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct PhotoCreator: Codable {
    let identifier: String
    let username: String
    let name: String
    let portfolioURLString: String
    let smallProfileImageURLString: String
    let mediumProfileImageURLString: String
    let largeProfileImageURLString: String
    let creatorPhotosURLString: String
}

struct Photo: Codable {
    let identifier: String
    let dateCreated: Date
    let width: Int
    let height: Int
    let colorString: String
    let description: String
    let photoCreator: PhotoCreator
    let regularImageURLString: String
    let smallImageURLString: String
    let thumbnailImageURLString: String
    let downloadImageLink: String
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

class RemoteSearchResultFetcher {
    private let client: HTTPClient
    private let request: URLRequest
    
    init(client: HTTPClient, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    func fetch(completion: @escaping (RemoteSearchResultFetcherResult) -> Void) {
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
