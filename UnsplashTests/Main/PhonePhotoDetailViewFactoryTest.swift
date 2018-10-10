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
        var imagesByIdentifier = [String: UIImage]()
        var complete: ((Result<UIImage, ImageProviderError>) -> Void)?
        
        func fetchImage(for photo: CorePhoto, completion: @escaping (Result<UIImage, ImageProviderError>) -> Void) {
            if let image = imagesByIdentifier[photo.identifier] {
                completion(.success(image))
            } else {
                completion(.error(.invalidImageData))
            }
        }
    }
}
