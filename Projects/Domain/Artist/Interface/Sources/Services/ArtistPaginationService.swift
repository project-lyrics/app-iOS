//
//  ArtistPaginationService.swift
//  DomainArtist
//
//  Created by 황인우 on 7/15/24.
//

import Combine
import Foundation

public protocol ArtistPaginationServiceInterface: AnyObject {
    var currentSearchWord: String { get }
    var isLoading: Bool { get }
    var currentPage: Int? { get }
    var hasNextPage: Bool { get }
    
    func update(currentPage: Int?, hasNextPage: Bool)
    func setLoading(_ loading: Bool)
    func setCurrentSearchWord(_ word: String)
}

final public class ArtistPaginationService: ArtistPaginationServiceInterface {
    public var currentSearchWord: String = ""
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
    
    public func setCurrentSearchWord(_ word: String) {
        lock.lock()
        defer {
            self.lock.unlock()
        }
        
        self.currentSearchWord = word
    }
}
