//
//  SongPaginationService.swift
//  DomainSharedInterface
//
//  Created by Derrick kim on 9/3/24.
//

import Combine
import Foundation

import Combine
import Foundation

public protocol SongPaginationServiceInterface: AnyObject {
    var currentSearchWord: String { get }
    var isLoading: Bool { get }
    var currentPage: Int { get }
    var hasNextPage: Bool { get }

    func update(currentPage: Int, hasNextPage: Bool)
    func setLoading(_ loading: Bool)
    func setCurrentSearchWord(_ word: String)
    func resetPagination()
}

public final class SongPaginationService: SongPaginationServiceInterface {
    public private(set) var currentSearchWord: String = ""
    public private(set) var currentPage: Int = 0
    public private(set) var hasNextPage: Bool = true
    public private(set) var isLoading: Bool = false

    private let lock = NSLock()

    public init() { }

    public func update(currentPage: Int, hasNextPage: Bool) {
        lock.lock()
        defer { lock.unlock() }

        self.currentPage = currentPage
        self.hasNextPage = hasNextPage
    }

    public func setLoading(_ loading: Bool) {
        lock.lock()
        defer { lock.unlock() }

        self.isLoading = loading
    }

    public func setCurrentSearchWord(_ word: String) {
        lock.lock()
        defer { lock.unlock() }

        self.currentSearchWord = word
    }

    // 상태 초기화 메서드 추가
    public func resetPagination() {
        lock.lock()
        defer { lock.unlock() }

        self.currentSearchWord = ""
        self.currentPage = 0
        self.hasNextPage = true
        self.isLoading = false
    }
}
