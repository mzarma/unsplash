//
//  HTTPClientStub.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 11/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import Foundation
@testable import Unsplash

func mockRequest() -> URLRequest {
    return URLRequest(url: mockURL())
}

func mockURL() -> URL {
    return URL(string: "https://a-mock.url")!
}

class HTTPClientStub: HTTPClient {
    convenience init() {
        self.init(URLSession.shared)
    }
    
    var requests = [URLRequest]()
    var complete: ((HTTPClient.Output) -> Void)?
    
    override func execute(_ request: URLRequest, completion: @escaping (HTTPClient.Output) -> Void) {
        requests.append(request)
        complete = completion
    }
}
