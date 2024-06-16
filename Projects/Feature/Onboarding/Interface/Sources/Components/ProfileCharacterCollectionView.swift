//
//  ProfileCharacterCollectionView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Shared

final class ProfileCharacterCollectionView: UICollectionView {
    private let flowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        register(cellType: ProfileCharacterCell.self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let numOfItems = ProfileCharacterType.allCases.count
        let cellWidth = (frame.width - flowLayout.minimumInteritemSpacing * (numOfItems - 1) / numOfItems
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: frame.height - cellWidth,
            right: 0
        )
    }
}
