//
//  PhotoListFlowTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 10/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhotoListFlowTest: XCTestCase {
    private weak var weakSUT: PhotoListFlow?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_startShowsPhotoListView() {
        let sut = makeSUT()
        
        XCTAssertEqual(navigation.viewControllers, [])
        
        sut.start()
        
        XCTAssertEqual(navigation.viewControllers, [photoListView])
    }
    
    // MARK: Helpers
    
    private let navigation = NonAnimatingUINavigationController()
    private let photoListViewFactory = PhotoListViewFactorySpy()
    private let photoDetailViewFactory = PhotoDetailViewFactorySpy()
    
    private let photoListView = UIViewController()
    private let photoDetailView = UIViewController()
    
    private func makeSUT() -> PhotoListFlow {
        let sut = PhotoListFlow(navigation: navigation, photoListViewFactory: photoListViewFactory, photoDetailViewFactory: photoDetailViewFactory)
        
        photoListViewFactory.stubPhotoListView = photoListView
        photoDetailViewFactory.stubPhotoDetailView = photoDetailView
        
        weakSUT = sut
        return sut
    }
    
    private class NonAnimatingUINavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    private class PhotoListViewFactorySpy: PhotoListViewFactory {
        var stubPhotoListView: UIViewController?
        var select: ((CorePhoto) -> Void)?
        
        func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController {
            select = selected
            return stubPhotoListView!
        }
    }
    
    private class PhotoDetailViewFactorySpy: PhotoDetailViewFactory {
        var stubPhotoDetailView: UIViewController?
        
        func makePhotoDetailView(for photo: CorePhoto, imageProvider: ImageProvider) -> UIViewController {
            return stubPhotoDetailView!
        }
    }
}
