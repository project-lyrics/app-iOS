//
//  NotesFilterCell.swift
//  FeatureHomeInterface
//
//  Created by 김지나 on 9/8/25.
//

import UIKit
import Shared
import FlexLayout
import PinLayout
import Combine

class NotesFilterView: UICollectionReusableView, Reusable {
    private var cancellables: Set<AnyCancellable> = .init()
    private let scrollView = UIScrollView()
    private let container = UIView()
    private let buttons = [UIButton(), UIButton(), UIButton()]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawUI()
        bindAction()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.pin.all()
        container.pin.topLeft()
        container.flex.layout(mode: .adjustWidth)
        scrollView.contentSize = CGSize(width: container.frame.width,
                                        height: max(container.frame.height,
                                                    scrollView.bounds.height))
    }
    
    private func drawUI() {
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        let buttonHeight: CGFloat = 32
        let buttonRightMargin: CGFloat = 8
        
        let font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        let filterAllTitle = "전체"
        let filterAllImage = FeelinImages.filterAll.withRenderingMode(.alwaysTemplate)
        let popularTitle = "인기"
        let popularImage = FeelinImages.popular.withRenderingMode(.alwaysTemplate)
        let interestArtistTitle = "관심 아티스트"
        let interestArtistImage = FeelinImages.heartInactive.withRenderingMode(.alwaysTemplate)
        let titles = [filterAllTitle, popularTitle, interestArtistTitle]
        let images = [filterAllImage, popularImage, interestArtistImage]
        
        scrollView.flex.define { flex in
            flex.addItem(container).define { flex in
                flex.direction(.row)
                flex.alignItems(.center)
                
                for idx in 0 ..< buttons.count {
                    var btn = buttons[idx]
                    let title = titles[idx]
                    let image = images[idx]
                    
                    btn = configure(button: btn, title: title, image: image, font: font)
                    
                    flex.addItem(btn)
                        .height(buttonHeight)
                        .grow(1)
                        .marginRight(buttonRightMargin)
                }
            }
        }
    }
    
    private func configure(button: UIButton, title: String, image: UIImage, font: UIFont) -> UIButton {
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.gray02.cgColor
        button.setImage(image, for: .normal)

        button.configuration = .plain()
        button.configuration?.imagePadding = 4
        
        button.tintColor = Colors.gray03
        button.setAttributedTitle(title, color: Colors.gray05, font: font, for: .normal)
        
        return button
    }
    
    private func bindAction() {
        for idx in 0 ..< buttons.count {
            let btn = buttons[idx]
            
            btn.publisher(for: .touchUpInside)
                .sink { [weak self] _ in
                    // 동작
                }
                .store(in: &cancellables)
        }
    }
}
