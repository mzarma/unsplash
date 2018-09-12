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
        let sut = makeSUT()
        let collectionView = sut.collectionView
        XCTAssertEqual(collectionView.dataSource!.collectionView(collectionView, numberOfItemsInSection: 0), 1)
    }
    
    func test_showsNoPhotoCell_whenNoPresentablePhoto() {
        let image = UIImage()
        let noPhotoText = "No Photos"
        let sut = makeSUT(with: nil, image: image, noPhotoText: noPhotoText)
        let collectionView = sut.collectionView
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.dataSource!.collectionView(collectionView, cellForItemAt: indexPath) as! NoPhotoCell
        
        XCTAssertEqual(cell.text, noPhotoText)
    }
    
    func test_showsNoPhotoCell_whenNoImage() {
        let photo = PresentablePhoto(description: description)
        let noPhotoText = "No Photos"
        let sut = makeSUT(with: photo, image: nil, noPhotoText: noPhotoText)
        let collectionView = sut.collectionView
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.dataSource!.collectionView(collectionView, cellForItemAt: indexPath) as! NoPhotoCell
        
        XCTAssertEqual(cell.text, noPhotoText)
    }

    func test_photoCellForItemAtIndexpath() {
        let image = UIImage()
        let description = "a description"
        let photo = PresentablePhoto(description: description)
        let sut = makeSUT(with: photo, image: image)
        let collectionView = sut.collectionView
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = collectionView.dataSource!.collectionView(collectionView, cellForItemAt: indexPath) as! PhotoCell
        
        XCTAssertEqual(cell.photoImage, image)
        XCTAssertEqual(cell.text, description)
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func test_doesNotTriggerPhotoSelection_whenNoPresentablePhoto() {
        let image = UIImage()
        var callCount = 0
        
        let sut = makeSUT(with: nil, image: image) { photo in
            callCount += 1
        }
        
        let collectionView = sut.collectionView
        collectionView.delegate!.collectionView!(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(callCount, 0)
    }
    
    func test_doesNotTriggerPhotoSelection_whenNoImage() {
        let photo = PresentablePhoto(description: description)
        var callCount = 0
        
        let sut = makeSUT(with: photo, image: nil) { photo in
            callCount += 1
        }
        
        let collectionView = sut.collectionView
        collectionView.delegate!.collectionView!(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(callCount, 0)
    }
    
    func test_triggersPhotoSelection() {
        let description = "a description"
        let photo = PresentablePhoto(description: description)
        let image = UIImage()

        var callCount = 0
        var expectedPhoto: PresentablePhoto?
        
        let sut = makeSUT(with: photo, image: image) { photo in
            callCount += 1
            expectedPhoto = photo
        }
        let collectionView = sut.collectionView
        
        collectionView.delegate!.collectionView!(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(expectedPhoto?.description, description)
    }

    
    // MARK: Helpers
        
    private func makeSUT(with photo: PresentablePhoto? = nil, image: UIImage? = nil, noPhotoText: String = "", photoSelection: @escaping (PresentablePhoto) -> Void = { _ in }) -> RandomPhotoViewController {
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
