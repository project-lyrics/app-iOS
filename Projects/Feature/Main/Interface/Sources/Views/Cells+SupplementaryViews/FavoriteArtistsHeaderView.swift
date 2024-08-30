//
//  FavoriteArtistsHeaderView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 8/15/24.
//

import FlexLayout
import PinLayout
import Shared

import UIKit

class FavoriteArtistsHeaderView: UICollectionReusableView, Reusable {
    private var flexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 관심 아티스트"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    private (set) var viewAllButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            "전체보기",
            color:Colors.active,
            font: SharedDesignSystemFontFamily.Pretendard.bold.font(size: 16),
            for: .normal
        )
        button.setAttributedTitleColor(color: Colors.disabled, for: .disabled)
        button.isEnabled = false
        return button
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
        
        flexContainer.flex.direction(.row).define { flex in
            flex.addItem(titleLabel)
                .grow(1)
            
            flex.addItem(viewAllButton)
        }
        .paddingRight(20)
    }
}


#if canImport(SwiftUI)
import SwiftUI

struct FavoriteArtistsHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        FavoriteArtistsHeaderView(
            frame: .init(x: 0,
            y: 0,
            width: 350,
            height: 24)
        ).showPreview()
    }
}

#endif
