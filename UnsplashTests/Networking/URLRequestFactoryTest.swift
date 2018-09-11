//
//  URLRequestFactoryTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 03/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class URLRequestFactoryTest: XCTestCase {
    
    // Search URLRequest
    
    func test_createsSearchURLRequest_withGetHTTPMethod() {
        let request = SUT.search(parameters: params())

        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func test_createsSearchURLRequest_withCorrectPath() {
        let request = SUT.search(parameters: params())

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.unsplash.com")
        XCTAssertEqual(request.url?.path, "/search/photos")
    }
    
    func test_createsSearchURLRequest_withCorrectQueryItems() {
        let params1 = params(page: 4, term: "a term")
        let request1 = SUT.search(parameters: params1)
        
        let params2 = params(page: 2, term: "anotherTerm")
        let request2 = SUT.search(parameters: params2)
        
        XCTAssertEqual(request1.url?.query, "page=4&query=a%20term&client_id=\(accessKey)")
        XCTAssertEqual(request2.url?.query, "page=2&query=anotherTerm&client_id=\(accessKey)")
    }
    
    // Random URLRequest
    
    func test_createsRandomRequest_withGetHTTPMethod() {
        let request = SUT.random()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func test_createsRandomURLRequest_withCorrectPath() {
        let request = SUT.random()

        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "api.unsplash.com")
        XCTAssertEqual(request.url?.path, "/photos/random")
    }

    func test_createsRandomURLRequest_withCorrectQueryItems() {
        let request = SUT.random()

        XCTAssertEqual(request.url?.query, "client_id=\(accessKey)")
    }
    
    // MARK: Helpers
    
    private typealias SUT = URLRequestFactory

    private func params(page: Int = 1, term: String = "term") -> SearchParameters {
        return SearchParameters(page: page, term: term)
    }
    
    private var accessKey: String {
        return NSDictionary(
            contentsOfFile: Bundle
                .main
                .path(forResource: "Info", ofType: "plist")!)!["AccessKey"] as! String
    }
}
