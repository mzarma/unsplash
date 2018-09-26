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
        
    // MARK: Helpers
    
    private let searchResultFetcher = SearchResultFetcherSpy()
    private let photoFetcher = PhotoFetcherSpy()
    private typealias SUT = PhonePhotoListViewFactory<SearchResultFetcherSpy, PhotoFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = PhonePhotoListViewFactory(searchResultFetcher, photoFetcher)
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
    
    private class PhotoFetcherSpy: PhotoFetcher {
        var requests = [URLRequest]()
        var complete: ((Result<Data, PhotoFetcherError>) -> Void)?
        
        func fetch(request: URLRequest, completion: @escaping (Result<Data, PhotoFetcherError>) -> Void) {
            requests.append(request)
            complete = completion
        }
    }
}
