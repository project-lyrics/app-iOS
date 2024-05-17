//
//  Images.swift
//  SharedDesignSystem
//
//  Created by Derrickkim on 2024/02/18.
//

import UIKit

public extension UIFont {
    static func pretendard(size fontSize: CGFloat, type: PretendardFontType) -> UIFont {
        return UIFont(name: "\(type.name)", size: fontSize) ?? .init()
    }

    static func encodeSans(size fontSize: CGFloat, type: EncodeSansFontType) -> UIFont {
        return UIFont(name: "\(type.name)", size: fontSize) ?? .init()
    }
}

public extension UIFont {
    enum PretendardFontType {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case semiBold
        case thin

        public var name : String {
            switch self {
            case .black:
                return "Pretendard-Black"
            case .bold:
                return "Pretendard-Bold"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .extraLight:
                return "Pretendard-ExtraLight"
            case .light:
                return "Pretendard-Light"
            case .medium:
                return "Pretendard-Medium"
            case .semiBold:
                return "Pretendard-SemiBold"
            case .thin:
                return "Pretendard-Thin"
            }
        }
    }

    enum EncodeSansFontType {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case regular
        case semiBold
        case thin

        public var name : String {
            switch self {
            case .black:
                return "EncodeSans-Black"
            case .bold:
                return "EncodeSans-Bold"
            case .extraBold:
                return "EncodeSans-ExtraBold"
            case .extraLight:
                return "EncodeSans-ExtraLight"
            case .light:
                return "EncodeSans-Light"
            case .medium:
                return "EncodeSans-Medium"
            case .regular:
                return "EncodeSans-Regular"
            case .semiBold:
                return "EncodeSans-SemiBold"
            case .thin:
                return "EncodeSans-Thin"
            }
        }
    }
}
