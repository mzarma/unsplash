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
    private weak var weakSUT: PhotoListImageProvider?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        super.tearDown()
    }
    
    func test_returnsNIL() {
        _ = makeSUT()
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> PhotoListImageProvider {
        let sut = PhotoListImageProvider()
        weakSUT = sut
        return sut
    }
}
