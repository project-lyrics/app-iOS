//
//  FavoriteArtistSelectButton.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/1/24.
//

import Shared

import UIKit

class FavoriteArtistSelectButton: UIButton {
    
    // MARK: - UI Components
    
    private let flexContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    private let titleLabelView: UILabel = {
        let label = UILabel()
        label.text = "관심 아티스트"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        label.textColor = .white
        
        return label
    }()
    
    private let heartImageView = UIImageView()
    private let heartRateImageWidth: CGFloat = 24

    private var selectedImage: UIImage = FeelinImages.heartActive
    private var unSelectedImage: UIImage = FeelinImages.heartInactive
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override var isSelected: Bool {
        didSet {
            updateButtonImage()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let contentWidth = heartRateImageWidth + titleLabelView.intrinsicContentSize.width + 28
        let contentHeight = max(
            heartRateImageWidth,
            titleLabelView.intrinsicContentSize.height
        ) + 16
        return CGSize(width: contentWidth, height: contentHeight)
    }

    private func setUpButton() {
        updateButtonImage()
        setupLayout()
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        addSubview(flexContainer)
        
        flexContainer.flex
            .backgroundColor(.init(white: 0.9, alpha: 0.3))
            .cornerRadius(8)
            .paddingHorizontal(10)
            .paddingVertical(8)
            .direction(.row)
            .alignItems(.center)
            .define { flex in
                flex.addItem(heartImageView)
                    .size(heartRateImageWidth)
                flex.addItem(titleLabelView)
                    .marginLeft(8)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    @objc private func buttonTapped() {
        isSelected.toggle()
        updateButtonImage()
    }
    
    private func updateButtonImage() {
        let image = isSelected ? selectedImage : unSelectedImage
        heartImageView.image = image
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct FavoriteArtistButton_Preview: PreviewProvider {
    static var previews: some View {
        FavoriteArtistSelectButton(
            frame: .init(
                x: 0,
                y: 0,
                width: 117,
                height: 36
            )
        ).showPreview()
    }
}

#endif
