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

    private (set) var searchViewController: SearchViewController!
    private (set) var listViewController: PhotoListViewController!
    
    private let searchResultFetcher: S
    private let imageProvider: ImageProvider
    
    init(_ searchResultFetcher: S, _ imageProvider: ImageProvider) {
        self.searchResultFetcher = searchResultFetcher
        self.imageProvider = imageProvider
    }
    
    func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController {
        let dataSourceDelegate = PhotoListDataSourceDelegate(noPhotoText: "No photos", imageProvider: imageProvider) { photo in
            selected(PhotoPresenter.corePhoto(from: photo))
        }
        
        let container = UIViewController()
        searchViewController = makeSearchView(with: dataSourceDelegate)
        listViewController = makePhotoListView(with: dataSourceDelegate)
        
        PhonePhotoListViewFactory.configure(searchViewController, listViewController, in: container)
        
        return container
    }
    
    private func makeSearchView(with dataSourceDelegate: PhotoListDataSourceDelegate) -> SearchViewController {
        let viewController = SearchViewController { [weak self] term in
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
        return viewController
    }
    
    private func makePhotoListView(with dataSourceDelegate: PhotoListDataSourceDelegate) -> PhotoListViewController {
        return PhotoListViewController(dataSource: dataSourceDelegate, delegate: dataSourceDelegate)
    }
    
    private static func configure(_ searchView: UIViewController, _ photoListView: UIViewController, in container: UIViewController) {
        let width = container.view.bounds.width
        let height = container.view.bounds.height
        let searchViewHeight: CGFloat = 80
        
        container.addChild(searchView)
        container.view.addSubview(searchView.view)
        searchView.view.frame = CGRect(x: 0, y: 0, width: width, height: searchViewHeight)
        searchView.didMove(toParent: container)

        container.addChild(photoListView)
        container.view.addSubview(photoListView.view)
        photoListView.view.frame = CGRect(x: 0, y: 80, width: width, height: height - searchViewHeight)
        photoListView.didMove(toParent: container)
    }
}
