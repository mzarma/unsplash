//
//  BasicImageProviderTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 02/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class BasicImageProviderTest: XCTestCase {
    private weak var weakSUT: SUT?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        super.tearDown()
    }
    
    func test_CompletesWithInvalidURLError() {
        var fetchImageCount = 0
        var expectedResult: SUT.Output?

        fetchImage(for: "") { result in
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
        
        fetchImage(for: urlString)
        
        XCTAssertEqual(fetcher.requests, [URLRequest(url: URL(string: "https://a-mock-url.com")!)])
    }
    
    func test_completesWithRemoteError() {
        var fetchImageCount = 0
        var expectedResult: SUT.Output?

        fetchImage(for: "https://a-mock-url.com") { result in
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
        
        fetchImage(for: "https://a-mock-url.com") { result in
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
    
    func test_completesWithCachedImage() {
        var expectedResult: SUT.Output?

        var fetchCallCount = 0
        let sut = makeSUT()
        sut.fetchImage(for: "https://a-mock-url.com") { result in
            expectedResult = result
            fetchCallCount += 1
        }
        
        let expectedImageData = testImage().pngData()!
        fetcher.complete?(.success(expectedImageData))
        
        XCTAssertEqual(fetchCallCount, 1)
        XCTAssertEqual(fetcher.requests.count, 1)
        assertSuccess(
            expectedResult!,
            expectedImageData,
            "Should succeed with image data")
        
        sut.fetchImage(for: "https://a-mock-url.com") { result in
            expectedResult = result
            fetchCallCount += 1
        }
        
        XCTAssertEqual(fetchCallCount, 2)
        XCTAssertEqual(fetcher.requests.count, 1)
        assertSuccess(
            expectedResult!,
            expectedImageData,
            "Should succeed without invoking again the fetcher")
    }

    // MARK: Helpers
    
    private let fetcher = PhotoFetcherSpy()
    private typealias SUT = BasicImageProvider<PhotoFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = BasicImageProvider(fetcher)
        weakSUT = sut
        return sut
    }
    
    private func fetchImage(for urlString: String, completion: @escaping (SUT.Output) -> Void = { _ in }) {
        let sut = makeSUT()
        sut.fetchImage(for: urlString, completion: completion)
    }
    
    private func assertSuccess(_ result: Result<UIImage, ImageProviderError>, _ imageData: Data, _ message: String) {
        switch result {
        case .success(let image): XCTAssertEqual(image.pngData(), imageData)
        case .error(_): XCTFail("Should succeed without invoking again the fetcher")
        }
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
