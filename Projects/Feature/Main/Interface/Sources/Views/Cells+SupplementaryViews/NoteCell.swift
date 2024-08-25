//
//  NoteCell.swift
//  FeatureMain
//
//  Created by 황인우 on 8/3/24.
//

import UIKit

import Domain
import FlexLayout
import PinLayout
import Shared

final class NoteCell: UICollectionViewCell, Reusable {
    
    private let flexContainer = UIView()
    
    // MARK: - UI Components
    
    private let authorCharacterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 14)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    private let noteWrittenTimeLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 12)
        label.textColor = Colors.gray03
        
        return label
    }()
    
    private (set) var moreAboutContentButton: UIButton = {
        let button = UIButton()
        let buttonImage = FeelinImages.meetball
            .withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = Colors.gray03
        
        return button
    }()
    
    private let noteContentLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray09
        label.numberOfLines = 3
        
        return label
    }()
    
    private var lyricsContentsView: LyricsContentsView = .init()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let musicTitleLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 12)
        label.textColor = Colors.gray04
        
        return label
    }()
    
    private (set) var playMusicButton: UIButton = {
        let button = UIButton()
        let buttonImage = FeelinImages.playIcon
            .withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.tintColor = Colors.gray03
        
        return button
    }()
    
    private (set) var likeNoteButton: FeelinSelectableImageButton = {
        let button = FeelinSelectableImageButton(
            selectedImage: FeelinImages.heartActiveLight,
            unSelectedImage: FeelinImages.heartInactiveLight
        )
        
        return button
    }()
    
    private var likeAmountLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray03
        
        return label
    }()
    
    private (set) var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.chatLight, for: .normal)
        
        return button
    }()
    
    private var commentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray03
        
        return label
    }()
    
    private (set) var bookmarkButton: FeelinSelectableImageButton = {
        let button = FeelinSelectableImageButton(
            selectedImage: FeelinImages.bookmarkActiveLight,
            unSelectedImage: FeelinImages.bookmarkInactiveLight
        )
        
        return button
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
        flexContainer.flex.layout(mode: .adjustHeight)
    }
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex.define { flex in
            // 작성자 정보 row
            flex.addItem().direction(.row).define { flex in
                flex.addItem(authorCharacterImageView)
                    .height(32)
                    .width(32)
                
                flex.addItem(authorNameLabel)
                    .marginLeft(8)
                    .paddingRight(8)
                
                flex.addItem(noteWrittenTimeLabel)
                    .grow(1)
                
                flex.addItem(moreAboutContentButton)
            }
            .paddingTop(24)
            
            
            flex.addItem().define { flex in
                flex.addItem(noteContentLabel)
                
                flex.addItem(lyricsContentsView)
                    .marginTop(16)
                
            }
            .paddingVertical(16)
            
            
            flex.addItem()
                .backgroundColor(Colors.gray03)
            
            flex.addItem().backgroundColor(Colors.gray01).height(1)
            
            // 아티스트 앨범 row
            flex.addItem().direction(.row).alignItems(.center).define { flex in
                flex.addItem(albumImageView)
                    .width(40)
                    .height(40)
                
                flex.addItem().direction(.column).define { flex in
                    flex.addItem(musicTitleLabel)
                    
                    flex.addItem(artistNameLabel)
                }
                .paddingLeft(10)
                .grow(1)
                .paddingVertical(12)
                
                flex.addItem(playMusicButton)
                    .paddingBottom(24)
            }
            
            flex.addItem().backgroundColor(Colors.gray01).height(1)

            
            // 좋아요 & 댓글 row
            flex.addItem().direction(.row).define { flex in
                flex.addItem(likeNoteButton)
                    .paddingRight(4)
                
                flex.addItem(likeAmountLabel)
                
                flex.addItem().width(16)
                
                flex.addItem(commentButton)
                    .paddingRight(4)
                
                flex.addItem(commentAmountLabel)
                
                flex.addItem().grow(1)
                
                flex.addItem(bookmarkButton)
            }
            .paddingTop(24)
            .paddingBottom(28)
        }
    }
    
    // MARK: - Configure UI
    func configure(with note: Note) {
        self.authorCharacterImageView.image = note.publisher.profileCharacterType.image
        self.authorNameLabel.text = note.publisher.nickname
        self.noteWrittenTimeLabel.text = note.createdAt.formattedTimeInterval()
        self.noteContentLabel.text = note.content
        self.albumImageView.kf.setImage(
            with: try?note.song.imageUrl.asURL()
        )
        self.musicTitleLabel.text = note.song.name
        self.artistNameLabel.text = note.song.artist.name
        self.likeAmountLabel.text = note.likesCount.shortenedText()
        self.commentAmountLabel.text = note.commentsCount.shortenedText()
        self.likeNoteButton.isSelected = note.isLiked
        
        self.likeAmountLabel.flex.markDirty()
        self.commentAmountLabel.flex.markDirty()
        
        if let lyrics = note.lyrics {
            self.lyricsContentsView.configureView(with: lyrics)
            self.lyricsContentsView.flex.isIncludedInLayout(true).markDirty()
        } else {
            self.lyricsContentsView.flex.isIncludedInLayout(false).markDirty()
        }
        
        self.flexContainer.flex.layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.authorCharacterImageView.image = nil
        self.authorNameLabel.text = nil
        self.noteWrittenTimeLabel.text = nil
        self.noteContentLabel.text = nil
        self.albumImageView.image = nil
        self.musicTitleLabel.text = nil
        self.artistNameLabel.text = nil
        self.likeAmountLabel.text = nil
        self.commentAmountLabel.text = nil
        self.likeNoteButton.isSelected = false
        self.lyricsContentsView.configureView(with: nil)
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.flexContainer.pin.width(size.width)
        self.flexContainer.flex.layout(mode: .adjustHeight)
        
        return self.flexContainer.frame.size
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct NoteCell_Preview: PreviewProvider {
    static var previews: some View {
        NoteCell(
            frame: .init(x: 0,
            y: 0,
            width: 390,
            height: 484)
        ).showPreview()
    }
}

#endif
