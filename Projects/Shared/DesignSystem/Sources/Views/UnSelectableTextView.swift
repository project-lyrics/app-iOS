//
//  UnSelectableTextView.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 10/12/24.
//

import UIKit

public final class UnSelectableTextView: UITextView {
    override public func point(
        inside point: CGPoint,
        with event: UIEvent?
    ) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        
        guard let range = tokenizer.rangeEnclosingPosition(
            pos,
            with: .character,
            inDirection: .layout(.left)
        ) else { return false }
        
        let startIndex = offset(
            from: beginningOfDocument,
            to: range.start
        )
        
        return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
    }
    override public var selectedTextRange: UITextRange? {
        get { return nil }
        set {}
    }
    
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
           tapGestureRecognizer.numberOfTapsRequired == 1 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer,
           longPressGestureRecognizer.minimumPressDuration < 0.325 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        gestureRecognizer.isEnabled = false
        return false
    }
}
