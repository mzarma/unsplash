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
    
    // MARK: UICollectionViewDataSource
    
    func test_numberOfItemsInSectionIsEqualToOne() {
        let sut = makeSUT()
        let collectionView = sut.collectionView
        XCTAssertEqual(collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0), 1)
    }

    func test_cellForItemAtIndexpath() {
        let image = UIImage()
        let description = "a description"
        let photo = PresentablePhoto(image: image, description: description)
        let sut = makeSUT(photo: photo)
        let collectionView = sut.collectionView
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.dataSource!.collectionView(collectionView, cellForItemAt: indexPath) as! PhotoCell
        
        XCTAssertEqual(cell.photoImage, image)
        XCTAssertEqual(cell.text, description)
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func test_triggersPhotoSelection() {
        let image = UIImage()
        let description = "a description"
        let photo = PresentablePhoto(image: image, description: description)

        var callCount = 0
        var expectedPhoto: PresentablePhoto?
        
        let sut = makeSUT(photo: photo) { photo in
            callCount += 1
            expectedPhoto = photo
        }
        let collectionView = sut.collectionView
        
        collectionView.delegate!.collectionView!(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(expectedPhoto?.image, image)
        XCTAssertEqual(expectedPhoto?.description, description)
    }

    
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
        sut.loadViewIfNeeded()
        return sut
    }
}
