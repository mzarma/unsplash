//
//  PhotoListCell.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 17/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class PhotoListCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photoImage: UIImage? {
        get { return photoImageView.image ?? nil }
        set { photoImageView.image = newValue }
    }
}
