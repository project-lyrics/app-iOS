//
//  HTTPRequestConfiguring.swift
//  CoreNetwork
//
//  Created by Derrick kim on 4/3/24.
//

import Foundation
import CoreNetworkInterface
import SharedUtil
import SharedUtilInterface

public extension HTTPRequestConfiguring {
    var queryParameters: Encodable? { return nil }
    var bodyParameters: Encodable? { return nil }
    
    func makeURLRequest() throws -> URLRequest {
        guard var urlComponent = try makeURLComponents() else {
            throw NetworkError.URLRequestError.urlComponentError
        }

        if let queryItems = try getQueryParameters() {
            urlComponent.queryItems = queryItems
        }

        guard let url = urlComponent.url else {
            throw NetworkError.URLRequestError.urlComponentError
        }

        var urlRequest = URLRequest(url: url)

        if let httpBody = try getBodyParameters() {
            urlRequest.httpBody = httpBody
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = httpMethod.rawValue

        return urlRequest
    }
}

extension HTTPRequestConfiguring {
    func makeURLComponents() throws -> URLComponents? {
        guard let url = baseURL else {
            throw NetworkError.URLRequestError.makeURLError
        }

        return URLComponents(string: url + path)
    }

    private func getQueryParameters() throws -> [URLQueryItem]? {
        guard let queryParameters else {
            return nil
        }

        guard let queryDictionary = try? queryParameters.toDictionary() else {
            throw NetworkError.URLRequestError.queryEncodingError
        }

        var queryItemList: [URLQueryItem]

        queryItemList = queryDictionary.map {
            URLQueryItem(
                name: $0.key,
                value: "\($0.value)"
            )
        }

        if queryItemList.isEmpty {
            return nil
        }

        return queryItemList
    }

    func getBodyParameters() throws -> Data? {
        guard let bodyParameters else {
            return nil
        }

        guard let bodyDictionary = try? bodyParameters.toDictionary() else {
            throw NetworkError.URLRequestError.bodyEncodingError
        }

        guard let encodedBody = try? JSONSerialization.data(withJSONObject: bodyDictionary) else {
            throw NetworkError.URLRequestError.bodyEncodingError
        }

        return encodedBody
    }
}
