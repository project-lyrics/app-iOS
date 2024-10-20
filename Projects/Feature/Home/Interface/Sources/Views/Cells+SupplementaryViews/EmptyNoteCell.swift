//
//  EmptyNoteCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/19/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

public final class EmptyNoteCell: UICollectionViewCell, Reusable {
    private let flexContainer = UIView()
    
    private var emptyNoteImageView: UIImageView = {
        let imageView = UIImageView(image: FeelinImages.emptyNote)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 노트가 없어요"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04
        
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        contentView.addSubview(flexContainer)
        contentView.backgroundColor = Colors.background

        flexContainer.flex
            .justifyContent(.center)
            .alignItems(.center)
            .define { flex in
                flex.addItem(emptyNoteImageView)
                    .height(48)
                    .width(78)
                
                flex.addItem(titleLabel)
                    .marginTop(8)
            }
    }
}
