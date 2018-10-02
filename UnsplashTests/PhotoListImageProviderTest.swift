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
    
    func test_CompletesWithNil_whenInvalidThumbnailURL() {
        var fetchImageCount = 0
        var expectedImage: UIImage?
        let photo = corePhoto(thumbnailURLString: "")
        let sut = makeSUT()
        
        sut.fetchImage(for: photo) { image in
            fetchImageCount += 1
            expectedImage = image
        }
        
        XCTAssertEqual(fetchImageCount, 1)
        XCTAssertNil(expectedImage)
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> PhotoListImageProvider {
        let sut = PhotoListImageProvider()
        weakSUT = sut
        return sut
    }
}
