//
//  RemoteSearchResultMapper.swift
//  Unsplash
//
//  Created by Michail Zarmakoupis on 05/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation

final class RemoteSearchResultMapper {
    static func map(data: Data) -> RemoteSearchResult? {
        guard let searchResult = try? JSONDecoder().decode(RemoteSearchResult.self, from: data) else {
            return nil
        }
        return searchResult
    }
}
