//
//  RemoteCorePhotoFetcherTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RemoteCorePhotoFetcherTest: XCTestCase {
    private weak var weakSUT: SUT?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_fetcherUsesCorrectRequest() {
        let request = mockRequest()
        let sut = makeSUT()
        
        XCTAssertEqual(searchResultFetcher.fetchCallCount, 0)
        XCTAssertEqual(searchResultFetcher.requests, [])

        sut.fetch(request: request) { _ in }
        
        XCTAssertEqual(searchResultFetcher.fetchCallCount, 1)
        XCTAssertEqual(searchResultFetcher.requests, [request])
    }
    
    func test_completesWithError_whenFetcherCompletesWithError() {
        var expectedResult: SUT.Output?
        let sut = makeSUT()
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
        }
        
        searchResultFetcher.complete?(.error(.remote))
        
        switch expectedResult! {
        case .success(_): XCTFail("Should complete with remote error")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithCorrectCoreSearchResult() {
        var expectedResult: SUT.Output?
        let sut = makeSUT()
        sut.fetch(request: mockRequest()) { result in
            expectedResult = result
        }
        
        searchResultFetcher.complete?(.success(searchResult()))
        
        switch expectedResult! {
        case .success(let result):
            XCTAssertEqual(result, expectedCoreSearchResult())
        case .error(_): XCTFail("Should complete with success")
        }
    }

    // MARK: Helpers
    
    private let searchResultFetcher = SearchResultFetcherSpy()
    private typealias SUT = RemoteCorePhotoFetcher<SearchResultFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = RemoteCorePhotoFetcher(searchResultFetcher)
        weakSUT = sut
        return sut
    }
    
    private func searchResult() -> RemoteSearchResultResponse {
        let photo1 = searchResultPhoto(smallProfileImageURL: "small url", mediumProfileImageURL: "medium url", largeProfileImageURL: "large url", creatorIdentifier: "creator identifier", creatorUsername: "creator username", creatorName: "creator name", creatorPortfolioURL: "portfolio url", regularImageURL: "regular url", smallImageURL: "small url", thumbnailImageURL: "thumbnail url", downloadLink: "download link", identifier: "identifier", dateCreated: "2014-11-18T14:35:36-05:00", width: 100, height: 100, colorString: "color", description: "description")
        let photo2 = searchResultPhoto(dateCreated: "2018-10-11T13:30:24-03:00")
        let photo3 = searchResultPhoto(dateCreated: "invalid date string")
        return RemoteSearchResultResponse(
            totalPhotos: 88,
            totalPages: 11,
            photos: [photo1, photo2, photo3]
        )
    }
    
    private func searchResultPhoto(smallProfileImageURL: String = "", mediumProfileImageURL: String = "", largeProfileImageURL: String = "", creatorIdentifier: String = "", creatorUsername: String = "", creatorName: String = "", creatorPortfolioURL: String = "", regularImageURL: String = "", smallImageURL: String = "", thumbnailImageURL: String = "", downloadLink: String = "", identifier: String = "", dateCreated: String = "", width: Int = 0, height: Int = 0, colorString: String = "", description: String = "") -> RemoteSearchResultPhotoResponse {
        let profileImageURLs = RemoteSearchResultPhotoResponse.Creator.ProfileImageURLs(small: smallProfileImageURL, medium: mediumProfileImageURL, large: largeProfileImageURL)
        let creator = RemoteSearchResultPhotoResponse.Creator(identifier: creatorIdentifier, username: creatorUsername, name: creatorName, portfolioURLString: creatorPortfolioURL, profileImageURLs: profileImageURLs)
        let imageURLs = RemoteSearchResultPhotoResponse.ImageURLs(regular: regularImageURL, small: smallImageURL, thumbnail: thumbnailImageURL)
        let imageLinks = RemoteSearchResultPhotoResponse.ImageLinks(download: downloadLink)
        return RemoteSearchResultPhotoResponse(identifier: identifier, dateCreatedString: dateCreated, width: width, height: height, colorString: colorString, description: description, creator: creator, imageURLs: imageURLs, imageLinks: imageLinks)
    }
    
    private func expectedCoreSearchResult() -> CoreSearchResult {
        let photo1 = corePhoto(identifier: "identifier", dateCreated: ISO8601DateFormatter().date(from: "2014-11-18T14:35:36-05:00")!, width: 100, height: 100, colorString: "color", description: "description", creatorIdentifier: "creator identifier", creatorUsername: "creator username", creatorName: "creator name", creatorPortfolioURLString: "portfolio url", creatorSmallProfileImageURLString: "small url", creatorMediumProfileImageURLString: "medium url", creatorLargeProfileImageURLString: "large url", regularImageURLString: "regular url", smallImageURLString: "small url", thumbnailImageURLString: "thumbnail url", downloadImageLink: "download link")
        let photo2 = corePhoto(dateCreated: ISO8601DateFormatter().date(from: "2018-10-11T13:30:24-03:00")!)
        return CoreSearchResult(totalPhotos: 88, totalPages: 11, photos: [photo1, photo2])
    }
    
    private func corePhoto(identifier: String = "", dateCreated: Date, width: Int = 0, height: Int = 0, colorString: String = "", description: String = "", creatorIdentifier: String = "", creatorUsername: String = "", creatorName: String = "", creatorPortfolioURLString: String? = "", creatorSmallProfileImageURLString: String? = "", creatorMediumProfileImageURLString: String? = "", creatorLargeProfileImageURLString: String? = "", regularImageURLString: String = "", smallImageURLString: String = "", thumbnailImageURLString: String = "", downloadImageLink: String = "") -> CorePhoto {
        return CorePhoto(identifier: identifier, dateCreated: dateCreated, width: width, height: height, colorString: colorString, description: description, creatorIdentifier: creatorIdentifier, creatorUsername: creatorUsername, creatorName: creatorName, creatorPortfolioURLString: creatorPortfolioURLString, creatorSmallProfileImageURLString: creatorSmallProfileImageURLString, creatorMediumProfileImageURLString: creatorMediumProfileImageURLString, creatorLargeProfileImageURLString: creatorLargeProfileImageURLString, regularImageURLString: regularImageURLString, smallImageURLString: smallImageURLString, thumbnailImageURLString: thumbnailImageURLString, downloadImageLink: downloadImageLink)
    }
    
    private class SearchResultFetcherSpy: SearchResultFetcher {
    
        var fetchCallCount = 0
        var requests = [URLRequest]()
        var complete: ((Result) -> Void)?
        
        func fetch(request: URLRequest, completion: @escaping (Result<RemoteSearchResultResponse, SearchResultFetcherError>) -> Void) {
            fetchCallCount += 1
            requests.append(request)
            complete = completion
        }
    }
}
