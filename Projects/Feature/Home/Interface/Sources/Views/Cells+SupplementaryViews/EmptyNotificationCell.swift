//
//  EmptyNotificationCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/29/24.
//

import Shared

import UIKit

class EmptyNotificationCell: UICollectionViewCell, Reusable {
    
    // MARK: - UI
    
    private let flexContainer = UIView()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 알림이 없어요"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        contentView.addSubview(flexContainer)
        
        flexContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { flex in
                flex.addItem(titleLabel)
            }
    }
}
