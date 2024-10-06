//
//  NotesHeaderView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/15/24.
//

import FlexLayout
import PinLayout
import Shared

import UIKit

class NotesHeaderView: UICollectionReusableView, Reusable {
    private var flexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "따끈따끈한 노트를 살펴보세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex.define { flex in
            
            // section divider와 header간 padding값을 주기 위한 처리. 추후 다른 방법이 있다면 수정
            flex.addItem().height(24)
            
            flex.addItem(titleLabel)
        }
    }
}


#if canImport(SwiftUI)
import SwiftUI

struct NotesHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        NotesHeaderView(
            frame: .init(x: 0,
            y: 0,
            width: 350,
            height: 24)
        ).showPreview()
    }
}

#endif
