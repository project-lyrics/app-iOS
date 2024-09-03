//
//  UserInfoStorageInterface.swift
//  CoreLocalStorage
//
//  Created by 황인우 on 9/1/24.
//

import Foundation

import SharedUtil

public protocol UserInfoStorageInterface {
    func read() throws -> UserInformation?
    func save(userInformation: UserInformation) throws
    
    @discardableResult
    func delete() throws -> Bool
}
