//
//  UILabel+.swift
//  SharedUtil
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

extension UILabel {
    public func setTextWithLineHeight(_ text: String?, lineHeight: CGFloat) {
        guard let text else { return }
        
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style
        ]
        
        let attrString = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        self.attributedText = attrString
        self.numberOfLines = 0
    }
}
