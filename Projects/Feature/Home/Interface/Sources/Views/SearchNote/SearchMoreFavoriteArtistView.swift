//
//  SearchMoreFavoriteArtistView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/5/24.
//

import UIKit

import FlexLayout
import Shared

class SearchMoreFavoriteArtistView: UIView {
    
    // MARK: - UI Components
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.x, for: .normal)
        return button
    }()
    
    let artistSearchBar = FeelinSearchBar(placeholder: "아티스트 검색")
    
    lazy var artistCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
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
        label.text = "새로운 관심 아티스트를 찾아보세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray08
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아티스트를 클릭하여 레코드에 입장할 수 있어요"
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray04
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
        
        rootFlexContainer.flex.define { flex in
            flex.addItem().direction(.row)
                .marginHorizontal(20)
                .alignItems(.start)
                .define { flex in
                    flex.addItem(closeButton)
                        .size(.init(width: 24, height: 24))
                    
                    flex.addItem().direction(.column)
                        .alignItems(.center)
                        .marginHorizontal(20)
                        .define { flex in
                            flex.addItem(titleLabel)
                                .grow(1)
                            
                            flex.addItem(subtitleLabel)
                                .marginTop(8)
                            
                        }
                }
            
            flex.addItem(artistSearchBar)
                .marginTop(16)
                .marginHorizontal(20)
            
            flex.addItem(artistCollectionView)
                .marginTop(32)
                .marginHorizontal(27)
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
