//
//  CombineKeyboard.swift
//  SharedUtil
//
//  Created by 황인우 on 7/19/24.
//

import Combine
import UIKit

public struct CombineKeyboard {
    static public var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map({ notification in
                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                
                return keyboardFrame?.height ?? 0
            })

        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        
        return Publishers.MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
