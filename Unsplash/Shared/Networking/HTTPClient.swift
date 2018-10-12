//
//  HTTPClient.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 03/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum HTTPClientError: Error {
    case badRequest
    case server
    case unknown
}

class HTTPClient {
    typealias Input = URLRequest
    typealias Output = Result<Data, HTTPClientError>
    
    private let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    func execute(_ request: Input, completion: @escaping (Output) -> Void) {
        print("[HTTPClient execute request: \(request.url!.absoluteString)]")
        session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if let data = data, response.statusCode > 199, response.statusCode < 300 {
                    completion(.success(data))
                } else if response.statusCode > 399 && response.statusCode < 500 {
                    completion(.error(.badRequest))
                } else if response.statusCode > 499 && response.statusCode < 600 {
                    completion(.error(.server))
                } else {
                    completion(.error(.unknown))
                }
            } else {
                completion(.error(.unknown))
            }
        }
        .resume()
    }
}
