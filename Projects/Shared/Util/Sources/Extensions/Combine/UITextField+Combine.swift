//
//  UITextField+Combine.swift
//  SharedUtil
//
//  Created by 황인우 on 7/17/24.
//

import Combine
import UIKit

public extension UITextField {
    
    // textField에서 editing시작 & 입력값이 변할 때 이벤트를 방출합니다.
    var textPublisher: AnyPublisher<String?, Never> {
        Publishers.ControlProperty(
            control: self,
            events: [.editingDidBegin, .editingChanged],
            keyPath: \.text
        )
        .eraseToAnyPublisher()
    }
    
    // textField의 x버튼 탭 또는 return button tap할 때 이벤트를 방출합니다.
    var editEndPublisher: AnyPublisher<String?, Never> {
        Publishers.ControlProperty(
            control: self,
            events: [.editingDidEnd, .editingDidEndOnExit],
            keyPath: \.text
        )
        .eraseToAnyPublisher()
    }
}
