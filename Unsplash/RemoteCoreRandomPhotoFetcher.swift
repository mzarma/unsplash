//
//  RemoteCoreRandomPhotoFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 17/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class RemoteCoreRandomPhotoFetcher<R: RandomPhotoResultFetcher>: RandomPhotoResultFetcher where R.Result == Result<RemoteRandomPhotoResponse, RandomPhotoResultFetcherError> {
    typealias Output = Result<CoreRandomPhoto, RandomPhotoResultFetcherError>
    
    private let fetcher: R
    
    init(_ fetcher: R) {
        self.fetcher = fetcher
    }
    
    func fetch(_ completion: @escaping (Output) -> Void) {
        fetcher.fetch { [weak self] result in
            guard let sSelf = self else { return }
            switch result {
            case .success(let response):
                guard let mappedResponse = sSelf.map(response) else {
                    return completion(.error(.mapping))
                }
                completion(.success(mappedResponse))
            case .error(let error): completion(.error(error))
            }
        }
    }
    
    private func map(_ response: RemoteRandomPhotoResponse) -> CoreRandomPhoto? {
        guard let dateCreated = ISO8601DateFormatter().date(from: response.dateCreatedString) else { return nil }
        return CoreRandomPhoto(
            identifier: response.identifier,
            dateCreated: dateCreated,
            width: response.width,
            height: response.height,
            colorString: response.colorString,
            description: response.description,
            creatorIdentifier: response.creator.identifier,
            creatorUsername: response.creator.username,
            creatorName: response.creator.name,
            creatorPortfolioURLString: response.creator.portfolioURLString,
            regularImageURLString: response.imageURLs.regular,
            smallImageURLString: response.imageURLs.small,
            thumbnailImageURLString: response.imageURLs.thumbnail,
            downloadImageLink: response.imageLinks.download
        )
    }
}
