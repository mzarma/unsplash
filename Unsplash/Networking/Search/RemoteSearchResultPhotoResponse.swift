//
//  RemoteSearchResultPhotoResponse.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

struct RemoteSearchResultPhotoResponse: Equatable, Codable {
    let identifier: String
    let dateCreatedString: String
    let width: Int
    let height: Int
    let colorString: String
    let description: String
    let creator: Creator
    let imageURLs: ImageURLs
    let imageLinks: ImageLinks
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case dateCreatedString = "created_at"
        case width = "width"
        case height = "height"
        case colorString = "color"
        case description = "description"
        case creator = "user"
        case imageURLs = "urls"
        case imageLinks = "links"
    }
    
    struct Creator: Equatable, Codable {
        let identifier: String
        let username: String
        let name: String
        let portfolioURLString: String?
        let profileImageURLs: ProfileImageURLs?
        
        enum CodingKeys: String, CodingKey {
            case identifier = "id"
            case username = "username"
            case name = "name"
            case portfolioURLString = "portfolio_url"
            case profileImageURLs = "profile_image"
        }
        
        struct ProfileImageURLs: Equatable, Codable {
            let small: String?
            let medium: String?
            let large: String?
            
            enum CodingKeys: String, CodingKey {
                case small = "small"
                case medium = "medium"
                case large = "large"
            }
        }
    }
    
    struct ImageURLs: Equatable, Codable {
        let regular: String
        let small: String
        let thumbnail: String
        
        enum CodingKeys: String, CodingKey {
            case regular = "regular"
            case small = "small"
            case thumbnail = "thumb"
        }
    }
    
    struct ImageLinks: Equatable, Codable {
        let download: String
        
        enum CodingKeys: String, CodingKey {
            case download = "download"
        }
    }
}
