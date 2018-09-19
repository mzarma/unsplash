//
//  ImageCell.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 19/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    
    @IBOutlet private weak var photoImageView: UIImageView!
    
    var photoImage: UIImage? {
        get { return photoImageView.image ?? nil }
        set { photoImageView.image = newValue }
    }
}
