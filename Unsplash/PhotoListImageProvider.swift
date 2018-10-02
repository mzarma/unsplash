//
//  PhotoListImageProvider.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 02/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import UIKit

protocol ImageProvider_ {
    func fetchImage(for photo: CorePhoto, completion: @escaping (UIImage?) -> Void)
}

final class PhotoListImageProvider: ImageProvider_ {
    func fetchImage(for photo: CorePhoto, completion: @escaping (UIImage?) -> Void) {
        completion(nil)
    }
}
