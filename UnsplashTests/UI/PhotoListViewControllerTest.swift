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
    
    // MARK: UICollectionViewDataSource
    
    func test_numberOfItemsInSection() {
        XCTAssertEqual(makeSUT(photos: []).numberOfItems(), 1)
        XCTAssertEqual(makeSUT(photos: [presentablePhoto(), presentablePhoto(), presentablePhoto()]).numberOfItems(), 3)
    }
    
    func test_showsNoPhotoCell_whenPhotosArrayIsEmpty() {
        let sut = makeSUT(photos: [], noPhotoText: "No Photos")
        
        let cell = sut.noPhotoCell()
        
        XCTAssertEqual(cell.text, "No Photos")
    }
    
    func test_photoCellForItemAtIndexpath() {
        let image1 = testImage(width: 100, height: 100)
        let photo1 = presentablePhoto(description: "description1", thumbnailImage: image1)
        let image2 = testImage(width: 200, height: 200)
        let photo2 = presentablePhoto(description: "description2", thumbnailImage: image2)
        let sut = makeSUT(photos: [photo1, photo2])
    
        let cell1 = sut.photoCell(for: 0)
        let cell2 = sut.photoCell(for: 1)
    
        XCTAssertEqual(cell1.photoImage, image1)
        XCTAssertEqual(cell1.text, "description1")
        XCTAssertEqual(cell2.photoImage, image2)
        XCTAssertEqual(cell2.text, "description2")
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
