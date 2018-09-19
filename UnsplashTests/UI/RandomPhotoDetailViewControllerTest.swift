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
    
    func test_rendersDescriptionCell() {
        let photo = presentableRandomPhoto(description: "a description")
        let sut = makeSUT(photo: photo)
        let cell = sut.descriptionCell()
        
        XCTAssertEqual(cell.textLabel?.text, "Description")
        XCTAssertEqual(cell.detailTextLabel?.text, photo.description)
    }
    
    func test_rendersDateCreatedCell() {
        let photo = presentableRandomPhoto(dateCreated: "a date")
        let sut = makeSUT(photo: photo)
        let cell = sut.dateCreatedCell()
        
        XCTAssertEqual(cell.textLabel?.text, "Date Created")
        XCTAssertEqual(cell.detailTextLabel?.text, photo.dateCreated)
    }
    
    func test_rendersCreatorNameCell() {
        let photo = presentableRandomPhoto(creatorName: "a name")
        let sut = makeSUT(photo: photo)
        let cell = sut.creatorNameCell()
        
        XCTAssertEqual(cell.textLabel?.text, "Creator")
        XCTAssertEqual(cell.detailTextLabel?.text, photo.creatorName)
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
