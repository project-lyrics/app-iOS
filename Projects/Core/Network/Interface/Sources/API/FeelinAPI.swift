//
//  FeelinAPI.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//


import Foundation

public enum FeelinAPI<R> {
    case login(
        oauthProvider: OAuthProvider,
        oauthAccessToken: String
    )
}

extension FeelinAPI: HTTPNetworking {
    public var headers: [String : String]? {
        var defaultHeader = [ "application/json": "Content-Type"]
        
        switch self {
        case .login(_, oauthAccessToken: let oAuthAccessToken):
            defaultHeader["Authorization"] = "Bearer \(oAuthAccessToken)"
            
        case .reissueAccessToken(refreshToken: let refreshToken):
            defaultHeader["Authorization"] = "Bearer \(refreshToken)"
        
        default:
            return defaultHeader
        }
        
        return defaultHeader
    }
    
    public var queryParameters: Encodable? {
        return nil
    }
    
    public var bodyParameters: Encodable? {
        switch self {
        case .login(let oauthProvider, _):
            return ["auth_provider": oauthProvider.rawValue]
        
        default:
            return nil
        }
    }
    
    public typealias Response = R

    public var baseURL: String? {
        guard let baseURL = Bundle.main.infoDictionary?["Feelin_URL"] as? String else {
            // MARK: - 추후 임시 도메인주소라도 넣어줘야 한다. 테스트하기 위해 nil 대신 일단 임시 설정
            return "www.feelin.com"
        }

        return baseURL
    }

    public var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login"
        }
    }

    public var httpMethod: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
}
