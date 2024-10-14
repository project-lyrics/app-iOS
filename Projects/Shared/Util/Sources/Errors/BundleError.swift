//
//  BundleError.swift
//  SharedUtil
//
//  Created by 황인우 on 6/13/24.
//

import Foundation

public enum BundleError: LocalizedError, Equatable {
    case missingItem(itemName: String)
    
    public var errorDescription: String? {
        switch self {
        case .missingItem(let itemName):
            return "\(itemName) is missing from the bundle"
        }
    }
    
    public var errorMessage: String {
        return errorDescription ?? "unknown bundle error"
    }
}
