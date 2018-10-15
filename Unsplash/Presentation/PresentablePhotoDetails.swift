//
//  PresentablePhotoDetails.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 15/10/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct PresentablePhotoDetails {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    let corePhoto: CorePhoto
    
    var description: String {
        return corePhoto.description
    }
    
    var dateCreated: String {
        return PresentablePhotoDetails.dateFormatter.string(from: corePhoto.dateCreated)
    }
    
    var creatorName: String {
        return corePhoto.creatorName
    }
    
    var creatorPortfolioURLString: String? {
        return corePhoto.creatorPortfolioURLString
    }
}
