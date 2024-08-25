//
//  SongCollectionViewCell.swift
//  FeatureMainInterface
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
        imageView.kf.setImage(
            with: URL(
                string: "https://flexible.img.hani.co.kr/flexible/normal/970/760/imgdb/original/2024/0124/20240124502847.jpg"
            )
        )

        return imageView
    }()

    private let songLabel = {
        let label = UILabel()
        label.text = "APEX"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        label.textAlignment = .left

        return label
    }()

    private let artistNameLabel = {
        let label = UILabel()
        label.text = "실리카겔"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        label.textColor = Colors.gray04
        label.textAlignment = .left

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

        flexContainer
            .flex
            .direction(.row)
            .justifyContent(.center)
            .marginHorizontal(20)
            .marginVertical(12)
            .define { flex in
                flex.addItem(songIconImageView)
                    .size(40)
                    .cornerRadius(4)

                flex.addItem()
                    .direction(.column)
                    .marginVertical(2)
                    .marginLeft(10)
                    .grow(1)
                    .define { flexLabel in
                        flexLabel.addItem(songLabel)

                        flexLabel.addItem(artistNameLabel)
                    }

                flex.addItem(playButton)
                    .size(24)
            }
    }

    func configure(model: Song) {
        let imageUrl = URL(string: model.imageUrl)
        songIconImageView.kf.setImage(with: imageUrl)

        songLabel.text = model.name
        artistNameLabel.text = model.artist.name
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
