//
//  SearchedNotePaginationService.swift
//  DomainNoteInterface
//
//  Created by 황인우 on 9/4/24.
//

import Combine
import Foundation

import DomainSharedInterface

final public class SearchedNotePaginationService: KeywordPaginationServiceInterface {
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
