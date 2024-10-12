//
//  ArtistNameCollectionViewCell.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import UIKit

import Domain
import Kingfisher
import Shared

final class ArtistNameCollectionViewCell: UICollectionViewCell, Reusable {
    private let flexContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.gray02.cgColor

        return view
    }()

    private var artistIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = FeelinImages.filterAllLight.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true // 이미지가 경계를 넘지 않도록 설정

        return imageView
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray04

        return label
    }()

    private var model: Artist?

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
        flexContainer.flex.layout(mode: .adjustWidth)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.flexContainer.pin.width(size.width)
        self.flexContainer.flex.layout(mode: .adjustWidth)

        return self.flexContainer.frame.size
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        if model?.imageSource != nil {
            artistIconImageView.image = nil
        } else {
            artistIconImageView.image = FeelinImages.filterAllLight.withRenderingMode(.alwaysTemplate)
        }

        artistNameLabel.text = nil
    }

    override var isSelected: Bool {
         didSet {
             updateAppearance()
         }
     }

    private func setUpLayout() {
        self.addSubview(flexContainer)

        flexContainer.flex
            .direction(.row)
            .alignItems(.center)
            .define { flex in
                flex.addItem(artistIconImageView)
                    .marginTop(7)
                    .marginBottom(7)
                    .marginLeft(10)
                    .size(18)

                flex.addItem(artistNameLabel)
                    .marginTop(7)
                    .marginBottom(7)
                    .marginLeft(4)
                    .marginRight(10)
        }
    }

    func configure(model: Artist) {
        self.model = model

        artistNameLabel.flex.markDirty()
        artistIconImageView.flex.markDirty()
        
        artistNameLabel.text = model.name

        if let imageSource = model.imageSource, let imageUrl = URL(string: imageSource) {
            artistIconImageView.layer.cornerRadius = 9
            artistIconImageView.kf.setImage(with: imageUrl)
        } else {
            // 이미지가 없을 때는 곡률을 제거
            artistIconImageView.layer.cornerRadius = 0
        }

        flexContainer.flex.layout(mode: .adjustHeight)
    }

    private func updateAppearance() {
        flexContainer.layer.borderColor = isSelected ? Colors.primary.cgColor : Colors.gray04.cgColor
        flexContainer.backgroundColor = isSelected ? Colors.pressedBrand : Colors.background
        artistNameLabel.textColor = isSelected ? Colors.primary : Colors.gray04
        artistIconImageView.tintColor = isSelected ? Colors.primary : Colors.gray04
    }
}
