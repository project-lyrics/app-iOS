//
//  SongCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/7/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

class SongCell: UICollectionViewCell, Reusable {
    private let albumImageHeight: CGFloat = 72
    
    // MARK: - UI
    
    private let flexContainer = UIView()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray08
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray04
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - init
    
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
            .direction(.row)
            .define { flex in
                flex.addItem(albumImageView)
                    .size(.init(width: albumImageHeight, height: albumImageHeight))
                
                flex.addItem().width(16)
                
                flex.addItem()
                    .direction(.column)
                    .define { flex in
                        flex.addItem(songNameLabel)
                            .maxWidth(self.frame.width - albumImageHeight - 16)
                        
                        flex.addItem().height(4)
                        
                        flex.addItem(artistNameLabel)
                            .maxWidth(self.frame.width - albumImageHeight - 16)
                    }
                
                flex.addItem().width(20)
            }
    }
    
    public func configure(
        albumImageURL: URL?,
        songName: String,
        artistName: String
    ) {
        self.albumImageView.kf.setImage(with: albumImageURL)
        self.songNameLabel.text = songName
        self.artistNameLabel.text = artistName
        
        self.songNameLabel.flex.markDirty()
        self.artistNameLabel.flex.markDirty()
        
        self.flexContainer.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        flexContainer.pin.width(size.width)
        
        flexContainer.flex.layout()
        
        return flexContainer.frame.size
    }
}
