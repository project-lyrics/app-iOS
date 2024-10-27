//
//  CommunityEmptyArtistCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/27/24.
//

import Shared

import UIKit

class CommunityEmptyArtistCell: UICollectionViewCell {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpDefaults()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpDefaults() {
        self.backgroundColor = Colors.background
    }
}
