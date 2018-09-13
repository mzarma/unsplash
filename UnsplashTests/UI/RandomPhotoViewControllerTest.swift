//
//  RandomPhotoViewControllerTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 07/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RandomPhotoViewControllerTest: XCTestCase {
    private weak var weakSUT: RandomPhotoViewController?
    
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
        XCTAssertEqual(makeSUT().numberOfItems(), 1)
    }
    
    func test_showsNoPhotoCell_whenNoPresentablePhoto() {
        let sut = makeSUT(photo: nil, image: UIImage(), noPhotoText: "No Photos")
        
        let cell = sut.noPhotoCell()
        
        XCTAssertEqual(cell.text, "No Photos")
    }
    
    func test_showsNoPhotoCell_whenNoImage() {
        let photo = PresentablePhoto(description: "")
        let sut = makeSUT(photo: photo, image: nil, noPhotoText: "No Photos")
        
        let cell = sut.noPhotoCell()
        
        XCTAssertEqual(cell.text, "No Photos")
    }

    func test_photoCellForItemAtIndexpath() {
        let image = UIImage()
        let photo = PresentablePhoto(description: "a description")
        let sut = makeSUT(photo: photo, image: image)

        let cell = sut.photoCell()
        
        XCTAssertEqual(cell.photoImage, image)
        XCTAssertEqual(cell.text, "a description")
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func test_doesNotTriggerPhotoSelection_whenNoPresentablePhoto() {
        var callCount = 0
        let sut = makeSUT(photo: nil, image: UIImage()) { _ in callCount += 1 }
        
        XCTAssertEqual(callCount, 0)
        
        sut.selectItem()
        
        XCTAssertEqual(callCount, 0)
    }
    
    func test_doesNotTriggerPhotoSelection_whenNoImage() {
        var callCount = 0
        let photo = PresentablePhoto(description: description)
        let sut = makeSUT(photo: photo, image: nil) { _ in callCount += 1 }
        
        XCTAssertEqual(callCount, 0)
        
        sut.selectItem()

        XCTAssertEqual(callCount, 0)
    }
    
    func test_triggersPhotoSelection() {
        var callCount = 0
        var expectedPhoto: PresentablePhoto?
        let photo = PresentablePhoto(description: "a description")
        
        let sut = makeSUT(photo: photo, image: UIImage()) { photo in
            callCount += 1
            expectedPhoto = photo
        }
        
        XCTAssertEqual(callCount, 0)

        sut.selectItem()

        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(expectedPhoto, photo)
    }
    
    // MARK: Helpers
        
    private func makeSUT(photo: PresentablePhoto? = nil, image: UIImage? = nil, noPhotoText: String = "", photoSelection: @escaping (PresentablePhoto) -> Void = { _ in }) -> RandomPhotoViewController {
        let dataSourceDelegate = RandomPhotoDataSourceDelegate(
            noPhotoText: noPhotoText,
            photoSelection: photoSelection
        )
        
        dataSourceDelegate.photo = photo
        dataSourceDelegate.image = image
        
        let sut = RandomPhotoViewController(
            dataSource: dataSourceDelegate,
            delegate: dataSourceDelegate
        )
        
        weakSUT = sut
        sut.loadViewIfNeeded()
        return sut
    }
}
