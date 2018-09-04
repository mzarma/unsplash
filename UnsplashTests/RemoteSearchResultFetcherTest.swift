//
//  RemoteSearchResultFetcherTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 04/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RemoteSearchResultFetcherTest: XCTestCase {
    private weak var weakSUT: RemoteSearchResultFetcher?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_hasClientThatExecutesCorrectRequest() {
        let request = mockRequest()
        let sut = makeSUT(request: request)
        
        sut.fetch { _ in }
        
        XCTAssertEqual(client.requests, [request])
    }
    
    func test_completesWithHTTPClientError() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: RemoteSearchResultFetcherResult?
        var callCount = 0
        sut.fetch { result in
            expectedResult = result
            callCount += 1
        }

        client.complete?(.error(.unknown))

        switch expectedResult! {
        case .error(let error): XCTAssertEqual(error, .httpClient)
        case .success(_): XCTFail("Should complete with error")
        }
    }
        
    // MARK: Helpers
    
    private let client = HTTPClientStub()
    
    private let invalidJSONData = "invalid data".data(using: .utf8)!
    
    private func makeSUT(request: URLRequest) -> RemoteSearchResultFetcher {
        let sut = RemoteSearchResultFetcher(client: client, request: request)
        weakSUT = sut
        return sut
    }
    
    private func mockRequest() -> URLRequest {
        return URLRequest(url: mockURL())
    }
    
    private func mockURL() -> URL {
        return URL(string: "https://a-mock.url")!
    }
    
    private class HTTPClientStub: HTTPClient {
        convenience init() {
            self.init(URLSession.shared)
        }
        
        var requests = [URLRequest]()
        var complete: ((HTTPClientResult) -> Void)?
        
        override func execute(_ request: URLRequest, completion: @escaping (HTTPClientResult) -> Void) {
            requests.append(request)
            complete = completion
        }
    }
}
