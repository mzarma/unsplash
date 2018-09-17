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
    
    // MARK: Helpers
    
    private let randomPhotoFetcher = RandomPhotoResultFetcherSpy()
    private typealias SUT = CoreRandomPhotoFetcher<RandomPhotoResultFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = CoreRandomPhotoFetcher(randomPhotoFetcher)
        weakSUT = sut
        return sut
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
