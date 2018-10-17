//
//  PhonePhotoListViewFactory.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 26/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhonePhotoListViewFactory<S: SearchResultFetcher>: PhotoListViewFactory where S.Request == URLRequest, S.Result == Result<CoreSearchResult, SearchResultFetcherError> {
    
    private let searchResultFetcher: S
    private let imageProvider: ImageProvider
    
    init(_ searchResultFetcher: S, _ imageProvider: ImageProvider) {
        self.searchResultFetcher = searchResultFetcher
        self.imageProvider = imageProvider
    }
    
    func makePhotoListView(_ selected: @escaping (CorePhoto) -> Void) -> UIViewController {
        let dataSourceDelegate = PhotoListDataSourceDelegate(noPhotoText: PhotoPresenter.noPhotosText, imageProvider: imageProvider) { photo in
            selected(photo.corePhoto)
        }
        
        let container = UIViewController()
        let listViewController = makePhotoListView(with: dataSourceDelegate)
        let searchViewController = makeSearchView(with: dataSourceDelegate, reloadData: listViewController.collectionView.reloadData)
        
        PhonePhotoListViewFactory.configure(searchViewController, listViewController, in: container)
        
        return container
    }
    
    private func makeSearchView(with dataSourceDelegate: PhotoListDataSourceDelegate, reloadData: @escaping () -> Void) -> SearchViewController {
        let viewController = SearchViewController { [weak self] term in
            let request = URLRequestFactory.search(parameters: SearchParameters(page: 1, term: term))
            self?.searchResultFetcher.fetch(request: request) { result in
                switch result {
                case .success(let result):
                    let presentablePhotos = result.photos.map(PhotoPresenter.presentablePhoto)
                    dataSourceDelegate.photos = presentablePhotos
                    DispatchQueue.main.async {
                        reloadData()
                    }
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
        container.edgesForExtendedLayout = []
        let searchViewHeight: CGFloat = 80
        
        container.addChild(searchView)
        searchView.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(searchView.view)
        
        container.addChild(photoListView)
        photoListView.view.translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(photoListView.view)

        NSLayoutConstraint.activate([
            searchView.view.topAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.topAnchor),
            searchView.view.leadingAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.leadingAnchor),
            searchView.view.trailingAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.trailingAnchor),
            searchView.view.heightAnchor.constraint(equalToConstant: searchViewHeight),
            photoListView.view.topAnchor.constraint(equalTo: searchView.view.bottomAnchor),
            photoListView.view.leadingAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.leadingAnchor),
            photoListView.view.trailingAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.trailingAnchor),
            photoListView.view.bottomAnchor.constraint(equalTo: container.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        searchView.didMove(toParent: container)
        photoListView.didMove(toParent: container)
    }
}
