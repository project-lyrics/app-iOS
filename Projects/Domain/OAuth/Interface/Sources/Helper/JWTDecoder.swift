//
//  JWTTokenParser.swift
//  DomainOAuth
//
//  Created by 황인우 on 5/27/24.
//

import CoreLocalStorageInterface
import Foundation

public struct JWTDecoder {
    private func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padLength = (4 - base64.count % 4) % 4
        base64.append(contentsOf: repeatElement("=", count: padLength))
        
        return Data(base64Encoded: base64)
    }
    
    public func decode<Token: TokenType>(
        _ jwtTokenString: String,
        as tokenType: Token.Type
    ) throws -> Token {
        let segments = jwtTokenString.split(separator: ".")
        guard segments.count == 3 else {
            throw JWTError.invalidFormat
        }
        
        let payloadSegment = String(segments[1])
        guard let payloadData = base64UrlDecode(payloadSegment) else {
            throw JWTError.decodePayloadSegmentError
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payload = json as? [String: Any],
              let exp = payload["exp"] as? TimeInterval else {
            throw JWTError.parsePayloadJSONError
        }
        
        let expDate = Date(timeIntervalSince1970: exp)
        let token = Token(
            token: jwtTokenString,
            expiration: expDate
        )
        
        return token
    }
}
