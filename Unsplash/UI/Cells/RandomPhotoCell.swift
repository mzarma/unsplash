//
//  RandomPhotoCell.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 09/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class RandomPhotoCell: UICollectionViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    var photoImage: UIImage? {
        get { return photoImageView.image ?? nil }
        set { photoImageView.image = newValue }
    }
    
    var text: String {
        get { return descriptionLabel.text ?? "" }
        set { descriptionLabel.text = newValue }
    }
}
