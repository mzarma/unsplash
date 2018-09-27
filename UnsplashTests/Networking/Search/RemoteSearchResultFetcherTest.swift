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
        
        sut.fetch(request: request) { _ in }
        
        XCTAssertEqual(client.requests, [request])
    }
    
    func test_completesWithRemoteError() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: SUT.Output?
        var callCount = 0
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }

        client.complete?(.error(.unknown))

        switch expectedResult! {
        case .error(let error): XCTAssertEqual(error, .remote)
        case .success(_): XCTFail("Should complete with error")
        }
    }
    
    func test_completesWithMappingError() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: SUT.Output?
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
    
    func test_completesWithSearchResult() {
        let sut = makeSUT(request: mockRequest())
        var expectedResult: SUT.Output?
        var callCount = 0
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }
        
        client.complete?(.success(validJSONData()))
        
        switch expectedResult! {
        case .error(_): XCTFail("Should succeed with search result")
        case .success(let searchResult): XCTAssertEqual(searchResult, expectedSearchResult())
        }
    }

    // MARK: Helpers
    
    private let client = HTTPClientStub()
    
    private let invalidJSONData = "invalid data".data(using: .utf8)!
    
    private func validJSONData() -> Data {
        return try! JSONSerialization.data(withJSONObject: validJSON)
    }
    
    private func expectedSearchResult() -> RemoteSearchResultResponse {
        let profileImageURLs = RemoteSearchResultPhotoResponse.Creator.ProfileImageURLs(small: "small profile image url", medium: "medium profile image url", large: "large profile image url")
        let creator = RemoteSearchResultPhotoResponse.Creator(identifier: "Ul0QVz12Goo", username: "ugmonk", name: "Jeff Sheldon", portfolioURLString: "portfolio url", profileImageURLs: profileImageURLs)
        let imageURLs = RemoteSearchResultPhotoResponse.ImageURLs(regular: "regular image url", small: "small image url", thumbnail: "thumbnail image url")
        let imageLinks = RemoteSearchResultPhotoResponse.ImageLinks(download: "download link")
        let photos = [RemoteSearchResultPhotoResponse(identifier: "eOLpJytrbsQ", dateCreatedString: "2014-11-18T14:35:36-05:00", width: 4000, height: 3000, colorString: "#A7A2A1", description: "A man drinking a coffee.", creator: creator, imageURLs: imageURLs, imageLinks: imageLinks)]
        return RemoteSearchResultResponse(totalPhotos: 133, totalPages: 7, photos: photos)
    }
    
    private typealias SUT = RemoteSearchResultFetcher
    
    private func makeSUT(request: URLRequest) -> RemoteSearchResultFetcher {
        let sut = RemoteSearchResultFetcher(client: client)
        weakSUT = sut
        return sut
    }
        
    private let validJSON: [String: Any] =
        [
            "total": 133,
            "total_pages": 7,
            "results": [
                [
                    "id": "eOLpJytrbsQ",
                    "created_at": "2014-11-18T14:35:36-05:00",
                    "width": 4000,
                    "height": 3000,
                    "color": "#A7A2A1",
                    "likes": 286,
                    "liked_by_user": false,
                    "description": "A man drinking a coffee.",
                    "user": [
                        "id": "Ul0QVz12Goo",
                        "username": "ugmonk",
                        "name": "Jeff Sheldon",
                        "first_name": "",
                        "last_name": "",
                        "instagram_username": "",
                        "twitter_username": "",
                        "portfolio_url": "portfolio url",
                        "profile_image": [
                            "small": "small profile image url",
                            "medium": "medium profile image url",
                            "large": "large profile image url"
                        ],
                        "links": [
                            "self": "",
                            "html": "",
                            "photos": "",
                            "likes": ""
                        ]
                    ],
                    "current_user_collections": [],
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
                        "download": "download link"
                    ]
                ]
            ]
    ]
}
