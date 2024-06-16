//
//  GenderCollectionView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

import Shared

final class GenderCollectionView: UICollectionView {
    private let flowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 14
        return layout
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        register(cellType: GenderCell.self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let genderCellWidth = (frame.width - flowLayout.minimumInteritemSpacing) / 2
        let genderCellHeight = frame.height
        flowLayout.itemSize = CGSize(width: genderCellWidth, height: genderCellHeight)
    }
}
