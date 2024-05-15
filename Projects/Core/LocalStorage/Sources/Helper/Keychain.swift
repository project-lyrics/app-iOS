//
//  Keychain.swift
//  CoreLocalStorageInterface
//
//  Created by 황인우 on 5/15/24.
//

import Foundation
import CoreLocalStorageInterface

struct Keychain {
	struct Option {
		var service: String = ""
	}
	private let option: Option
	
	init(option: Option) {
		self.option = option
	}
	
	init() {
		var option = Option()
		if let bundleIdentifier = Bundle.main.bundleIdentifier {
			option.service = bundleIdentifier
		}
		
		self.init(option: option)
	}
	
	@discardableResult
	func save(
		key: String,
		data: Data
	) throws -> Bool {
		var query = option.query()
		query[kSecValueData] = data
		query[kSecAttrAccount] = key
		
		// 키체인에 아이템 추가
		let addStatus = SecItemAdd(query as CFDictionary, nil)
		
		switch addStatus {
		case errSecSuccess:
			return true
			
		case errSecDuplicateItem:
			return try update(key: key, data: data)
			
		default:
			throw KeychainError(osStatus: addStatus)
		}
	}
	
	private func update(
		key: String,
		data: Data
	) throws -> Bool {
		var updateQuery = option.query()
		updateQuery[kSecAttrAccount] = key
		
		let attributesToUpdate = [kSecValueData: data] as CFDictionary
		let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributesToUpdate)
		
		switch updateStatus {
		case errSecSuccess:
			return true
			
		default:
			throw KeychainError(osStatus: updateStatus)
		}
	}
	
	func read(key: String) throws -> Data {
		var query = option.query()
		query[kSecAttrAccount] = key
		query[kSecReturnData] = true
		
		var result: AnyObject?
		
		let readStatus = SecItemCopyMatching(query as CFDictionary, &result)
		
		switch readStatus {
		case errSecSuccess:
			guard let data = result as? Data else {
				throw KeychainError.other(readStatus)
			}
			return data
			
		default:
			throw KeychainError(osStatus: readStatus)
		}
	}
	
	@discardableResult
	func delete(key: String) throws -> Bool {
		var query = option.query()
		query[kSecAttrAccount] = key
		
		let deleteStatus = SecItemDelete(query as CFDictionary)
		
		switch deleteStatus {
		case errSecSuccess:
			return true
			
		default:
			throw KeychainError(osStatus: deleteStatus)
		}
	}
}

// MARK: - KeyChain.Option
extension Keychain.Option {
	func query() -> [CFString: Any] {
		// MARK: - cloud 싱크, generic internet 관련 쿼리는 현재 필요 없어서 구현x
		var query: [CFString: Any] = [:]
		query[kSecClass] = kSecClassGenericPassword
		query[kSecAttrService] = service
		
		return query
	}
}
