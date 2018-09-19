//
//  RandomPhotoFlowTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 18/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class RandomPhotoFlowTest: XCTestCase {
    private weak var weakSUT: RandomPhotoFlow?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_start_presentsPhotoView() {
        let sut = makeSUT()
        
        XCTAssertEqual(navigationController.viewControllers, [])
        
        sut.start()
        
        XCTAssertEqual(navigationController.viewControllers, [photoView])
    }
    
    func test_start_presentsPhotoDetailView_withCorrectPhoto() {
        let sut = makeSUT()
        
        XCTAssertEqual(navigationController.viewControllers, [])
        
        sut.start()
        
        XCTAssertEqual(navigationController.viewControllers, [photoView])
        
        let photo = coreRandomPhoto()
        photoViewFactory.select?(photo)
        
        XCTAssertEqual(navigationController.viewControllers, [photoView, photoDetailView])
        XCTAssertEqual(photoDetailViewFactory.photo, photo)
    }

    // MARK: Helpers
    
    private let navigationController = NonAnimatingUINavigationController()
    private let photoViewFactory = RandomPhotoViewFactorySpy()
    private let photoDetailViewFactory = RandomPhotoDetailViewFactorySpy()
    
    private let photoView = UIViewController()
    private let photoDetailView = UIViewController()
    
    private func makeSUT() -> RandomPhotoFlow {
        let sut = RandomPhotoFlow(
            navigationController: navigationController,
            photoViewFactory: photoViewFactory,
            photoDetailViewFactory: photoDetailViewFactory
        )
        photoViewFactory.stubPhotoView = photoView
        photoDetailViewFactory.stubPhotoDetailView = photoDetailView
        weakSUT = sut
        return sut
    }
    
    private class NonAnimatingUINavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    private class RandomPhotoViewFactorySpy: RandomPhotoViewFactory {
        var stubPhotoView: UIViewController?
        var select: ((CoreRandomPhoto) -> Void)?

        func makeRandomPhotoView(_ selected: @escaping (CoreRandomPhoto) -> Void) -> UIViewController {
            select = selected
            return stubPhotoView!
        }
    }

    private class RandomPhotoDetailViewFactorySpy: RandomPhotoDetailViewFactory {
        var stubPhotoDetailView: UIViewController?
        var photo: CoreRandomPhoto?
        
        func makeRandomPhotoDetailView(for photo: CoreRandomPhoto) -> UIViewController {
            self.photo = photo
            return stubPhotoDetailView!
        }
    }
}
