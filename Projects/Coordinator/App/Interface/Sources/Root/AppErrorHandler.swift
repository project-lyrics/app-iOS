//
//  AppErrorHandler.swift
//  CoordinatorAppInterface
//
//  Created by 황인우 on 10/31/24.
//

import Shared

import UIKit

public protocol AppErrorHandlerInterface: AnyObject {
    func deleteUserData()
    func goToUpdate(data: AnyType?)
}

public class AppErrorHandler: AppErrorHandlerInterface {
    @KeychainWrapper<UserInformation>(.userInfo)
    private var userInfo
    
    @KeychainWrapper<AccessToken>(.accessToken)
    private var accessToken
    
    @KeychainWrapper<RefreshToken>(.refreshToken)
    private var refreshToken
    
    public init() { }
    
    public func deleteUserData() {
        self.userInfo = nil
        self.accessToken = nil
        self.refreshToken = nil
    }

    public func goToUpdate(data: AnyType?) {
        if let appStoreURLResponse = data?.object(type: AppStoreURLResponse.self),
           let appStoreURL = URL(string: appStoreURLResponse.appStoreUrl) {
            self.openAppStore(url: appStoreURL)
        } else {
            guard let bundleID = Bundle.main.bundleIdentifier,
                  let appStoreURL = URL(string:"http://itunes.apple.com/kr/lookup?bundleId=\(bundleID)")
            else {
                AppLogger.log(tag: .error, "missing BundleID or invalidAppStoreURL: \(String(describing: Bundle.main.bundleIdentifier))")
                return
            }
            
            openAppStore(url: appStoreURL)
        }
    }
    
    private func openAppStore(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url) { [weak self] _ in
                self?.terminateAppOnUpdate()
            }
        } else {
            AppLogger.log(tag: .error,"failed to open appStoreURL: \(url)")
        }
    }
    
    private func terminateAppOnUpdate() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
