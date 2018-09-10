//
//  URLRequestFactory.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 03/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct SearchParameters {
    let page: Int
    let term: String
}

final class URLRequestFactory {
    private static let baseURLString = "https://api.unsplash.com"
    private static let searchPhotosPath = "/search/photos"
    private static let randomPhotoPath = "/photos/random"
    private static let accessKey = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!["AccessKey"] as! String
        
    static func search(parameters: SearchParameters) -> URLRequest {
        var components = URLComponents(string: baseURLString)!
        components.path = searchPhotosPath
        
        let page = URLQueryItem(name: "page", value: String(parameters.page))
        let term =  URLQueryItem(name: "query", value: parameters.term)
        let key = URLQueryItem(name: "client_id", value: accessKey)
        components.queryItems = [page, term, key]
        
        return URLRequest(url: components.url!)
    }
    
    static func random() -> URLRequest {
        var components = URLComponents(string: baseURLString)!
        components.path = randomPhotoPath
        components.queryItems = [URLQueryItem(name: "client_id", value: accessKey)]
        
        return URLRequest(url: components.url!)
    }
}
