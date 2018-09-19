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

    // MARK: Helpers
    
    private let navigationController = UINavigationControllerSpy()
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
    
    private class UINavigationControllerSpy: UINavigationController {
        
    }
    
    private class RandomPhotoViewFactorySpy: RandomPhotoViewFactory {
        var stubPhotoView: UIViewController?
        var photo: CoreRandomPhoto?
        var select: ((CoreRandomPhoto) -> Void)?

        func makeRandomPhotoView(_ selected: @escaping (CoreRandomPhoto) -> Void) -> UIViewController {
            
            return stubPhotoView!
        }
    }

    private class RandomPhotoDetailViewFactorySpy: RandomPhotoDetailViewFactory {
        var stubPhotoDetailView: UIViewController?
        
        func makeRandomPhotoDetailView(for photo: CoreRandomPhoto) -> UIViewController {
            return stubPhotoDetailView!
        }
    }
}
