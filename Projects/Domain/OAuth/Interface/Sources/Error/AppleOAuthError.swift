//
//  AppleOAuthError.swift
//  DomainOAuthInterface
//
//  Created by 황인우 on 6/3/24.
//

import Foundation

public enum AppleOAuthError: LocalizedError {
    case unknown
    case canceled
    case invalidResponse
    case notHandled
    case failed
    case notInteractive
    case tokenMissing
    case otherError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .unknown:                  return "The authorization attempt failed for an unknown reason."
        case .canceled:                 return "The user canceled the authorization attempt."
        case .invalidResponse:          return "The authorization request received an invalid response."
        case .notHandled:               return "The authorization request wasn’t handled."
        case .failed:                   return "The authorization attempt failed."
        case .notInteractive:           return "The authorization request isn’t interactive."
        case .tokenMissing:             return "The identity token is missing"
        case .otherError(let error):    return "The authorization error with other error: \(error.localizedDescription)"
        }
    }
    
    public var errorMessage: String {
        return errorDescription ?? "unknown appleOAuthError: \(self.localizedDescription)"
    }
    
    public init(error: Error) {
        switch (error as NSError).code {
        case 1000:      self = .unknown
        case 1001:      self = .canceled
        case 1002:      self = .invalidResponse
        case 1003:      self = .notHandled
        case 1004:      self = .failed
        case 1005:      self = .notInteractive
        default:        self = .otherError(error)
        }
    }
}
