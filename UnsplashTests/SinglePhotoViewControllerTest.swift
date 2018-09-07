//
//  SinglePhotoViewControllerTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 07/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class SinglePhotoViewControllerTest: XCTestCase {
    private weak var weakSUT: SinglePhotoViewController?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_collectionViewIsViewChild() {
        let sut = makeSUT()
        XCTAssertTrue(sut.collectionView.superview === sut.view)
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> SinglePhotoViewController {
        let sut = SinglePhotoViewController()
        weakSUT = sut
        _ = sut.view
        return sut
    }
}


