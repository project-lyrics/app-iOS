//
//  SearchSongView.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/25/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

final class SearchSongView: UIView {

    // MARK: - UI Components

    let rootFlexContainer = UIView()

    private let navigationBar = NavigationBar()

    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "곡 추가"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    let searchBarView = FeelinSearchBar(placeholder: "곡 검색")

    private (set) var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical

        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
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

        setUpSongsCollectionViewLayout()
        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }

    private func setUpLayout() {
        self.addSubview(rootFlexContainer)

        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(naviTitleLabel)

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .marginHorizontal(20)
                    .height(44)
                    .marginTop(pin.safeArea.top)

                flex.addItem(searchBarView)
                    .marginHorizontal(20)
                    .marginTop(16)
                
                flex.addItem(collectionView)
                    .marginHorizontal(20)
                    .marginTop(16)
                    .grow(1)
            }
    }

    private func setUpSongsCollectionViewLayout() {
        flowLayout.itemSize = CGSize(width: collectionView.frame.width, height: 64)
    }
}
