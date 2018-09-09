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
    
    // MARK: Layout
    
    func test_collectionViewIsViewChild() {
        let sut = makeSUT()
        XCTAssertTrue(sut.collectionView.superview === sut.view)
    }
    
    // MARK: DataSource
    
    func test_numberOfItemsInSectionIsEqualToOne() {
        let sut = makeSUT()
        let collectionView = sut.collectionView
        XCTAssertEqual(collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0), 1)
    }
    
    // MARK: Delegate
    
    // MARK: Helpers
    
    private func makeSUT(photo: PresentablePhoto = PresentablePhoto(image: UIImage(), description: ""), photoSelection: @escaping (PresentablePhoto) -> Void = { _ in }) -> SinglePhotoViewController {
        let dataSourceDelegate = SinglePhotoDataSourceDelegate(
            photo: photo,
            photoSelection: photoSelection
        )
        
        let sut = SinglePhotoViewController(
            dataSource: dataSourceDelegate,
            delegate: dataSourceDelegate
        )
        
        weakSUT = sut
        _ = sut.view
        return sut
    }
}


