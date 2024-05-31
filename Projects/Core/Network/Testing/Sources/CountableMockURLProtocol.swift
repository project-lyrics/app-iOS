//
//  CountableMockURLProtocol.swift
//  CoreNetwork
//
//  Created by 황인우 on 5/31/24.
//

import Foundation

class CountableMockURLProtocol: URLProtocol {
    static var requestHandlers: [((URLRequest) -> (HTTPURLResponse, Data?))] = []
    private static var requestCount = 0

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard CountableMockURLProtocol.requestCount < CountableMockURLProtocol.requestHandlers.count else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        let handler = CountableMockURLProtocol.requestHandlers[CountableMockURLProtocol.requestCount]
        CountableMockURLProtocol.requestCount += 1
        let (response, data) = handler(request)

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    static func reset() {
        requestCount = 0
        requestHandlers = []
    }
}

