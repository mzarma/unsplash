//
//  NoPhotoCell.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 12/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

class NoPhotoCell: UICollectionViewCell {

    @IBOutlet private weak var label: UILabel!

    var text: String {
        get { return label.text ?? "" }
        set { label.text = newValue }
    }
}
