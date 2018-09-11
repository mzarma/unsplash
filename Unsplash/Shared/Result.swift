//
//  Result.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 11/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

enum Result<S, E: Error> {
    case success(S)
    case error(E)
}
