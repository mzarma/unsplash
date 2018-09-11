//
//  RemotePhotoFetcherTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RemotePhotoFetcherTest: XCTestCase {
    private weak var weakSUT: RemotePhotoFetcher?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_hasClientThatExecutesCorrectRequest() {
        let request = mockRequest()
        let sut = makeSUT(request: request)
        
        sut.fetch(request: request) { _ in }
        
        XCTAssertEqual(client.requests, [request])
    }
    
    func test_completesWithError() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: PhotoFetcherResult?
        var callCount = 0
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }

        client.complete?(.error(.unknown))

        switch expectedResult! {
        case .error: XCTAssert(true)
        case .success(_): XCTFail("Should complete with error")
        }
    }
    
    func test_completesWithCorectData() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: PhotoFetcherResult?
        var callCount = 0
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }
        
        let expectedData = Data()
        client.complete?(.success(expectedData))
        
        switch expectedResult! {
        case .error: XCTFail("Should complete with success")
        case .success(let data): XCTAssertEqual(data, expectedData)
        }
    }
    
    // MARK: Helpers
    
    private let client = HTTPClientStub()

    private func makeSUT(request: URLRequest) -> RemotePhotoFetcher {
        let sut = RemotePhotoFetcher(client: client)
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
