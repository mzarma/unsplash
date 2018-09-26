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
        
    // MARK: Helpers
    
    private let searchResultFetcher = SearchResultFetcherSpy()
    private let photoFetcher = PhotoFetcherSpy()
    private typealias SUT = PhonePhotoListViewFactory<SearchResultFetcherSpy, PhotoFetcherSpy>
    
    private func makeSUT() -> SUT {
        let sut = PhonePhotoListViewFactory(searchResultFetcher, photoFetcher)
        weakSUT = sut
        return sut
    }
    
    private func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void = { _ in }) -> UIViewController {
        let sut = makeSUT()
        let photoListView = sut.makePhotoListView(selected)
        photoListView.loadViewIfNeeded()
        return photoListView
    }
    
    private class SearchResultFetcherSpy: SearchResultFetcher {
        var fetchCallCount = 0
        var complete: ((Result) -> Void)?
        
        func fetch(request: URLRequest, completion: @escaping (Result<CoreSearchResult, SearchResultFetcherError>) -> Void) {
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
