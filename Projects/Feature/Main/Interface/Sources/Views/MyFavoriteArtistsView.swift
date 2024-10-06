//
//  MyFavoriteArtistsView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 10/6/24.
//

import UIKit

import FlexLayout
import Shared

class MyFavoriteArtistsView: UIView {

    // MARK: - UI Components
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.xLight, for: .normal)
        return button
    }()
    
    lazy var artistCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.register(cellType: FeelinArtistCell.self)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private (set) var flowLayout: UICollectionViewFlowLayout = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 12
        flowlayout.minimumLineSpacing = 12
        return flowlayout
    }()
    
    private (set) var rootFlexContainer: UIView = .init()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 관심 아티스트"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray08
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Colors.background
        
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setUpArtistCollectionViewLayout()
        
        rootFlexContainer.pin
            .top(self.pin.safeArea)
            .horizontally()
            .bottom()
        rootFlexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .marginHorizontal(21)
            .define { flex in
                flex.addItem().direction(.row)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .define { flex in
                        flex.addItem(closeButton)
                            .size(.init(width: 24, height: 24))
                            .position(.absolute)
                            .left(20)
                        
                        flex.addItem(titleLabel)
                    }
                
                flex.addItem(artistCollectionView)
                    .marginTop(28)
                    .grow(1)
            }
    }
    
    private func setUpArtistCollectionViewLayout() {
        let totalHorizontalSpacing = flowLayout.minimumInteritemSpacing * 2 + 27 * 2
        let cellWidth: CGFloat = (self.frame.width - totalHorizontalSpacing) / 3
        let cellHeight: CGFloat = 146
        
        flowLayout.itemSize = CGSize(
            width: cellWidth,
            height: cellHeight
        )
        
        artistCollectionView.contentInset = .init(
            top: 0,
            left: 0,
            bottom: self.safeAreaInsets.bottom,
            right: 0
        )
    }
}
