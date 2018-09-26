//
//  PhonePhotoListViewFactory.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 26/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol PhotoListViewFactory {
    func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController
}

final class PhonePhotoListViewFactory<S: SearchResultFetcher, P: PhotoFetcher>: PhotoListViewFactory where S.Request == URLRequest, S.Result == Result<CoreSearchResult, SearchResultFetcherError>, P.Request == URLRequest, P.Response == Result<Data,PhotoFetcherError> {

    private let container = UIViewController()
    private (set) var searchViewController: SearchViewController!
    private (set) var listViewController: PhotoListViewController!
    
    private let searchResultFetcher: S
    private let photoFetcher: P
    
    init(_ searchResultFetcher: S, _ photoFetcher: P) {
        self.searchResultFetcher = searchResultFetcher
        self.photoFetcher = photoFetcher
    }
    
    func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController {
        addSearchViewController()
        addPhotoListViewController()
        return container
    }
    
    private func addSearchViewController() {
        searchViewController = SearchViewController { [weak self] term in
            let request = URLRequestFactory.search(parameters: SearchParameters(page: 1, term: term))
            self?.searchResultFetcher.fetch(request: request) { result in
                switch result {
                case .success(let result):
                    guard let photo = result.photos.first,
                          let url = URL(string: photo.thumbnailImageURLString) else { return }
                    let request = URLRequest(url: url)
                    self?.photoFetcher.fetch(request: request) { _ in }
                case .error(_): break
                }
            }
        }
        container.addChild(searchViewController)
        container.view.addSubview(searchViewController.view)
        searchViewController.view.frame = CGRect(x: 0, y: 0, width: container.view.bounds.width, height: 80)
        searchViewController.didMove(toParent: container)
    }
    
    private func addPhotoListViewController() {
        let dataSourceDelegate = PhotoListDataSourceDelegate(noPhotoText: "No photos") { _ in }
        listViewController = PhotoListViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
        container.addChild(listViewController)
        container.view.addSubview(listViewController.view)
        listViewController.view.frame = CGRect(x: 0, y: 80, width: container.view.bounds.width, height: container.view.bounds.height-80)
        listViewController.didMove(toParent: container)
    }
}
