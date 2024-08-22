//
//  NoteStatus.swift
//  DomainSharedInterface
//
//  Created by 황인우 on 8/22/24.
//

import Foundation

import Core

public enum NoteStatus: Hashable {
    case draft
    case published
    
    public init(dto: NoteStatusDTO) {
        switch dto {
        case .draft:            self = .draft
        case .published:         self = .published
        }
    }
    
    public var toDTO: NoteStatusDTO {
        switch self {
        case .draft:            return .draft
        case .published:        return .published
        }
    }
}
