//
//  LogType.swift
//  SharedUtil
//
//  Created by 황인우 on 11/9/24.
//

import Foundation

public enum LogTag {
    case error
    case warning
    case success
    case debug
    case network
    case simOnly
    
    public var label: String {
        switch self {
        case .error   : return "[APP ERROR 🔴]"
        case .warning : return "[APP WARNING 🟠]"
        case .success : return "[APP SUCCESS 🟢]"
        case .debug   : return "[APP DEBUG 🔵]"
        case .network : return "[APP NETWORK 🌍]"
        case .simOnly : return "[APP SIMULATOR ONLY 🤖]"
        }
    }
}
