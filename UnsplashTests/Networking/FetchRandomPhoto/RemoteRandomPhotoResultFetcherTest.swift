//
//  RemoteRandomPhotoResultFetcherTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 11/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RemoteRandomPhotoResultFetcherTest: XCTestCase {
    private weak var weakSUT: RemoteRandomPhotoResultFetcher?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_hasClientThatExecutesCorrectRequest() {
        let sut = makeSUT()

        sut.fetch { _ in }

        XCTAssertEqual(client.requests, [URLRequestFactory.random()])
    }

    func test_completesWithHTTPClientError() {
        let sut = makeSUT()
        var expectedResult: SUT.Output?
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

    func test_completesWithMappingError() {
        let sut = makeSUT()
        var expectedResult: SUT.Output?
        var callCount = 0
        sut.fetch { result in
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
        let sut = makeSUT()
        var expextedResult: SUT.Output?
        var callCount = 0
        sut.fetch { result in
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
    
    private func expectedPhoto() -> RemoteRandomPhotoResponse {
        let creator = RemoteRandomPhotoResponse.Creator(identifier: "QPxL2MGqfrw", username: "exampleuser", name: "Joe Example", portfolioURLString: "https://example.com/")
        let imageURLs = RemoteRandomPhotoResponse.ImageURLs(regular: "regular image url", small: "small image url", thumbnail: "thumbnail image url")
        let imageLinks = RemoteRandomPhotoResponse.ImageLinks(download: "download link")
        return RemoteRandomPhotoResponse(identifier: "Dwu85P9SOIk", dateCreatedString: "2016-05-03T11:00:28-04:00", width: 2448, height: 3264, colorString: "#6E633A", description: "A man drinking a coffee.", creator: creator, imageURLs: imageURLs, imageLinks: imageLinks)
    }
    
    private typealias SUT = RemoteRandomPhotoResultFetcher
    
    private func makeSUT() -> RemoteRandomPhotoResultFetcher {
        let sut = RemoteRandomPhotoResultFetcher(client: client)
        weakSUT = sut
        return sut
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
