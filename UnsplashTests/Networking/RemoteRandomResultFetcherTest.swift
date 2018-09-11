//
//  RemoteRandomResultFetcherTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 11/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RemoteRandomResultFetcherTest: XCTestCase {
    private weak var weakSUT: RemoteRandomResultFetcher?
    
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

    func test_completesWithHTTPClientError() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: RemoteRandomResultFetcherResult?
        var callCount = 0
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }

        client.complete?(.error(.unknown))

        switch expectedResult! {
        case .error(let error): XCTAssertEqual(error, .httpClient)
        case .success(_): XCTFail("Should complete with error")
        }
    }

    func test_completesWithMappingError() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: RemoteRandomResultFetcherResult?
        var callCount = 0
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }

        client.complete?(.success(invalidJSONData))

        switch expectedResult! {
        case .error(let error): XCTAssertEqual(error, .mapping)
        case .success(_): XCTFail("Should complete with error")
        }
    }

    func test_completesWithRemoteRandomPhoto() {
        let sut = makeSUT(request: mockRequest())
        var expextedResult: RemoteRandomResultFetcherResult?
        var callCount = 0
        sut.fetch(request: mockRequest()) { result in
            expextedResult = result
            callCount += 1
        }

        client.complete?(.success(validJSONData()))

        switch expextedResult! {
        case .error(_): XCTFail("Should succeed with remote random photo")
        case .success(let photo): XCTAssertEqual(photo, expectedPhoto())
        }
    }
    
    // MARK: Helpers
    
    private let client = HTTPClientStub()
    
    private let invalidJSONData = "invalid data".data(using: .utf8)!
    
    private func validJSONData() -> Data {
        return try! JSONSerialization.data(withJSONObject: validJSON)
    }
    
    private func expectedPhoto() -> RemotePhotoResponse {
        let creator = RemotePhotoResponse.Creator(identifier: "QPxL2MGqfrw", username: "exampleuser", name: "Joe Example", portfolioURLString: "https://example.com/", imageURLs: nil)
        let imageURLs = RemotePhotoResponse.ImageURLs(regular: "regular image url", small: "small image url", thumbnail: "thumbnail image url")
        let imageLinks = RemotePhotoResponse.ImageLinks(download: "download link")
        return RemotePhotoResponse(identifier: "Dwu85P9SOIk", dateCreatedString: "2016-05-03T11:00:28-04:00", width: 2448, height: 3264, colorString: "#6E633A", description: "A man drinking a coffee.", creator: creator, imageURLs: imageURLs, imageLinks: imageLinks)
    }
    
    private func makeSUT(request: URLRequest) -> RemoteRandomResultFetcher {
        let sut = RemoteRandomResultFetcher(client: client)
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
    
    private let validJSON: [String: Any] =
    [
        "id": "Dwu85P9SOIk",
        "created_at": "2016-05-03T11:00:28-04:00",
        "updated_at": "",
        "width": 2448,
        "height": 3264,
        "color": "#6E633A",
        "downloads": 1345,
        "likes": 24,
        "liked_by_user": false,
        "description": "A man drinking a coffee.",
        "urls": [
            "raw": "",
            "full": "",
            "regular": "regular image url",
            "small": "small image url",
            "thumb": "thumbnail image url"
        ],
        "links": [
            "self": "",
            "html": "",
            "download": "download link",
            "download_location": ""
        ],
        "user": [
            "id": "QPxL2MGqfrw",
            "updated_at": "2016-07-10T11:00:01-05:00",
            "username": "exampleuser",
            "name": "Joe Example",
            "portfolio_url": "https://example.com/",
            "bio": "Just an everyday Joe",
            "location": "Montreal",
            "total_likes": 5,
            "total_photos": 10,
            "total_collections": 13,
        ]
    ]
}
