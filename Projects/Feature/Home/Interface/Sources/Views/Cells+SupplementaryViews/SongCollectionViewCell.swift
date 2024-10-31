//
//  SongCollectionViewCell.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/25/24.
//

import UIKit

import Domain
import FlexLayout
import PinLayout
import Shared
import Kingfisher

final class SongCollectionViewCell: UICollectionViewCell, Reusable {

    private let flexContainer = UIView()

    // MARK: - UI Component
    private let songIconImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4

        return imageView
    }()

    private let songNameLabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        label.textAlignment = .left
        label.numberOfLines = 1

        return label
    }()

    private let artistNameLabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        label.textColor = Colors.gray04
        label.numberOfLines = 1

        return label
    }()

    let playButton = {
        let button = UIButton()
        button.setImage(FeelinImages.play, for: .normal)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpColor()
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            self.selectedBackgroundView = UIImageView(image: Colors.gray01.image())
        }
    }

    private func setUpColor() {
        self.selectedBackgroundView = UIImageView(image: Colors.gray01.image())
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)

        flexContainer
            .flex
            .direction(.row)
            .justifyContent(.spaceBetween)
            .padding(12, 20)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .maxWidth(65%)
                    .define { flex in
                        flex.addItem(songIconImageView)
                            .size(40)
                            .cornerRadius(4)

                        flex.addItem()
                            .direction(.column)
                            .justifyContent(.center)
                            .define { flex in
                                flex.addItem(songNameLabel)
                                flex.addItem(artistNameLabel)
                            }
                            .marginLeft(10)
                    }

                flex.addItem(playButton)
                    .size(24)
            }
    }

    func configure(model: Song) {
        let imageUrl = URL(string: model.imageUrl)
        songIconImageView.kf.setImage(with: imageUrl)

        songNameLabel.text = model.name
        artistNameLabel.text = model.artist.name

        songIconImageView.flex.markDirty()
        songNameLabel.flex.markDirty()
        artistNameLabel.flex.markDirty()
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct SongCollectionViewCell_Preview: PreviewProvider {
    static var previews: some View {
        SongCollectionViewCell(
            frame: .init(
                x: 0,
                y: 0,
                width: 390,
                height: 64
            )
        ).showPreview()
    }
}

#endif
