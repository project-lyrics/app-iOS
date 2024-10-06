
//
//  SearchArtistCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 8/19/24.
//

import FlexLayout
import PinLayout
import Shared

import UIKit

final class SearchArtistCell: UICollectionViewCell, Reusable {
    private var flexContainer = UIView()
    
    private let findLabel: UILabel = {
        let label = UILabel()
        label.text = "찾아보기"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        
        return label
    }()
    
    private let artistSearchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.artistSearchIcon.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.primary
        
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
        
        flexContainer.flex
            .alignItems(.center)
            .define { flex in
                flex.addItem()
                    .height(self.frame.width)
                    .width(self.frame.width)
                    .cornerRadius(self.frame.width / 2)
                    .backgroundColor(Colors.backgroundTertiary)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .define { flex in
                        flex.addItem(artistSearchIconImageView)
                    }
                
                flex.addItem(findLabel)
                    .marginTop(8)
            }
    }
}

