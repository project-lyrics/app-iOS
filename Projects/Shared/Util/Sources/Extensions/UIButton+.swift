//
//  UIButton+.swift
//  SharedUtil
//
//  Created by 황인우 on 8/15/24.
//

import UIKit

public extension UIButton {
    func setAttributedTitle(
        _ text: String,
        color: UIColor,
        font: UIFont,
        for controlState: UIControl.State
    ) {
        // 새로운 attributed string 생성
        let attributedString = NSMutableAttributedString(string: text)
        
        // 텍스트 색상 설정
        attributedString.addAttributes(
            [NSAttributedString.Key.foregroundColor: color],
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        // 폰트 설정
        attributedString.addAttributes(
            [NSAttributedString.Key.font: font],
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        // 버튼에 attributed title 설정
        self.setAttributedTitle(attributedString, for: controlState)
    }
    
    func setAttributedTitleColor(color: UIColor, for controlState: UIControl.State) {
        if let title = self.titleLabel?.attributedText {
            let attributedString = NSMutableAttributedString( attributedString: title)
            attributedString.removeAttribute(
                .foregroundColor,
                range: NSRange.init(location: 0,
                length: attributedString.length)
            )
            attributedString.addAttributes(
                [NSAttributedString.Key.foregroundColor : color],
                range: NSRange.init(location: 0, length: attributedString.length)
            )
            self.setAttributedTitle(attributedString, for: controlState)
        }
    }

    func setAttributedTitleFont(font: UIFont, for controlState: UIControl.State) {
        if let title = self.titleLabel?.attributedText {
            let attributedString = NSMutableAttributedString( attributedString: title)
            attributedString.removeAttribute(
                .font,
                range: NSRange.init(location: 0,
                length: attributedString.length)
            )
            attributedString.addAttributes(
                [NSAttributedString.Key.font : font ],
                range: NSRange.init(location: 0, length: attributedString.length)
            )
            self.setAttributedTitle(attributedString, for: controlState)
        }
    }
}
