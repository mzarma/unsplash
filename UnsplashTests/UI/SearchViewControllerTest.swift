//
//  SearchViewControllerTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 25/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class SearchViewControllerTest: XCTestCase {
    private weak var weakSUT: SearchViewController?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }

    func test_searchBarIsViewChild() {
        let sut = makeSUT()
        
        XCTAssertTrue(sut.searchBar.superview === sut.view)
    }
    
    func test_isSearchBarDelegate() {
        let sut = makeSUT()
        
        XCTAssertTrue(sut.searchBar.delegate === sut)
    }
    
    // MARK: UISearchBarDelegate
    
    func test_firesSearchedWithCorrectTerm_whenSearchButtonClicked() {
        var callCount = 0
        var expectedTerm: String?
        
        let sut = makeSUT { term in
            callCount += 1
            expectedTerm = term
        }
        
        XCTAssertEqual(callCount, 0)
        
        sut.clickSearchButton(with: "a search term")
        
        XCTAssertEqual(callCount, 1)
        XCTAssertEqual(expectedTerm, "a search term")
    }
    
    // MARK: Helpers
    
    private func makeSUT(searched: @escaping (String) -> Void = { _ in }) -> SearchViewController {
        let sut = SearchViewController(searched)
        weakSUT = sut
        sut.loadViewIfNeeded()
        return sut
    }
}
