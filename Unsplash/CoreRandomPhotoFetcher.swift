//
//  CoreRandomPhotoFetcher.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 17/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class CoreRandomPhotoFetcher<R: RandomPhotoResultFetcher>: RandomPhotoResultFetcher where R.Result == Result<RemoteRandomPhotoResponse, RandomPhotoResultFetcherError> {
    typealias Output = Result<CoreRandomPhoto, RandomPhotoResultFetcherError>
    
    private let fetcher: R
    
    init(_ fetcher: R) {
        self.fetcher = fetcher
    }
    
    func fetch(_ completion: @escaping (Output) -> Void) {
        fetcher.fetch { result in
            switch result {
            case .success(_): break
            case .error(let error): completion(.error(error))
            }
        }
    }
}
