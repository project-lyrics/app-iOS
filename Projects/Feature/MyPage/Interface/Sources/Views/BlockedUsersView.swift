//
//  BlockedUsersView.swift
//  FeatureMyPageInterface
//
//  Created by 황인우 on 11/23/24.
//

import UIKit

import Shared

class BlockedUsersView: UIView {

    // MARK: - UIComponents
    
    private let flexContainer = UIView()
    
    private let navigationBar = NavigationBar()

    private (set) var backButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        label.text = "차단된 유저 관리"

        return label
    }()
    
    private (set) lazy var blockedUsersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = Colors.background
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private (set) var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        return layout
    }()
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpDefault()
        self.setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }
    
    private func setUpDefault() {
        self.backgroundColor = Colors.background
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(navigationTitleLabel)
        
        flexContainer.flex
            .define { flex in
                flex.addItem(navigationBar)
                    .marginHorizontal(10)
                    .height(44)
                
                flex.addItem(blockedUsersCollectionView)
                    .marginTop(24)
                    .grow(1)
            }
    }
}
