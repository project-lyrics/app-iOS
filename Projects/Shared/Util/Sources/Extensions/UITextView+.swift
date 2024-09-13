//
//  UITextView+.swift
//  SharedUtil
//
//  Created by Derrick kim on 9/6/24.
//

import UIKit

public extension UITextView {
    func numberOfLine() -> Int {
        let layoutManager = self.layoutManager

        var numberOfLines = 0
        var index = 0

        while index < layoutManager.numberOfGlyphs {
            var range = NSRange(location: 0, length: 0)
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &range)
            numberOfLines += 1
            index = NSMaxRange(range)
        }

        return numberOfLines
    }
}
