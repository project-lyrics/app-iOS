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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
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
        self.layer.cornerRadius = 8
        self.addSubview(flexContainer)

        flexContainer.flex.addItem(bannerImageView)
    }
    
    public func configure(imageURL: URL) {
        self.bannerImageView.kf.indicatorType = .activity
        self.bannerImageView.kf.setImage(with: imageURL) { [weak self] result in
            guard case .success = result else {
                return
            }
            self?.bannerImageView.flex.markDirty()
            
            // 레이아웃 업데이트를 강제하여 최초 viewWillAppear 시점에도 이미지가 업데이트 될 수 있도록 하기 위해 호출
            self?.flexContainer.flex.layout()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        bannerImageView.kf.cancelDownloadTask()
        bannerImageView.image = nil
    }
}
