//
//  PhotoListImageProvider.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 02/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

final class PhotoListImageProvider: ImageProvider {
    func image(for photo: CorePhoto) -> UIImage? {
        guard let _ = URL(string: photo.thumbnailImageURLString) else { return nil }
        return UIImage()
    }
}
