//
//  PhotoDownloaderTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhotoDownloaderTest: XCTestCase {
    private weak var weakSUT: PhotoDownloader?
    
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
        var expectedResult: SUT.Output?
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
        var expectedResult: SUT.Output?
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

    private typealias SUT = PhotoDownloader
    
    private func makeSUT(request: URLRequest) -> PhotoDownloader {
        let sut = PhotoDownloader(client: client)
        weakSUT = sut
        return sut
    }
}
