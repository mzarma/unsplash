//
//  SingePhotoDataSourceDelegate.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 07/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

struct PresentablePhoto {
    let image: UIImage
    let description: String
}

class SinglePhotoDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let photo: PresentablePhoto
    private let photoSelection: (PresentablePhoto) -> Void
    
    init(photo: PresentablePhoto, photoSelection: @escaping (PresentablePhoto) -> Void) {
        self.photo = photo
        self.photoSelection = photoSelection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
