//
//  TokenInterceptorTestDoubles.swift
//  CoreNetwork
//
//  Created by 황인우 on 5/29/24.
//

import Combine
import CoreNetworkInterface
import CoreLocalStorageInterface
import Shared

import Foundation

final public class MockTokenInterceptor: URLRequestInterceptor {
    public var request: URLRequest?
    public var adaptMethodCalled: Bool = false
    public var retryMethodCalled: Bool = false
    
    public let dummyAccessTokenKey: String = "DummyFeelinAccessTokenKey"
    public let dummyRefreshTokenKey: String = "DummyFeelinRefreshTokenKey"
    private let tokenStorage: TokenStorageInterface
    
    init(tokenStorage: TokenStorageInterface) {
        self.tokenStorage = tokenStorage
    }
    
    public func adapt(_ urlRequest: URLRequest) -> AnyPublisher<URLRequest, Error> {
        self.adaptMethodCalled = true
        var request = urlRequest
        
        do {
            guard let accessToken: AccessToken = try tokenStorage.read(key: dummyAccessTokenKey) else {
                return Fail(error: NetworkError.urlRequestError(.headerError(reason: "키체인에 저장되어있는 액세스 토큰이 없습니다.")))
                    .eraseToAnyPublisher()
            }
            request.setValue(
                "Bearer \(accessToken.token)",
                forHTTPHeaderField: "Authorization"
            )
            self.request = request
            
        } catch let error as KeychainError {
            return Fail(error: NetworkError.urlRequestError(.headerError(reason: "액세스 토큰을 불러오는 과정에서 에러가 발생했습니다. 에러: \(error.errorDescription ?? error.localizedDescription)")))
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.unknownError(error.localizedDescription))
                .eraseToAnyPublisher()
        }
        
        return Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func retry(
        with session: URLSession,
        _ request: URLRequest,
        dueTo error: NetworkError
    ) -> AnyPublisher<RetryResult, Never> {
        self.retryMethodCalled = true
        
        return Just(.doNotRetry)
            .eraseToAnyPublisher()
    }
}
