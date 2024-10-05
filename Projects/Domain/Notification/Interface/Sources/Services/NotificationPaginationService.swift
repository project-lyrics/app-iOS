//
//  NotificationPaginationService.swift
//  DomainNotification
//
//  Created by 황인우 on 10/5/24.
//

import Combine
import Foundation

public protocol NotificationPaginationServiceInterface: AnyObject {
    var isLoading: Bool { get }
    var currentPage: Int? { get }
    var hasNextPage: Bool { get }
    
    func update(currentPage: Int?, hasNextPage: Bool)
    func setLoading(_ loading: Bool)
}

final public class NotificationPaginationService: NotificationPaginationServiceInterface {
    public var currentPage: Int?
    public var hasNextPage: Bool = true
    public var isLoading: Bool = false
    
    private let lock = NSLock()
    
    public init() { }
    
    public func update(currentPage: Int?, hasNextPage: Bool) {
        lock.lock()
        defer {
            self.lock.unlock()
        }
        
        self.currentPage = currentPage
        self.hasNextPage = hasNextPage
    }
    
    public func setLoading(_ loading: Bool) {
        lock.lock()
        defer {
            self.lock.unlock()
        }
        
        self.isLoading = loading
    }
}
