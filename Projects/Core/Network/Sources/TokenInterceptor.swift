//
//  TokenInterceptor.swift
//  CoreNetwork
//
//  Created by 황인우 on 5/31/24.
//

import Combine
import CoreLocalStorageInterface
import CoreNetworkInterface
import Foundation

extension TokenInterceptor: URLRequestInterceptor {
    public func adapt(_ urlRequest: URLRequest) -> AnyPublisher<URLRequest, Error> {
        var request = urlRequest
        
        do {
            guard let accessToken: AccessToken = try tokenStorage.read(key: accessTokenKey) else {
                return Fail(error: NetworkError.urlRequestError(.headerError(reason: "키체인에 저장되어있는 액세스 토큰이 없습니다.")))
                    .eraseToAnyPublisher()
            }
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
            
        } catch let error as KeychainError {
            return Fail(error: NetworkError.requestInterceptError("Token Interceptor에서 액세스 토큰을 불러오는 과정에서 에러가 발생했습니다. 에러: \(error.errorDescription ?? error.localizedDescription)"))
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.requestInterceptError("Token Interceptor에서 알 수 없는 에러가 발생했습니다."))
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
        guard case .clientError(.authorizationError) = error else {
            return Just(.doNotRetry)
                .eraseToAnyPublisher()
        }
        
        var request = request
        
        do {
            guard let refreshToken: RefreshToken = try tokenStorage.read(key: refreshTokenKey) else {
                return Just(.doNotRetryWithError(NetworkError.requestInterceptError("키체인에 저장되어있는 액세스 토큰이 없습니다.")))
                    .eraseToAnyPublisher()
            }
            request.setValue(
                "Bearer \(refreshToken.token)",
                forHTTPHeaderField: "Authorization"
            )
            
            let reissueEndpoint = FeelinAPI<ReissueTokenResponse>.reissueAccessToken(refreshToken: refreshToken.token)
            
            let reissueRequest = try reissueEndpoint.makeURLRequest()
            
            return reissueToken(request: reissueRequest, with: session)
            
        } catch let error as NetworkError {
            return Just(.doNotRetryWithError(error))
                .eraseToAnyPublisher()
            
        } catch let error as KeychainError {
            return Just(.doNotRetryWithError(NetworkError.requestInterceptError("Token Interceptor에서 액세스 토큰을 불러오는 과정에서 에러가 발생했습니다. 에러: \(error.errorDescription ?? error.localizedDescription)")))
                .eraseToAnyPublisher()
        } catch let error as JWTError {
            return Just(.doNotRetryWithError(NetworkError.requestInterceptError("Token Interceptor에서 jwt파싱 과정에서 에러가 발생했습니다. 에러:\(error.errorDescription ?? error.localizedDescription) ")))
                .eraseToAnyPublisher()
        } catch {
            return Just(.doNotRetryWithError(NetworkError.unknownError(error.localizedDescription)))
                .eraseToAnyPublisher()
        }
    }
    
    private func reissueToken(
        request: URLRequest,
        with session: URLSession
    ) -> AnyPublisher<RetryResult, Never> {
        return session
            .dataTaskPublisher(for: request)
            .tryDecodeAPIFailResponse()
            .validateStatusCode()
            .validateJSONValue(to: ReissueTokenResponse.self)
            .map(\.data)
            .tryMap { [jwtDecoder] tokenResponse -> (AccessToken, RefreshToken) in
                return (
                    try jwtDecoder.decode(tokenResponse.accessToken, as: AccessToken.self),
                    try jwtDecoder.decode(tokenResponse.refreshToken, as: RefreshToken.self)
                )
            }
            .tryMap { [accessTokenKey, refreshTokenKey, tokenStorage] (accessToken, refreshToken) -> RetryResult in
                try tokenStorage.save(token: accessToken, for: accessTokenKey)
                try tokenStorage.save(token: refreshToken, for: refreshTokenKey)
                
                return .retry
            }
            .catch { error in
                return Just(.doNotRetryWithError(error))
            }
            .eraseToAnyPublisher()
    }
}
