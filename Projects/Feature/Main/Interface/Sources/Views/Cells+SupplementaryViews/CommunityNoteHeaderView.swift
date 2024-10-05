//
//  CommunityNoteHeaderView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 10/1/24.
//

import FlexLayout
import Shared

import UIKit

class CommunityNoteHeaderView: UICollectionReusableView, Reusable {
    
    // MARK: - UI components
    
    private var flexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "노트"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    private (set) var includeNoteButton: IncludeNoteButton = .init()
    
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
            .paddingVertical(20)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(titleLabel)
                            .paddingRight(3)
                            .grow(1)
                        
                        flex.addItem(includeNoteButton)
                    }
                    .paddingHorizontal(20)
                
                flex.addItem()
                    .height(1)
                    .width(100%)
                    .backgroundColor(Colors.backgroundTertiary)
                    .marginTop(20)
            }
    }
}
