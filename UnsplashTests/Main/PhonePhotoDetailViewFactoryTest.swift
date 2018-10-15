//
//  PhonePhotoDetailViewFactoryTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 10/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhonePhotoDetailViewFactoryTest: XCTestCase {
    private weak var weakSUT: PhonePhotoDetailViewFactory?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    // MARK: Layout
    
    func test_tableViewIsViewChild() {
        let photoDetailView = makePhotoDetailView()
        
        XCTAssertTrue(photoDetailView.tableView.superview === photoDetailView.view)
    }
    
    // MARK: UICollectionViewDataSource
    
    func test_numberOfRowsInSection() {
        XCTAssertEqual(makePhotoDetailView().numberOfRows(), 5)
    }
    
    func test_imageCell() {
        let exp = expectation(description: "Image should be filled")
        let image = testImage()
        let cell = makePhotoDetailView().imageCell()
        
        imageProvider.complete?(.success(image))
        XCTWaiter().wait(for: [exp], timeout: 0.1)
        exp.fulfill()
        
        XCTAssertEqual(cell.photoImage, image)
    }

    func test_defaultCells() {
        let photo = corePhoto(dateCreated: Date(timeIntervalSince1970: 1899894912), description: "a description", creatorName: "a creator", creatorPortfolioURLString: "a portfolio url")
        let detailView = makePhotoDetailView(photo: photo)
        
        XCTAssertEqual(detailView.descriptionCellTitle, "Description")
        XCTAssertEqual(detailView.descriptionCellSubtitle, "a description")
        
        XCTAssertEqual(detailView.dateCreatedCellTitle, "Date Created")
        XCTAssertEqual(detailView.dateCreatedCellSubtitle, "Mar 16, 2030")
        
        XCTAssertEqual(detailView.creatorNameCellTitle, "Creator")
        XCTAssertEqual(detailView.creatorNameCellSubtitle, "a creator")
        
        XCTAssertEqual(detailView.creatorPortfolioCellTitle, "Creator's Portfolio")
        XCTAssertEqual(detailView.creatorPortfolioCellSubtitle, "a portfolio url")
    }

    // MARK: Helpers
    private let imageProvider = ImageProviderStub()
    
    private func makeSUT() -> PhonePhotoDetailViewFactory {
        let sut = PhonePhotoDetailViewFactory(imageProvider: imageProvider)
        weakSUT = sut
        return sut
    }
    
    private func makePhotoDetailView(photo: CorePhoto = corePhoto()) -> PhotoDetailViewController {
        let sut = makeSUT()
        let randomView = sut.makePhotoDetailView(for: photo) as! PhotoDetailViewController
        randomView.loadViewIfNeeded()
        return randomView
    }
    
    private class ImageProviderStub: ImageProvider {
        var complete: ((Result<UIImage, ImageProviderError>) -> Void)?
        
        func fetchImage(for photo: CorePhoto, completion: @escaping (Result<UIImage, ImageProviderError>) -> Void) {
            complete = completion
        }
    }
}
