//
//  RemoteCorePhotoFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class RemoteCorePhotoFetcher<S: SearchResultFetcher>: SearchResultFetcher where S.Request == URLRequest, S.Result == Result<RemoteSearchResultResponse, SearchResultFetcherError> {
    typealias Output = Result<CoreSearchResult, SearchResultFetcherError>
    
    private let fetcher: S
    
    init(_ fetcher: S) {
        self.fetcher = fetcher
    }
    
    func fetch(request: S.Request, completion: @escaping (Output) -> Void) {
        fetcher.fetch(request: request) { result in
                switch result {
            case .success(let response): completion(.success(RemoteCorePhotoFetcher.map(response)))
            case .error(let error): completion(.error(error))
            }
        }
    }
    
    private static func map(_ response: RemoteSearchResultResponse) -> CoreSearchResult {
        return CoreSearchResult(totalPhotos: response.totalPhotos, totalPages: response.totalPages, photos: response.photos.compactMap { map($0) })
    }
    
    private static func map(_ photo: RemoteSearchResultPhotoResponse) -> CorePhoto? {
        guard let date = ISO8601DateFormatter().date(from: photo.dateCreatedString) else { return nil }
        return CorePhoto(
            identifier: photo.identifier,
            dateCreated: date,
            width: photo.width,
            height: photo.height,
            colorString: photo.colorString,
            description: photo.description,
            creatorIdentifier: photo.creator.identifier,
            creatorUsername: photo.creator.username,
            creatorName: photo.creator.name,
            creatorPortfolioURLString: photo.creator.portfolioURLString,
            creatorSmallProfileImageURLString: photo.creator.profileImageURLs?.small,
            creatorMediumProfileImageURLString: photo.creator.profileImageURLs?.medium,
            creatorLargeProfileImageURLString: photo.creator.profileImageURLs?.large,
            regularImageURLString: photo.imageURLs.regular,
            smallImageURLString: photo.imageURLs.small,
            thumbnailImageURLString: photo.imageURLs.thumbnail,
            downloadImageLink: photo.imageLinks.download
        )
    }
}
