//
//  HTTPClientTest.swift
//  UnsplashTests
//
//  Created by Michail Zarmakoupis on 03/09/2018.
//  Copyright © 2018 Michail Zarmakoupis. All rights reserved.
//

import XCTest
@testable import Unsplash

class HTTPClientTest: XCTestCase {
    private weak var weakSUT: HTTPClient?
    
    override func tearDown() {
        XCTAssertNil(weakSUT)
        
        super.tearDown()
    }
    
    func test_createsDataTask_withRequest() {
        let sut = makeSUT()
        
        let request = mockRequest()
        sut.execute(request) { _ in }
        
        XCTAssertEqual(session.requests, [request])
    }
    
    func test_resumesDataTask() {
        let sut = makeSUT()
        let dataTask = URLSessionDataTaskSpy()
        session.dataTask = dataTask

        XCTAssertEqual(dataTask.resumeCount, 0)

        sut.execute(mockRequest()) { _ in }

        XCTAssertEqual(dataTask.resumeCount, 1)
    }
    
    func test_completesWithBadRequestError() {
        let codes = Array(400...499)
        assert(expectedError: .badRequest, for: codes)
    }
    
    func test_completesWithServerError() {
        let codes = Array(500...599)
        assert(expectedError: .server, for: codes)
    }
    
    func test_completesWithUnknownError() {
        let codes = [0, 100, 199, 300, 399, 600]
        assert(expectedError: .unknown, for: codes)
    }
    
    func test_completesWithSuccess() {
        let sut = makeSUT()
        var expectedResult: HTTPClientResult?
        var callCount = 0
        sut.execute(mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }

        let expectedData = mockData()

        for (times, code) in (200...299).enumerated() {
            session.complete?(expectedData, mockHTTPResponse(statusCode: code), nil)
            
            switch expectedResult! {
            case .success(let (data)):
                XCTAssertEqual(data, expectedData)
                XCTAssertEqual(callCount, times + 1)
            case .error(_): XCTFail("Should succeed")
            }
        }
    }
    
    // MARK: Helpers
    
    private let session = URLSessionSpy()
    
    private func makeSUT() -> HTTPClient {
        let sut = HTTPClient(session)
        weakSUT = sut
        return sut
    }
    
    private func mockRequest() -> URLRequest {
        return URLRequest(url: mockURL())
    }
    
    private func mockURL() -> URL {
        return URL(string: "https://a-mock.url")!
    }
    
    private func mockError() -> NSError {
        return NSError(domain: "", code: 0, userInfo: nil)
    }
    
    private func mockData() -> Data {
        return "{\"a key\":\"a value\"}".data(using: .utf8)!
    }
    
    private func mockHTTPResponse(statusCode: Int = 12345) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: mockURL(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
            )!
    }
    
    private func assert(expectedError: HTTPClientError, for codes: [Int]) {
        let sut = makeSUT()
        var expectedResult: HTTPClientResult?
        var callCount = 0
        sut.execute(mockRequest()) { result in
            expectedResult = result
            callCount += 1
        }
        
        for (times, code) in codes.enumerated() {
            session.complete?(nil, mockHTTPResponse(statusCode: code), mockError())
            
            switch expectedResult! {
            case .success(_): XCTFail("Should fail with error")
            case .error(let error): XCTAssertEqual(error, expectedError)
            XCTAssertEqual(callCount, times + 1)
            }
        }
    }
    
    private class URLSessionSpy: URLSession {
        var requests = [URLRequest]()
        var dataTask: URLSessionDataTaskSpy = URLSessionDataTaskSpy()
        var complete: ((Data?, URLResponse?, Error?) -> Void)?
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            complete = completionHandler
            requests.append(request)
            return dataTask
        }
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCount = 0
        
        override func resume() {
            resumeCount += 1
        }
    }
}
