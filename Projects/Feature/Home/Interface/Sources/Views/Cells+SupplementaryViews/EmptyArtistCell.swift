//
//  EmptyArtistCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/26/24.
//

import FlexLayout
import Shared

import Combine
import UIKit

class EmptyArtistCell: UICollectionViewCell, Reusable {
    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - UI Components
    
    private let flexContainer = UIView()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없어요."
        label.textAlignment = .center
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    private (set) var requestArtistButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            "아티스트 요청하기",
            color: Colors.gray09,
            font: SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14),
            for: .normal
        )
        button.contentEdgeInsets = .init(
            top: 10,
            left: 12,
            bottom: 10,
            right: 12
        )
        button.backgroundColor = Colors.gray01
        button.layer.cornerRadius = 8
        
        return button
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
            .alignItems(.center)
            .paddingTop(48%)
            .define { flex in
                flex.addItem(titleLabel)
                
                flex.addItem(requestArtistButton)
                    .marginTop(16)
            }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cancellables = .init()
    }
}
