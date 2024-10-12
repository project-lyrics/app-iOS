//
//  LyricsBackgroundCollectionViewCell.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/24/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared
import Domain

public final class LyricsBackgroundCollectionViewCell: UICollectionViewCell, Reusable {

    private let flexContainer = UIView()

    // MARK: - UI Components

    private let lyricsBackgroundImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = LyricsBackground.default.image
        return imageView
    }()

    private let lyricsDefaultTextLabel = {
        let label = UILabel()
        label.text = "이야기로 음악을 느끼다\n이야기로 음악을 채우다"
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = Colors.gray08
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private (set) var checkButton = FeelinSelectableImageButton(
        selectedImage: FeelinImages.checkBoxActive,
        unSelectedImage: FeelinImages.checkBoxInactive
    )

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()
        flexContainer.flex.layout()

        checkButton.pin
            .top(16)
            .right(16)
            .size(24)
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)
        backgroundColor = Colors.background
        
        flexContainer.flex.define { flex in
            flex.addItem(lyricsBackgroundImageView)
                .alignItems(.center)
                .justifyContent(.center)
                .position(.relative)
                .define { flexBackground in
                    flexBackground.addItem(lyricsDefaultTextLabel)
                        .alignSelf(.center)
                }
                .height(132)
        }

        flexContainer.addSubview(checkButton)
    }

    public func configure(image: UIImage) {
        lyricsBackgroundImageView.image = image
    }

    public func setSelected(_ selected: Bool) {
        checkButton.isSelected = selected
    }
}


#if canImport(SwiftUI)

import SwiftUI

struct LyricsBackgroundCollectionViewCell_Preview: PreviewProvider {
    static var previews: some View {
        LyricsBackgroundCollectionViewCell(
            frame: .init(x: 0,
            y: 0,
            width: 350,
            height: 132)
        ).showPreview()
    }
}

#endif
