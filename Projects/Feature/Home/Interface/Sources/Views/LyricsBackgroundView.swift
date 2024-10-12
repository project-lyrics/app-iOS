//
//  LyricsBackgroundView.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/24/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared
import Domain

public final class LyricsBackgroundView: UIView {

    // MARK: - UI Components

    private let flexContainer = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray09
        label.textAlignment = .left

        label.text = "가사 배경"
        return label
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.x, for: .normal)
        return button
    }()

    private let flowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 350, height: 132)
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        return layout
    }()

    lazy var backgroundCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(cellType: LyricsBackgroundCollectionViewCell.self)
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self

        return collectionView
    }()

    let confirmButton = FeelinConfirmButton(title: "완료")

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Colors.background
        self.setUpLayout()

        self.backgroundCollectionView.selectItem(
            at: IndexPath(item: 0, section: 0),
            animated: false,
            scrollPosition: .top
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)
        backgroundColor = Colors.background

        flexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .marginHorizontal(20)
                    .marginTop(24)
                    .marginBottom(20)
                    .define { flex in
                        flex.addItem(titleLabel)
                            .grow(1)

                        flex.addItem(cancelButton)
                            .size(24)
                    }

                flex.addItem(backgroundCollectionView)
                    .height(514)

                flex.addItem(confirmButton)
                    .height(56)
                    .cornerRadius(8)
                    .marginHorizontal(20)
                    .marginBottom(23)
            }
    }
}

// MARK: - UICollectionViewDataSource

extension LyricsBackgroundView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LyricsBackground.allCases.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LyricsBackgroundCollectionViewCell.self)
        let image = LyricsBackground.allCases[indexPath.row].image
        cell.configure(image: image)

        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        cell.setSelected(isSelected)

        return cell
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct LyricsBackgroundView_Preview: PreviewProvider {
    static var previews: some View {
        LyricsBackgroundView(
            frame: .init(x: 0, y: 0, width: 350, height: 514)
        ).showPreview()
    }
}
#endif

