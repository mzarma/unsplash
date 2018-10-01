//
//  PhonePhotoListViewFactoryTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 26/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class PhonePhotoListViewFactoryTest: XCTestCase {
    private weak var weakSUT: SUT?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_containerHasChildSearchView() {
        let sut = makeSUT()
        
        let containerViewController = sut.makePhotoListView { _ in }

        XCTAssertTrue(sut.searchViewController.parent === containerViewController)
        XCTAssertTrue(sut.searchViewController.view.superview === containerViewController.view)
    }
    
    func test_containerHasChildPhotoListView() {
        let sut = makeSUT()
        
        let containerViewController = sut.makePhotoListView { _ in }
        
        XCTAssertTrue(sut.listViewController.parent === containerViewController)
        XCTAssertTrue(sut.listViewController.view.superview === containerViewController.view)
    }
    
    func test_photoListView_startsWithNoPhotoText() {
        let sut = makeSUT()
        _ = sut.makePhotoListView { _ in }
        XCTAssertEqual(sut.listViewController.noPhotoCell().text, "No photos")
    }
    
    func test_searchResultFetcherFetches_whenSearchedIsFired() {
        let expectedSearchParameters = SearchParameters(page: 1, term: "a term")
        let sut = makeSUT()
        _ = sut.makePhotoListView { _ in }
        
        XCTAssertEqual(searchResultFetcher.fetchCallCount, 0)
        XCTAssertEqual(searchResultFetcher.requests, [])
        
        sut.searchViewController.clickSearchButton(with: "a term")
        
        XCTAssertEqual(searchResultFetcher.fetchCallCount, 1)
        XCTAssertEqual(searchResultFetcher.requests, [URLRequestFactory.search(parameters: expectedSearchParameters)])
    }
    
    func test_photoListView_showsNoPhotoCell_whenSearchResultFetchingFails() {
        let sut = makeSUT()
        _ = sut.makePhotoListView { _ in }

        sut.searchViewController.clickSearchButton(with: "a term")
        searchResultFetcher.complete?(.error(.remote))
        
        XCTAssertEqual(searchResultFetcher.fetchCallCount, 1)
        XCTAssertEqual(sut.listViewController.numberOfItems(), 1)
        XCTAssertEqual(sut.listViewController.noPhotoCell().text, "No photos")
    }
    
    func test_photoListView_showsNoPhotoCell_whenSearchResultFetcherCompletesWithZeroPhotos() {
        let sut = makeSUT()
        _ = sut.makePhotoListView { _ in }
        
        sut.searchViewController.clickSearchButton(with: "a term")
        let searchResult = CoreSearchResult(totalPhotos: 0, totalPages: 1, photos: [])
        searchResultFetcher.complete?(.success(searchResult))
        
        XCTAssertEqual(searchResultFetcher.fetchCallCount, 1)
        XCTAssertEqual(sut.listViewController.numberOfItems(), 1)
        XCTAssertEqual(sut.listViewController.noPhotoCell().text, "No photos")
    }

    func test_photoListView_photoCellWithNoImage_whenOnePhotoAndImageProviderReturnsNil() {
        let sut = makeSUT()
        _ = sut.makePhotoListView { _ in }

        sut.searchViewController.clickSearchButton(with: "a term")
        let photo = corePhoto(description: "a description")
        let searchResult = CoreSearchResult(totalPhotos: 1, totalPages: 1, photos: [photo])
        searchResultFetcher.complete?(.success(searchResult))

        XCTAssertEqual(searchResultFetcher.fetchCallCount, 1)
        XCTAssertEqual(sut.listViewController.numberOfItems(), 1)
        XCTAssertEqual(sut.listViewController.photoCell(for: 0).text, "a description")
        XCTAssertNil(sut.listViewController.photoCell(for: 0).photoImage)
    }
    
    func test_photoListView_showsPhotoCell_withOnePhoto() {
        let sut = makeSUT()
        _ = sut.makePhotoListView { _ in }

        sut.searchViewController.clickSearchButton(with: "a term")
        let photo = corePhoto(identifier: "an identifier", description: "a description")
        let searchResult = CoreSearchResult(totalPhotos: 1, totalPages: 1, photos: [photo])
        searchResultFetcher.complete?(.success(searchResult))

        let image = testImage()
        imageProvider.imagesByIdentifier = ["an identifier": image]

        XCTAssertEqual(sut.listViewController.numberOfItems(), 1)
        XCTAssertEqual(sut.listViewController.photoCell(for: 0).text, "a description")
        XCTAssertEqual(sut.listViewController.photoCell(for: 0).photoImage, image)
    }
    
    func test_photoListView_showsPhotoCells() {
        let sut = makeSUT()
        _ = sut.makePhotoListView { _ in }
        
        sut.searchViewController.clickSearchButton(with: "a term")
        let photo1 = corePhoto(identifier: "identifier1", description: "description1")
        let photo2 = corePhoto(identifier: "identifier2", description: "description2")
        let photo3 = corePhoto(identifier: "identifier3", description: "description3")
        
        let searchResult = CoreSearchResult(totalPhotos: 3, totalPages: 1, photos: [photo1, photo2, photo3])
        searchResultFetcher.complete?(.success(searchResult))
        
        let image1 = testImage(width: 100, height: 100)
        let image2 = testImage(width: 200, height: 200)
        
        imageProvider.imagesByIdentifier = ["identifier1": image1, "identifier2": image2]
        
        XCTAssertEqual(sut.listViewController.numberOfItems(), 3)
        XCTAssertEqual(sut.listViewController.photoCell(for: 0).text, "description1")
        XCTAssertEqual(sut.listViewController.photoCell(for: 1).text, "description2")
        XCTAssertEqual(sut.listViewController.photoCell(for: 2).text, "description3")

        XCTAssertEqual(sut.listViewController.photoCell(for: 0).photoImage, image1)
        XCTAssertEqual(sut.listViewController.photoCell(for: 1).photoImage, image2)
        XCTAssertNil(sut.listViewController.photoCell(for: 2).photoImage)
    }

    func test_photoListView_doesNotDelegateSelection_whenNoPhotoCellIsSelected() {
        var photoSelectionCount = 0
        var selectedPhoto: CorePhoto?
        
        let sut = makeSUT()
        _ = sut.makePhotoListView { photo in
            photoSelectionCount += 1
            selectedPhoto = photo
        }
        
        sut.searchViewController.clickSearchButton(with: "a term")
        let searchResult = CoreSearchResult(totalPhotos: 0, totalPages: 1, photos: [])
        searchResultFetcher.complete?(.success(searchResult))
        
        XCTAssertEqual(searchResultFetcher.fetchCallCount, 1)
        XCTAssertEqual(sut.listViewController.numberOfItems(), 1)
        XCTAssertEqual(sut.listViewController.noPhotoCell().text, "No photos")
        
        sut.listViewController.selectItem(0)
        
        XCTAssertEqual(photoSelectionCount, 0)
        XCTAssertNil(selectedPhoto)
    }
    
    // MARK: Helpers
    
    private let searchResultFetcher = SearchResultFetcherSpy()
    private let imageProvider = ImageProviderStub()
    private typealias SUT = PhonePhotoListViewFactory<SearchResultFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = PhonePhotoListViewFactory(searchResultFetcher, imageProvider)
        weakSUT = sut
        return sut
    }
    
    private class SearchResultFetcherSpy: SearchResultFetcher {
        var fetchCallCount = 0
        var requests = [URLRequest]()
        var complete: ((Result) -> Void)?
        
        func fetch(request: URLRequest, completion: @escaping (Result<CoreSearchResult, SearchResultFetcherError>) -> Void) {
            fetchCallCount += 1
            requests.append(request)
            complete = completion
        }
    }
    
    private class ImageProviderStub: ImageProvider {
        var imagesByIdentifier = [String: UIImage]()
        
        func image(for identifier: String) -> UIImage? {
            return imagesByIdentifier[identifier]
        }
    }
}
