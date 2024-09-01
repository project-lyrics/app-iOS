//
//  UserInformation.swift
//  SharedUtil
//
//  Created by 황인우 on 9/1/24.
//

import Foundation

public struct UserInformation: Codable {
    public var userID: Int
    
    public init(userID: Int) {
        self.userID = userID
    }
}
