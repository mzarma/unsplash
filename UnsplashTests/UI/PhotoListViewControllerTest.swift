//
//  PhotoListViewControllerTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhotoListViewControllerTest: XCTestCase {
    private weak var weakSUT: PhotoListViewController?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    // MARK: Layout
    
    func test_collectionViewIsViewChild() {
        let sut = makeSUT()
        XCTAssertTrue(sut.collectionView.superview === sut.view)
    }
        
    // MARK: Helpers
    
    private func makeSUT(photos: [PresentablePhoto] = [], noPhotoText: String = "", photoSelection: @escaping (PresentablePhoto) -> Void = { _ in }) -> PhotoListViewController {
        let dataSourceDelegate = PhotoListDataSourceDelegate(
            noPhotoText: noPhotoText,
            photoSelection: photoSelection
        )
        
        dataSourceDelegate.photos = photos
        
        let sut = PhotoListViewController(
            dataSource: dataSourceDelegate,
            delegate: dataSourceDelegate
        )
        
        weakSUT = sut
        sut.loadViewIfNeeded()
        return sut
    }
}
