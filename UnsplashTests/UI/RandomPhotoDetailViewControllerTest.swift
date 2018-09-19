//
//  RandomPhotoDetailViewControllerTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 19/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RandomPhotoDetailViewControllerTest: XCTestCase {
    private weak var weakSUT: RandomPhotoDetailViewController?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    // MARK: Layout
    
    func test_tableViewIsViewChild() {
        let sut = makeSUT()
        XCTAssertTrue(sut.tableView.superview === sut.view)
    }
    
        // MARK: UICollectionViewDataSource
    
    func test_numberOfRowsInSection() {
        XCTAssertEqual(makeSUT().numberOfRows(), 5)
    }
    
    func test_rendersImageCell() {
        let sut = makeSUT()
        let cell = sut.imageCell()
        
        XCTAssertEqual(cell.photoImage?.pngData(), testImage().pngData())
    }
    
    // MARK: Helpers
    
    private func makeSUT(photo: PresentableRandomPhoto = presentableRandomPhoto(), image: UIImage = testImage()) -> RandomPhotoDetailViewController {
        let dataSourceDelegate = RandomPhotoDetailDataSourceDelegate(
            photo: photo,
            image: image
        )
        
        let sut = RandomPhotoDetailViewController(
            dataSource: dataSourceDelegate,
            delegate: dataSourceDelegate
        )
        
        weakSUT = sut
        sut.loadViewIfNeeded()
        return sut
    }
}
