//
//  RemoteCorePhotoFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class RemoteCorePhotoFetcher<S: SearchResultFetcher>: SearchResultFetcher where S.Request == URLRequest, S.Result == Result<RemoteSearchResultResponse, SearchResultFetcherError> {
    typealias Output = Result<CorePhoto, SearchResultFetcherError>
    
    private let fetcher: S
    
    init(_ fetcher: S) {
        self.fetcher = fetcher
    }
    
    func fetch(request: S.Request, completion: @escaping (Output) -> Void) {
        fetcher.fetch(request: request) { result in
            switch result {
            case .success(_): break
            case .error(let error): completion(.error(error))
            }
        }
    }
}
