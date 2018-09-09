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
    
    func test_tableViewIsViewChild() {
        let sut = makeSUT()
        XCTAssertTrue(sut.tableView.superview === sut.view)
    }
    
    // MARK: DataSource
    
    func test_numberOfRowsInSectionIsTwo() {
        let sut = makeSUT()
        let tableView = sut.tableView
        XCTAssertEqual(tableView.dataSource!.tableView(tableView, numberOfRowsInSection: 0), 2)
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


