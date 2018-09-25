//
//  PhoneRandomPhotoDetailViewFactoryTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhoneRandomPhotoDetailViewFactoryTest: XCTestCase {
    private weak var weakSUT: PhoneRandomPhotoDetailViewFactory?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    // MARK: Layout
    
    func test_tableViewIsViewChild() {
        let randomPhotoDetailView = makeRandomPhotoDetailView()
        
        XCTAssertTrue(randomPhotoDetailView.tableView.superview === randomPhotoDetailView.view)
    }
    
    // MARK: UICollectionViewDataSource

    func test_numberOfRowsInSection() {
        XCTAssertEqual(makeRandomPhotoDetailView().numberOfRows(), 5)
    }

    func test_rendersImageCell() {
        let randomView = makeRandomPhotoDetailView()
        let cell = randomView.imageCell()

        XCTAssertEqual(cell.photoImage?.pngData(), testImage().pngData())
    }

    func test_rendersDescriptionCell() {
        let photo = coreRandomPhoto(description: "a description")
        let randomView = makeRandomPhotoDetailView(photo: photo)
        let cell = randomView.descriptionCell()

        XCTAssertEqual(cell.textLabel?.text, "Description")
        XCTAssertEqual(cell.detailTextLabel?.text, "a description")
    }

    func test_rendersDateCreatedCell() {
        let photo = coreRandomPhoto(dateCreated: Date(timeIntervalSince1970: 946684800))
        let randomView = makeRandomPhotoDetailView(photo: photo)
        let cell = randomView.dateCreatedCell()

        XCTAssertEqual(cell.textLabel?.text, "Date Created")
        XCTAssertEqual(cell.detailTextLabel?.text, "2000-01-01T00:00:00Z")
    }

    func test_rendersCreatorNameCell() {
        let photo = coreRandomPhoto(creatorName: "a creator")
        let randomView = makeRandomPhotoDetailView(photo: photo)
        let cell = randomView.creatorNameCell()

        XCTAssertEqual(cell.textLabel?.text, "Creator")
        XCTAssertEqual(cell.detailTextLabel?.text, "a creator")
    }

    func test_rendersCreatorPortfolioURLCell() {
        let photo = coreRandomPhoto(creatorPortfolioURLString: "a URL string")
        let randomView = makeRandomPhotoDetailView(photo: photo)
        let cell = randomView.creatorPortfolioURLCell()

        XCTAssertEqual(cell.textLabel?.text, "Creator's portfolio")
        XCTAssertEqual(cell.detailTextLabel?.text, "a URL string")
    }

    // MARK: Helpers
    
    private func makeSUT() -> PhoneRandomPhotoDetailViewFactory {
        let sut = PhoneRandomPhotoDetailViewFactory()
        weakSUT = sut
        return sut
    }
    
    private func makeRandomPhotoDetailView(photo: CoreRandomPhoto = coreRandomPhoto(), image: UIImage = testImage()) -> RandomPhotoDetailViewController {
        let sut = makeSUT()
        let randomView = sut.makeRandomPhotoDetailView(for: photo, image: image) as! RandomPhotoDetailViewController
        randomView.loadViewIfNeeded()
        return randomView
    }
}
