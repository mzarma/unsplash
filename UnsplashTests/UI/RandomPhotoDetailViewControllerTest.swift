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
        
    // MARK: Helpers
    
    private func makeSUT(photo: PresentableRandomPhoto = presentableRandomPhoto(), image: UIImage = UIImage()) -> RandomPhotoDetailViewController {
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
