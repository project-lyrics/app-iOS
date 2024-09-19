//
//  KeywordPaginationServiceInterface.swift
//  DomainShared
//
//  Created by 황인우 on 9/4/24.
//

import Foundation

public protocol KeywordPaginationServiceInterface: AnyObject {
    var currentSearchWord: String { get }
    var isLoading: Bool { get }
    var currentPage: Int? { get }
    var hasNextPage: Bool { get }
    
    func update(currentPage: Int?, hasNextPage: Bool)
    func setLoading(_ loading: Bool)
    func setCurrentSearchWord(_ word: String)
}
