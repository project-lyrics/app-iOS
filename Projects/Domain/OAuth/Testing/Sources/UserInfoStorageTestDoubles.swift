//
//  UserInfoStorageTestDoubles.swift
//  DomainOAuthTesting
//
//  Created by 황인우 on 9/1/24.
//

import Combine
import Core
import Foundation

public class FakeUserInfoStorage: UserInfoStorageInterface {
    private (set) public var userInfo: UserInformation?
    
    public func read() throws -> UserInformation? {
        return userInfo
    }
    
    public func save(userInformation: UserInformation) throws {
        userInfo = userInformation
    }
    
    public func delete() throws -> Bool {
        userInfo = nil
        
        return true
    }
}
