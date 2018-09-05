//
//  RemoteSearchResultFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 04/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct Photo: Equatable, Codable {
    let identifier: String
    let dateCreatedString: String
    let width: Int
    let height: Int
    let colorString: String
    let description: String
    let creator: Creator
    let imageURLs: ImageURLs
    let imageLinks: ImageLinks
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case dateCreatedString = "created_at"
        case width = "width"
        case height = "height"
        case colorString = "color"
        case description = "description"
        case creator = "user"
        case imageURLs = "urls"
        case imageLinks = "links"
    }
    
    struct Creator: Equatable, Codable {
        let identifier: String
        let username: String
        let name: String
        let portfolioURLString: String?
        let imageURLs: ImageURLs

        enum CodingKeys: String, CodingKey {
            case identifier = "id"
            case username = "username"
            case name = "name"
            case portfolioURLString = "portfolio_url"
            case imageURLs = "profile_image"
        }
        
        struct ImageURLs: Equatable, Codable {
            let smallProfileImageURLString: String?
            let mediumProfileImageURLString: String?
            let largeProfileImageURLString: String?
            
            enum CodingKeys: String, CodingKey {
                case smallProfileImageURLString = "small"
                case mediumProfileImageURLString = "medium"
                case largeProfileImageURLString = "large"
            }
        }
    }
    
    struct ImageURLs: Equatable, Codable {
        let regular: String
        let small: String
        let thumbnail: String
        
        enum CodingKeys: String, CodingKey {
            case regular = "regular"
            case small = "small"
            case thumbnail = "thumb"
        }
    }
    
    struct ImageLinks: Equatable, Codable {
        let download: String
        
        enum CodingKeys: String, CodingKey {
            case download = "download"
        }
    }
}

struct SearchResult: Equatable, Codable {
    let totalPhotos: Int
    let totalPages: Int
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case totalPhotos = "total"
        case totalPages = "total_pages"
        case photos = "results"
    }
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
                if let searchResult = RemoteSearchResultMapper.map(data: data) {
                    completion(.success(searchResult))
                } else {
                    completion(.error(.mapping))
                }
            case .error(_): completion(.error(.httpClient))
            }
        }
    }
}

final class RemoteSearchResultMapper {
    static func map(data: Data) -> SearchResult? {
        if let searchResult = try? JSONDecoder().decode(SearchResult.self, from: data) {
            return searchResult
        } else {
            return nil
        }
    }
}
