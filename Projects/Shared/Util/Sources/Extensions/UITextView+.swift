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
    func isThirdLineExceedingWidth() -> Bool {
        // 텍스트를 줄 단위로 나누고, 3번째 줄이 있는지 확인
        let lines = self.text.components(separatedBy: .newlines)
        guard lines.count >= 3 else { return false } // 3번째 줄이 없으면 제한하지 않음

        // 3번째 줄 텍스트 추출
        let thirdLineText = lines[2]

        // 3번째 줄 텍스트 너비 계산
        let attributes: [NSAttributedString.Key: Any] = [.font: self.font ?? UIFont.systemFont(ofSize: 14)]
        let thirdLineWidth = ceil((thirdLineText as NSString).size(withAttributes: attributes).width)

        // UITextView의 실제 너비와 비교 (반올림 적용)
        let textViewWidth = ceil(self.bounds.width - self.textContainerInset.left - self.textContainerInset.right)
        return thirdLineWidth > textViewWidth - 10
    }
}
