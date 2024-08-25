//
//  UIView+Combine.swift
//  SharedUtil
//
//  Created by Derrick kim on 8/21/24.
//

import Combine
import UIKit

public extension UIView {
    // UIView에서 터치 이벤트를 감지하고 방출하는 퍼블리셔
    var tapPublisher: AnyPublisher<Void, Never> {
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true // UIView가 터치 이벤트를 받을 수 있도록 설정

        return tapGesture.publisher
            .map { _ in () } // 이벤트 방출 시 Void로 변환
            .eraseToAnyPublisher()
    }
}
