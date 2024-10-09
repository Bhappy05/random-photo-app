//
//  MockURLProtocol.swift
//  RandomPhotoApp
//
//  Created by Dionis on 09.10.24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var responseData: Data?
    static var statusCode: Int = 200
    
    // Intercept all requests
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let data = MockURLProtocol.responseData {
            let response = HTTPURLResponse(url: request.url!, statusCode: MockURLProtocol.statusCode, httpVersion: nil, headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data) // Provide the mock data for the response
        }
        client?.urlProtocolDidFinishLoading(self) // Indicate that the loading has finished
    }
    override func stopLoading() {
        // No cleanup required for mock
    }
}
