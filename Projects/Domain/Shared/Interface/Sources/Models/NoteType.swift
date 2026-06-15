//
//  NoteType.swift
//  DomainSharedInterface
//
//  Created by 황인우 on 6/15/26.
//

import Foundation

import Core

public enum NoteType: Hashable {
    case free
    case question
    case lyricsAnalysis

    public init(dto: NoteTypeDTO) {
        switch dto {
        case .free:             self = .free
        case .question:         self = .question
        case .lyricsAnalysis:   self = .lyricsAnalysis
        }
    }

    public var toDTO: NoteTypeDTO {
        switch self {
        case .free:             return .free
        case .question:         return .question
        case .lyricsAnalysis:   return .lyricsAnalysis
        }
    }
}
