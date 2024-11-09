//
//  AuthErrorHandler.swift
//  CoordinatorAppInterface
//
//  Created by 황인우 on 10/31/24.
//

import Shared

import UIKit

public class AuthErrorHandler {
    @KeychainWrapper<UserInformation>(.userInfo)
    private var userInfo
    
    @KeychainWrapper<AccessToken>(.accessToken)
    private var accessToken
    
    @KeychainWrapper<RefreshToken>(.refreshToken)
    private var refreshToken
    
    public init() { }
    
    func deleteUserData() {
        self.userInfo = nil
        self.accessToken = nil
        self.refreshToken = nil
    }
}
