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

final class PhonePhotoListViewFactory<S: SearchResultFetcher>: PhotoListViewFactory where S.Request == URLRequest, S.Result == Result<CoreSearchResult, SearchResultFetcherError> {

    private let container = UIViewController()
    private (set) var searchViewController: SearchViewController!
    private (set) var listViewController: PhotoListViewController!
    
    private let searchResultFetcher: S
    private let imageProvider: ImageProvider
    
    init(_ searchResultFetcher: S, _ imageProvider: ImageProvider) {
        self.searchResultFetcher = searchResultFetcher
        self.imageProvider = imageProvider
    }
    
    func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController {
        let dataSourceDelegate = PhotoListDataSourceDelegate(noPhotoText: "No photos", imageProvider: imageProvider) { _ in }
        
        searchViewController = SearchViewController { [weak self] term in
            let request = URLRequestFactory.search(parameters: SearchParameters(page: 1, term: term))
            self?.searchResultFetcher.fetch(request: request) { result in
                switch result {
                case .success(let result):
                    let presentablePhotos = result.photos.map(PhotoPresenter.presentablePhoto)
                    dataSourceDelegate.photos = presentablePhotos
                case .error(_): break
                }
            }
        }
        
        container.addChild(searchViewController)
        container.view.addSubview(searchViewController.view)
        searchViewController.view.frame = CGRect(x: 0, y: 0, width: container.view.bounds.width, height: 80)
        searchViewController.didMove(toParent: container)

        listViewController = PhotoListViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
        container.addChild(listViewController)
        container.view.addSubview(listViewController.view)
        listViewController.view.frame = CGRect(x: 0, y: 80, width: container.view.bounds.width, height: container.view.bounds.height-80)
        listViewController.didMove(toParent: container)
        return container
    }
}
