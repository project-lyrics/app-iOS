//
//  EmptyCommentCell.swift
//  FeatureHomeTesting
//
//  Created by 황인우 on 9/16/24.
//

import UIKit

import Shared

class EmptyCommentCell: UICollectionViewCell, Reusable {
    private let flexContainer = UIView()
    
    private var emptyNoteImageView: UIImageView = {
        let imageView = UIImageView(image: FeelinImages.emptyNote)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글이 없어요.\n 가장 먼저 댓글을 달아볼까요?"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
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
