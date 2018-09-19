//
//  RandomPhotoDetailDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 19/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class RandomPhotoDetailDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let photo: PresentableRandomPhoto
    private let image: UIImage
    
    init(photo: PresentableRandomPhoto, image: UIImage) {
        self.photo = photo
        self.image = image
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
