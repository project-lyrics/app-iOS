//
//  KeychainError.swift
//  CoreLocalStorageInterface
//
//  Created by 황인우 on 5/15/24.
//

import Foundation

public enum KeychainError: LocalizedError {
    case functionNotImplemented
    case invalidParameters
    case memoryAllocationError
    case keychainNotAvailable
    case duplicateItem
    case itemNotFound
    case interactionNotAllowed
    case decodingError
    case authenticationFailed
    case other(OSStatus)
    
    public init(osStatus: OSStatus) {
        switch osStatus {
        case errSecUnimplemented:
            self = .functionNotImplemented
        case errSecParam:
            self = .invalidParameters
        case errSecAllocate:
            self = .memoryAllocationError
        case errSecNotAvailable:
            self = .keychainNotAvailable
        case errSecDuplicateItem:
            self = .duplicateItem
        case errSecItemNotFound:
            self = .itemNotFound
        case errSecInteractionNotAllowed:
            self = .interactionNotAllowed
        case errSecDecode:
            self = .decodingError
        case errSecAuthFailed:
            self = .authenticationFailed
        default:
            self = .other(osStatus)
        }
    }
    
    public var errorDescription: String {
        switch self {
        case .functionNotImplemented:
            return "기능 또는 작업이 구현되지 않았습니다."
        case .invalidParameters:
            return "함수에 전달된 하나 이상의 매개변수가 유효하지 않습니다."
        case .memoryAllocationError:
            return "메모리를 할당하지 못했습니다."
        case .keychainNotAvailable:
            return "사용할 수 있는 키체인이 없습니다. 디바이스를 다시 시작해야 할 수도 있습니다."
        case .duplicateItem:
            return "지정된 항목이 키체인에 이미 존재합니다."
        case .itemNotFound:
            return "지정된 항목을 키체인에서 찾을 수 없습니다."
        case .interactionNotAllowed:
            return "사용자 상호 작용이 허용되지 않습니다."
        case .decodingError:
            return "제공된 데이터를 디코딩할 수 없습니다."
        case .authenticationFailed:
            return "입력한 사용자 이름 또는 암호가 올바르지 않습니다."
        case .other(let osStatus):
            if let errorMessage = SecCopyErrorMessageString(osStatus, nil) as? String {
                return errorMessage
            } else {
                return "예상치 못한 에러가 발생했습니다. OSStatus: \(osStatus)"
            }
        }
    }
}
