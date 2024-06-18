//
//  ArtistSelectView.swift
//  FeatureMain
//
//  Created by 황인우 on 6/19/24.
//

import UIKit

import Shared

class ArtistSelectView: UIView {
    
    // MARK: - UI Components
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.xLight, for: .normal)
        return button
    }()
    
    let artistSearchBar = FeelinSearchBar(placeholder: "아티스트 검색")
    
    lazy var artistCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    let finishSelectButton = FeelinConfirmButton(
        initialEnabled: true,
        title: "완료"
    )
    
    private var flowLayout: UICollectionViewFlowLayout = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 12
        flowlayout.minimumLineSpacing = 12
        return flowlayout
    }()
    
    private let rootFlexContainer: UIView = .init()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "좋아하는 아티스트를\n모두 선택해주세요"
        label.numberOfLines = 2
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 24)
        label.textColor = Colors.gray08
        return label
    }()
    
    private let subtitlelabel: UILabel = {
        let label = UILabel()
        label.text = "노래와 가사를 공유할 수 있는 공간이 생성돼요"
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
            flex.addItem(closeButton)
                .size(.init(width: 24, height: 24))
                .marginTop(10)
                .marginLeft(20)
            
            flex.addItem(titleLabel)
                .marginTop(38)
                .marginHorizontal(20)
            
            flex.addItem(subtitlelabel)
                .marginTop(8)
                .marginHorizontal(20)
            
            flex.addItem(artistSearchBar)
                .marginTop(16)
                .marginHorizontal(20)
            
            flex.addItem(artistCollectionView)
                .marginTop(28)
                .marginHorizontal(27)
                .grow(1)
            
            flex.addItem(finishSelectButton)
                .position(.absolute)
                .left(20)
                .right(20)
                .bottom(44)
                .height(56)
                .cornerRadius(8)
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
    }
}
