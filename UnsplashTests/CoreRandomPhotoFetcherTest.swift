//
//  CoreRandomPhotoFetcherTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 17/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class CoreRandomPhotoFetcherTest: XCTestCase {
    private weak var weakSUT: SUT?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_completesWithError_whenRandomPhotoResultFetcherCompletesWithError() {
        let sut = makeSUT()
        var expectedResult: SUT.Output?
        
        sut.fetch { result in
            expectedResult = result
        }
        
        randomPhotoFetcher.complete?(.error(.remote))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail with error")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithMappingError_whenInvalidDateString() {
        let sut = makeSUT()
        var expectedResult: SUT.Output?
        
        sut.fetch { result in
            expectedResult = result
        }
        
        randomPhotoFetcher.complete?(.success(randomPhotoResponse(dateCreatedString: "invalid date string")))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        switch expectedResult! {
        case .success(_): XCTFail("Should fail with mapping error")
        case .error(let error): XCTAssertEqual(error, .mapping)
        }
    }
    
    func test_completesWithCoreRandomPhoto_whenRandomPhotoResultFetcherCompletesWithSuccess() {
        let sut = makeSUT()
        var expectedResult: SUT.Output?
        
        sut.fetch { result in
            expectedResult = result
        }
        
        randomPhotoFetcher.complete?(.success(randomPhotoResponse(dateCreatedString: "2016-05-03T11:00:28-04:00")))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        switch expectedResult! {
        case .success(let result): XCTAssertEqual(result, expectedCoreRandomPhoto())
        case .error(_): XCTFail("Should succeed with CoreRandomPhoto")
        }
    }
    
    // MARK: Helpers
    
    private let randomPhotoFetcher = RandomPhotoResultFetcherSpy()
    private typealias SUT = CoreRandomPhotoFetcher<RandomPhotoResultFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = CoreRandomPhotoFetcher(randomPhotoFetcher)
        weakSUT = sut
        return sut
    }
    
    private func randomPhotoResponse(dateCreatedString: String) -> RemoteRandomPhotoResponse {
        let creator = RemoteRandomPhotoResponse.Creator(
            identifier: "creator identifier",
            username: "creator username",
            name: "creator name",
            portfolioURLString: "creator portfolio url string"
        )
        let imageURLs = RemoteRandomPhotoResponse.ImageURLs(
            regular: "image regular url",
            small: "image small url",
            thumbnail: "image thumbnail url"
        )
        let imageLinks = RemoteRandomPhotoResponse.ImageLinks(download: "image download link")
        
        return RemoteRandomPhotoResponse(
            identifier: "identifier",
            dateCreatedString: dateCreatedString,
            width: 120,
            height: 150,
            colorString: "color",
            description: "description",
            creator: creator,
            imageURLs: imageURLs,
            imageLinks: imageLinks
        )
    }
    
    private func expectedCoreRandomPhoto() -> CoreRandomPhoto {
        return CoreRandomPhoto(
            identifier: "identifier",
            dateCreated: ISO8601DateFormatter().date(from: "2016-05-03T11:00:28-04:00")!,
            width: 120,
            height: 150,
            colorString: "color",
            description: "description",
            creatorIdentifier: "creator identifier",
            creatorUsername: "creator username",
            creatorName: "creator name",
            creatorPortfolioURLString: "creator portfolio url string",
            regularImageURLString: "image regular url",
            smallImageURLString: "image small url",
            thumbnailImageURLString: "image thumbnail url",
            downloadImageLink: "image download link"
        )
    }
    
    private class RandomPhotoResultFetcherSpy: RandomPhotoResultFetcher {
        var fetchCallCount = 0
        var complete: ((Result) -> Void)?
        
        func fetch(_ completion: @escaping (Result<RemoteRandomPhotoResponse, RandomPhotoResultFetcherError>) -> Void) {
            fetchCallCount += 1
            complete = completion
        }
    }
}
