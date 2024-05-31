//
//  MockURLProtocol.swift
//  CoreNetworkTesting
//
//  Created by Derrick kim on 4/10/24.
//

import Foundation
import Combine

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> AnyPublisher<(HTTPURLResponse?, Data?), Error>)?
    private var cancellable: AnyCancellable?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            return
        }

        cancellable = handler(request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // request가 완료되었음을 알린다
                    self.client?.urlProtocolDidFinishLoading(self)

                case .failure(let error):
                    // error를 client에게 전달
                    self.client?.urlProtocol(self, didFailWithError: error)
                }
            }, receiveValue: { response, data in
                // response를 client에게 전달
                self.client?.urlProtocol(
                    self,
                    didReceive: response ?? .init(),
                    cacheStoragePolicy: .notAllowed
                )

                // data를 client에게 전달
                self.client?.urlProtocol(
                    self,
                    didLoad: data ?? .init()
                )
            })
    }

    override func stopLoading() {
        cancellable?.cancel()
        cancellable = nil
    }
}
