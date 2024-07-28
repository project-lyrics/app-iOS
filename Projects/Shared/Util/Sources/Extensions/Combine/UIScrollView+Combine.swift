//
//  UIScrollView+Combine.swift
//  SharedUtil
//
//  Created by 황인우 on 7/14/24.
//

import Combine
import UIKit

public extension UIScrollView {
    var contentOffsetPublisher: AnyPublisher<CGPoint, Never> {
        return publisher(for: \.contentOffset)
            .eraseToAnyPublisher()
    }
    
    func didScrollToBottomPublisher(offset: CGFloat = 0) -> AnyPublisher<Void, Never> {
        return contentOffsetPublisher
            .map { [weak self] contentOffset -> Bool in
                guard let strongSelf = self else {
                    return false
                }
                
                // 보이는 영역 == 스크롤뷰의 전체 높이에서 위 & 아래 contentInset을뺀 값
                let visibleHeight = strongSelf.frame.height - strongSelf.contentInset.top - strongSelf.contentInset.bottom
                
                // 스크롤된 수직 거리
                let scrollPosition = contentOffset.y + strongSelf.contentInset.top
                
                // 가장 밑에 도달하는 임계점
                let didEnterBottom = max(
                    offset,
                    strongSelf.contentSize.height - visibleHeight
                )
                
                return scrollPosition > didEnterBottom
            }
            .removeDuplicates()
            // true인 경우에만 이벤트 방출
            .filter { $0 }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
