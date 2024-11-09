//
//  AnyType.swift
//  SharedUtil
//
//  Created by 황인우 on 11/9/24.
//

import Foundation

public enum AnyType: Codable, Equatable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case data(Data)
    case array([AnyType])
    case dictionary([String: AnyType])
    case null
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .null
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let data = try? container.decode(Data.self) {
            self = .data(data)
        } else if let array = try? container.decode([AnyType].self) {
            self = .array(array)
        } else if let dict = try? container.decode([String: AnyType].self) {
            self = .dictionary(dict)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "AnyCodable value cannot be decoded"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case .bool(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .array(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        case .data(let value):
            try container.encode(value)
        }
    }
}

public extension AnyType {
    var string: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    var int: Int? {
        if case .int(let value) = self {
            return value
        }
        return nil
    }
    
    var double: Double? {
        switch self {
        case .double(let value):
            return value
        case .int(let value):
            return Double(value)
        default:
            return nil
        }
    }
    
    var bool: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    var array: [AnyType]? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    
    var dictionary: [String: AnyType]? {
        if case .dictionary(let value) = self {
            return value
        }
        return nil
    }
    
    var isNull: Bool {
        if case .null = self {
            return true
        }
        return false
    }
    
    var data: Data? {
        if case .data(let value) = self {
            return value
        }
        return nil
    }
    
    func object<T: Decodable>(type: T.Type) -> T? {
        switch self {
        case .data(let value):
            return try? JSONDecoder().decode(type, from: value)
        case .dictionary:
            return try? JSONDecoder().decode(type, from: JSONEncoder().encode(self))
        default:
            return nil
        }
    }
}
