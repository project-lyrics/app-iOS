//
//  Lyrics.swift
//  DomainShared
//
//  Created by 황인우 on 8/17/24.
//

import Core
import Shared

import UIKit

public struct Lyrics: Hashable {
    public let content: String
    public let background: LyricsBackground
    
    public init(content: String, background: LyricsBackground) {
        self.content = content
        self.background = background
    }
    
    public init(dto: LyricsDTO) {
        self.content = dto.lyrics
        self.background = LyricsBackground(dto: dto.background)
    }
}

public enum LyricsBackground: Equatable {
    case `default`
    case skyblue
    case blue
    case lavender
    case mint
    case black
    case beige
    case pinkgreen
    case red
    case white
    case rainbow
    
    public var image: UIImage {
        switch self {
        case .default:          return FeelinImages.image00Default
        case .skyblue:          return FeelinImages.image01Skyblue
        case .blue:             return FeelinImages.image02Blue
        case .lavender:         return FeelinImages.image03Lavender
        case .mint:             return FeelinImages.image04Mint
        case .black:            return FeelinImages.image05Black
        case .beige:            return FeelinImages.image06Beige
        case .pinkgreen:        return FeelinImages.image07Pinkgreen
        case .red:              return FeelinImages.image08Red
        case .white:            return FeelinImages.image09White
        case .rainbow:          return FeelinImages.image10Rainbow
        }
    }
    
    public init(dto: LyricsBackgroundDTO) {
        switch dto {
        case .default:          self = .default
        case .skyblue:          self = .skyblue
        case .blue:             self = .blue
        case .lavender:         self = .lavender
        case .mint:             self = .mint
        case .black:            self = .black
        case .beige:            self = .beige
        case .pinkgreen:        self = .pinkgreen
        case .red:              self = .red
        case .white:            self = .white
        case .rainbow:          self = .rainbow
        }
    }
    
    var toDTO: LyricsBackgroundDTO {
        switch self {
        case .default:          return .default
        case .skyblue:          return .skyblue
        case .blue:             return .blue
        case .lavender:         return .lavender
        case .mint:             return .mint
        case .black:            return .black
        case .beige:            return .beige
        case .pinkgreen:        return .pinkgreen
        case .red:              return .red
        case .white:            return .white
        case .rainbow:          return .rainbow
        }
    }
}
