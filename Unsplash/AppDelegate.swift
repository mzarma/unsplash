//
//  AppDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 02/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var photoListFlow: PhotoListFlow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let client = HTTPClient(URLSession.shared)
        let remoteSearchResultFetcher = RemoteSearchResultFetcher(client: client)
        let searchResultFetcher = RemoteCorePhotoFetcher(remoteSearchResultFetcher)
        let downloader = PhotoDownloader(client: client)
        let imageProvider = PhotoListImageProvider(downloader)
        let photoListFactory = PhonePhotoListViewFactory(searchResultFetcher, imageProvider)
        let photoDetailFactory = PhonePhotoDetailViewFactory(imageProvider: imageProvider)
        photoListFlow = PhotoListFlow(
            navigation: navigationController,
            photoListViewFactory: photoListFactory,
            photoDetailViewFactory: photoDetailFactory
        )
        photoListFlow?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
