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
    
    private (set) var searchViewController: SearchViewController?
    private (set) var listViewController: PhotoListViewController?
    
    private let searchResultFetcher: S
    private let photoFetcher: P
    
    init(_ searchResultFetcher: S, _ photoFetcher: P) {
        self.searchResultFetcher = searchResultFetcher
        self.photoFetcher = photoFetcher
    }
    
    func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController {
        let container = UIViewController()
        
        searchViewController = SearchViewController { _ in }
        let dataSourceDelegate = PhotoListDataSourceDelegate(noPhotoText: "") { _ in }
        listViewController = PhotoListViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
        
        container.addChild(searchViewController!)
        container.view.addSubview(searchViewController!.view)
        searchViewController!.didMove(toParent: container)
        return container
    }
}
