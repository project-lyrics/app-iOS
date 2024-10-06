//
//  CommentHeaderView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/14/24.
//

import FlexLayout
import Shared

import UIKit

class CommentHeaderView: UICollectionReusableView, Reusable {
    
    // MARK: - UI components
    
    private var flexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    private (set) var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.primary
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
        
        flexContainer.flex
            .define { flex in
                flex.addItem()
                    .height(8)
                    .width(100%)
                    .backgroundColor(Colors.backgroundTertiary)
                
                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(titleLabel)
                            .paddingRight(3)
                        
                        flex.addItem(commentCountLabel)
                            .grow(1)
                    }
                    .paddingHorizontal(20)
                    .paddingTop(24)
            }
    }
    
    func configureCommentCount(_ count: Int) {
        self.commentCountLabel.text = count.shortenedText()
        self.commentCountLabel.flex.markDirty()
        
        self.flexContainer.flex.layout()
    }
}
