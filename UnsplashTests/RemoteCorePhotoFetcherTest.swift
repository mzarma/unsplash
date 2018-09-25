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
        
        searchResultFetcher.complete?(.error(.httpClient))
        
        switch expectedResult! {
        case .success(_): XCTFail("Should complete with httpClient error")
        case .error(let error): XCTAssertEqual(error, .httpClient)
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
