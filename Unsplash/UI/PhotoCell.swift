//
//  PhotoCell.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 09/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var photoImage: UIImage? {
        get { return photoImageView.image ?? nil }
        set { photoImageView.image = newValue }
    }
    
    var text: String {
        get { return descriptionLabel.text ?? "" }
        set { descriptionLabel.text = newValue }
    }
}
