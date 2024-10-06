//
//  BannerCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/19/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

final class BannerCell: UICollectionViewCell, Reusable {
    private let flexContainer = UIView()
    
    private var bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.feedbackBanner
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    // MARK: - Init
    
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
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex.addItem(bannerImageView)
    }
}
