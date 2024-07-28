//
//  MockTokenInterceptor.swift
//  FeatureMainTesting
//
//  Created by 황인우 on 7/19/24.
//

import Core

import Combine
import Foundation

final public class MockTokenInterceptor: URLRequestInterceptor {
    public init() { }
    
    public func adapt(_ urlRequest: URLRequest) -> AnyPublisher<URLRequest, Error> {
        var request = urlRequest
        
        // MARK: - Example 앱에서 서버 관련 기능을 테스트할 때, DEV용 토큰을 주입하면 정상적으로 데이터를 불러올 수 있는지 확인할 수 있습니다. Bearer 뒤에 한 칸 띄우고 토큰을 입력하여 사용하세요.
        // MARK: - [WARNING]: DEV용 토큰이지만 깃허브에는 올리지 않도록 유의해야 합니다.
        
        request.setValue(
            "Bearer  <Notion → Developer → APIDocs → DEV 토큰 페이지 참고>",
            forHTTPHeaderField: "Authorization"
        )
        
        return Just(request)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func retry(
        with session: URLSession,
        _ request: URLRequest,
        dueTo error: NetworkError
    ) -> AnyPublisher<RetryResult, Never> {
        return Just(RetryResult.doNotRetry)
            .eraseToAnyPublisher()
    }
}
