//
//  AppLogger.swift
//  SharedUtil
//
//  Created by 황인우 on 11/9/24.
//

import OSLog

public struct AppLogger {
    public static func log(
        tag: LogTag = .debug,
        _ items: Any...,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        separator: String = " "
    ) {
        
        let shortFileName = URL(string: file)?.lastPathComponent ?? "---"
        
        let output = items.map {
            if let itm = $0 as? CustomStringConvertible {
                return "\(itm.description)"
            } else {
                return "\($0)"
            }
        }
            .joined(separator: separator)
        
        var msg = "\(tag.label) "
        let category = "\(shortFileName) - \(function) - line \(line)"
        if !output.isEmpty { msg += "\n\(output)" }
        
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "--", category: category)
        
        switch tag {
        case .error   : logger.error("\(msg)")
        case .warning : logger.warning("\(msg)")
        case .success : logger.info("\(msg)")
        case .debug   : logger.debug("\(msg)")
        case .network : logger.info("\(msg)")
        case .simOnly : logger.info("\(msg)")
        }
    }
}
