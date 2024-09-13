//
//  SearchSongView.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/25/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

final class SearchSongView: UIView {

    // MARK: - UI Components

    private let flexContainer = UIView()

    private let navigationBar = NavigationBar()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let userInterfaceStyle = traitCollection.userInterfaceStyle
        let image = userInterfaceStyle == .light ? FeelinImages.backLight : FeelinImages.backDark
        button.setImage(image, for: .normal)

        return button
    }()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "곡 추가"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    let searchBarView = FeelinSearchBar(placeholder: "곡 검색")

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(cellType: SongCollectionViewCell.self)
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

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

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.bounds.width, height: 64)
        }

        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(flexContainer)

        navigationBar.addLeftBarView(backButton)
        navigationBar.addTitleView(naviTitleLabel)

        flexContainer
            .flex
            .direction(.column)
            .marginHorizontal(20)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginTop(pin.safeArea.top)

                flex.addItem(searchBarView)
                    .marginTop(16)
                
                flex.addItem(collectionView)
                    .marginTop(16)
                    .grow(1)
            }
    }
}
