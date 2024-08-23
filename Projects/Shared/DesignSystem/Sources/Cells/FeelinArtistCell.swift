//
//  FeelinArtistCell.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 6/16/24.
//

import UIKit

import FlexLayout
import Kingfisher
import PinLayout
import SharedUtil

public final class FeelinArtistCell: UICollectionViewCell, Reusable {
    
    // MARK: - Property
    
    private var inset: CGFloat = 0
    private var borderWidth: CGFloat = 0
    
    // MARK: - Components
    
    private let flexContainer = UIView()
    
    private var imageContainerView: UIView = .init()
    
    private var artistImageBorderView = UIView()
    
    private var artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpLayout()
    }
    
    @available(*, unavailable)
    required  init?(coder: NSCoder) {
        fatalError()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex.alignItems(.center).define { flex in
            flex.addItem(artistImageBorderView)
                .border(self.borderWidth, Colors.background)
                .height(self.frame.width)
                .width(self.frame.width)
                .cornerRadius(self.frame.width / 2)
                .define { flex in
                    flex.addItem(artistImageView)
                        .height(self.frame.width)
                        .width(self.frame.width)
                        .margin(inset, inset)
                        .cornerRadius((self.frame.width - (inset + inset)) / 2)
                }
            
            flex.addItem(artistNameLabel)
                .width(100%)
                .marginTop(8)
        }
    }
    
    public func configure(
        artistName: String,
        artistImageURL: URL?,
        imageBorderWidth: CGFloat = 0,
        imageBorderInset: CGFloat = 0
    ) {
        self.artistNameLabel.text = artistName
        self.artistImageView.kf.indicatorType = .activity
        self.artistImageView.kf.setImage(with: artistImageURL)
        self.borderWidth = imageBorderWidth
        self.inset = imageBorderInset
        self.setUpLayout()
    }
    
    /// configure메서드를 활용하여 imageBorderWidth & imageBorderInset 설정이 되어있지 않으면 아래 메서드는 적용이 되지 않습니다.
    public func setArtistBorder(color: UIColor) {
        self.artistImageBorderView.layer.borderColor = color.cgColor
    }
}
