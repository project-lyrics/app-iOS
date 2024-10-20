//
//  SearchNoteCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/3/24.
//

import UIKit

import FlexLayout
import Kingfisher
import PinLayout
import Shared

final class SearchNoteCell: UITableViewCell, Reusable {
    
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
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        label.textColor = Colors.gray04
        label.numberOfLines = 1
        return label
    }()
    
    private let noteCountLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 12)
        label.textColor = Colors.tertiary
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - init
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpColor()
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            self.selectedBackgroundView = UIImageView(image: Colors.gray01.image())
        }
    }
    
    private func setUpColor() {
        self.selectedBackgroundView = UIImageView(image: Colors.gray01.image())
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex
            .direction(.row)
            .justifyContent(.spaceBetween)
            .padding(12, 20)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .maxWidth(65%)
                    .define { flex in
                        flex.addItem(albumImageView)
                            .size(.init(width: 40, height: 40))
                        
                        // 노래 이름, 아티스트 이름 column
                        flex.addItem()
                            .direction(.column)
                            .justifyContent(.center)
                            .define { flex in
                                flex.addItem(songNameLabel)
                                flex.addItem(artistNameLabel)
                            }
                            .marginLeft(10)
                    }
                
                flex.addItem()
                    .alignSelf(.center)
                    .height(28)
                    .backgroundColor(Colors.secondary)
                    .cornerRadius(14)
                    .padding(6, 12)
                    .define { flex in
                        flex.addItem(noteCountLabel)
                            .grow(1)
                    }
            }
    }
    
    func configure(
        songName: String,
        artistName: String,
        noteCount: Int,
        albumImageURL: URL?
    ) {
        self.songNameLabel.text = songName
        self.artistNameLabel.text = artistName
        self.noteCountLabel.text = "노트 \(noteCount.shortenedText())"
        self.albumImageView.kf.setImage(with: albumImageURL)
        
        self.songNameLabel.flex.markDirty()
        self.artistNameLabel.flex.markDirty()
        self.noteCountLabel.flex.markDirty()
        self.albumImageView.flex.markDirty()
        self.flexContainer.flex.layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.songNameLabel.text = nil
        self.artistNameLabel.text = nil
        self.noteCountLabel.text = nil
        self.albumImageView.image = nil
        self.noteCountLabel.text = nil
        
    }
}
