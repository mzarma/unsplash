//
//  PhotoListImageProviderTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 02/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhotoListImageProviderTest: XCTestCase {
    private weak var weakSUT: SUT?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        super.tearDown()
    }
    
    func test_CompletesWithInvalidURLError() {
        var fetchImageCount = 0
        var expectedResult: SUT.Output?

        fetchImage(for: corePhoto(thumbnailURLString: "")) { result in
            fetchImageCount += 1
            expectedResult = result
        }
        
        XCTAssertEqual(fetchImageCount, 1)
        
        switch expectedResult! {
        case .success: XCTFail("Should fail with invalidURLError")
        case .error(let error): XCTAssertEqual(error, .invalidURL)
        }
    }
    
    func test_fetcherFetchesWithCorrectRequest() {
        let urlString = "https://a-mock-url.com"
        
        XCTAssertEqual(fetcher.requests, [])
        
        fetchImage(for: corePhoto(thumbnailURLString: urlString))
        
        XCTAssertEqual(fetcher.requests, [URLRequest(url: URL(string: "https://a-mock-url.com")!)])
    }
    
    func test_completesWithRemoteError() {
        var fetchImageCount = 0
        var expectedResult: SUT.Output?

        fetchImage(for: corePhoto(thumbnailURLString: "https://a-mock-url.com")) { result in
            fetchImageCount += 1
            expectedResult = result
        }

        fetcher.complete?(.error(.remote))

        XCTAssertEqual(fetchImageCount, 1)
        
        switch expectedResult! {
        case .success: XCTFail("Should fail with remoteError")
        case .error(let error): XCTAssertEqual(error, .remote)
        }
    }
    
    func test_completesWithInvalidImageDataError() {
        var fetchImageCount = 0
        var expectedResult: SUT.Output?
        
        fetchImage(for: corePhoto(thumbnailURLString: "https://a-mock-url.com")) { result in
            fetchImageCount += 1
            expectedResult = result
        }
        
        fetcher.complete?(.success(Data()))
        
        XCTAssertEqual(fetchImageCount, 1)
        
        switch expectedResult! {
        case .success: XCTFail("Should fail with invalidImageDataError")
        case .error(let error): XCTAssertEqual(error, .invalidImageData)
        }
    }
    
    // MARK: Helpers
    
    private let fetcher = PhotoFetcherSpy()
    private typealias SUT = PhotoListImageProvider<PhotoFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = PhotoListImageProvider(fetcher)
        weakSUT = sut
        return sut
    }
    
    private func fetchImage(for photo: CorePhoto, completion: @escaping (SUT.Output) -> Void = { _ in }) {
        let sut = makeSUT()
        sut.fetchImage(for: photo, completion: completion)
    }
    
    private class PhotoFetcherSpy: PhotoFetcher {
        var requests = [URLRequest]()
        var complete: ((Result<Data, PhotoFetcherError>) -> Void)?
        
        func fetch(request: URLRequest, completion: @escaping (Result<Data, PhotoFetcherError>) -> Void) {
            requests.append(request)
            complete = completion
        }
    }
}
