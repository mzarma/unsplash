//
//  PhoneRandomPhotoViewFactoryTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 13/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhoneRandomPhotoViewFactoryTest: XCTestCase {
    
    func test_randomPhotoView_startsWithNoPhotoText() {
        let randomView = makeRandomPhotoView()
        
        XCTAssertEqual(randomView.noPhotoCell().text, "No photo")
    }
    
    func test_makeRandomPhotoView_showsNoPhotoCell_whenFetchingFails() {
        let randomView = makeRandomPhotoView()
        
        randomPhotoFetcher.complete?(.error(.remote))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        XCTAssertEqual(randomView.numberOfItems(), 1)
        XCTAssertEqual(randomView.noPhotoCell().text, "No photo")
    }
    
    func test_makeRandomPhotoView_showsNoPhotoCell_whenFetchingSucceedsWithInvalidURL() {
        let randomView = makeRandomPhotoView()
        let invalidURL = ""
        let photo = coreRandomPhoto(regularImageURLString: invalidURL)
        
        randomPhotoFetcher.complete?(.success(photo))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        XCTAssertEqual(photoFetcher.requests, [])
        XCTAssertEqual(randomView.numberOfItems(), 1)
        XCTAssertEqual(randomView.noPhotoCell().text, "No photo")
    }
    
    func test_makeRandomPhotoView_showsNoPhotoCell_whenFetchingSucceedsWithValidURLButImageFetchingFails() {
        let randomView = makeRandomPhotoView()
        let url = "https://a-photo-url.com"
        let photo = coreRandomPhoto(regularImageURLString: url)

        randomPhotoFetcher.complete?(.success(photo))

        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        XCTAssertEqual(photoFetcher.requests, [URLRequest(url: URL(string: url)!)])

        photoFetcher.complete?(.error(.remote))

        XCTAssertEqual(randomView.numberOfItems(), 1)
        XCTAssertEqual(randomView.noPhotoCell().text, "No photo")
    }
    
    func test_makeRandomPhotoView_showsNoPhotoCell_whenFetchingSucceedsWithValidURLAndImageFetchingSucceedsWithInalidImageData() {
        let randomView = makeRandomPhotoView()
        let url = "https://a-photo-url.com"
        let photo = coreRandomPhoto(regularImageURLString: url)
        let invalidImageData = Data()
        
        randomPhotoFetcher.complete?(.success(photo))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        XCTAssertEqual(photoFetcher.requests, [URLRequest(url: URL(string: url)!)])
        
        photoFetcher.complete?(.success(invalidImageData))
        
        XCTAssertEqual(randomView.numberOfItems(), 1)
        XCTAssertEqual(randomView.noPhotoCell().text, "No photo")
    }
    
    func test_makeRandomPhotoView_showsPhotoCell_whenFetchingSucceedsWithValidURLAndImageFetchingSucceedsWithValidImageData() {
        let randomView = makeRandomPhotoView()
        let url = "https://a-photo-url.com"
        let photo = coreRandomPhoto(description: "a description", regularImageURLString: url)
        let image = testImage()
        let validImageData = image.pngData()!
        
        randomPhotoFetcher.complete?(.success(photo))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        XCTAssertEqual(photoFetcher.requests, [URLRequest(url: URL(string: url)!)])
        
        photoFetcher.complete?(.success(validImageData))
        
        XCTAssertEqual(randomView.numberOfItems(), 1)
        XCTAssertEqual(randomView.photoCell().photoImage!.pngData(), validImageData)
        XCTAssertEqual(randomView.photoCell().text, "a description")
    }
    
    func test_makeRandomPhotoView_doesNotDelegateSelection_whenShowingNoPhotoCellAndUserSelectsItem() {
        var callCount = 0
        var selectedPhoto: CoreRandomPhoto?
        var selectedImage: UIImage?
        
        let randomView = makeRandomPhotoView() { photo, image in
            callCount += 1
            selectedPhoto = photo
            selectedImage = image
        }
        
        randomPhotoFetcher.complete?(.error(.remote))
        
        XCTAssertEqual(randomPhotoFetcher.fetchCallCount, 1)
        XCTAssertEqual(randomView.numberOfItems(), 1)
        XCTAssertEqual(randomView.noPhotoCell().text, "No photo")
        
        randomView.selectItem()
        
        XCTAssertEqual(callCount, 0)
        XCTAssertNil(selectedPhoto)
        XCTAssertNil(selectedImage)
    }
    
    func test_makeRandomPhotoView_delegatesSelection_whenShowingPhotoCellAndUserSelectsItem() {
        var callCount = 0
        var selectedPhoto: CoreRandomPhoto?
        var selectedImage: UIImage?
        
        let randomView = makeRandomPhotoView() { photo, image in
            callCount += 1
            selectedPhoto = photo
            selectedImage = image
        }

        let photo = coreRandomPhoto(description: "a description", regularImageURLString: "https://a-photo-url.com")
        let image = testImage()

        randomPhotoFetcher.complete?(.success(photo))
        photoFetcher.complete?(.success(image.pngData()!))

        randomView.selectItem()

        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(selectedPhoto, photo)
        XCTAssertEqual(selectedImage!.pngData()!, image.pngData()!)
    }
        
    // MARK: Helpers
    
    private let randomPhotoFetcher = RandomPhotoResultFetcherSpy()
    private let photoFetcher = PhotoFetcherSpy()
    private typealias SUT = PhoneRandomPhotoViewFactory<RandomPhotoResultFetcherSpy, PhotoFetcherSpy>
    
    private func makeSUT() -> SUT {
        return PhoneRandomPhotoViewFactory(randomPhotoFetcher, photoFetcher)
    }
    
    private func makeRandomPhotoView(_ selected: @escaping (CoreRandomPhoto, UIImage) -> Void = { _,_ in }) -> RandomPhotoViewController {
        let sut = makeSUT()
        let randomView = sut.makeRandomPhotoView(selected) as! RandomPhotoViewController
        randomView.loadViewIfNeeded()
        return randomView
    }
            
    private class RandomPhotoResultFetcherSpy: RandomPhotoResultFetcher {
        var fetchCallCount = 0
        var complete: ((Result) -> Void)?
        
        func fetch(_ completion: @escaping (Result<CoreRandomPhoto, RandomPhotoResultFetcherError>) -> Void) {
            fetchCallCount += 1
            complete = completion
        }
    }
    
    private class PhotoFetcherSpy: PhotoFetcher {
        var requests = [URLRequest]()
        var complete: ((Result<Data, PhotoFetcherError>) -> Void)?
        
        func fetch(request: URLRequest, completion: @escaping (Result<Data, PhotoFetcherError>) -> Void) {
            requests.append(request)
            complete = completion
        }
    }
}
