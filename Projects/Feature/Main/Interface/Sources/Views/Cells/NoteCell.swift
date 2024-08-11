//
//  NoteCell.swift
//  FeatureMain
//
//  Created by 황인우 on 8/3/24.
//

import UIKit

import FlexLayout
import PinLayout
import Shared

final class NoteCell: UICollectionViewCell {
    
    private let flexContainer = UIView()
    
    // MARK: - UI Components
    
    private let authorCharacterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ProfileCharacterType.braidedHair.image
        
        return imageView
    }()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 14)
        label.text = "실카사랑단"
        label.textColor = Colors.gray09
        return label
    }()
    
    private let noteWrittenTimeLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 12)
        label.text = "5분 전"
        label.textColor = Colors.gray03
        return label
    }()
    
    private (set) var moreAboutContentButton: UIButton = {
        let button = UIButton()
        let buttonImage = FeelinImages.meetball.image
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
        label.text = "실리카겔 노래 중에 이 노래를 제일 좋아하는 사람 있나요?\n20대 때 처음 들었는데, 아직도 그때 그 순간을 잊지 못하겠네요.\n배경에 은은하게 깔리는 베이스가 매력적인 노래 같습니다. 저 같은 분 또 계신지 궁금하네요!"
        
        return label
    }()
    
    private let lyricsContentsView = LyricsContentsView()
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let musicTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Realize"
        label.font = SharedDesignSystemFontFamily.Pretendard.medium.font(size: 14)
        label.textColor = Colors.gray08
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "실리카겔"
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
        label.text = "0"
        
        return label
    }()
    
    private (set) var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.chatLight, for: .normal)
        
        return button
    }()
    
    private var commentAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
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
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex.define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem(authorCharacterImageView)
                    .width(32)
                flex.addItem(authorNameLabel)
                flex.addItem(noteWrittenTimeLabel)
                flex.addItem().grow(1)
                flex.addItem(moreAboutContentButton)
            }
            .height(32)
            
            flex.addItem(noteContentLabel)
            
            flex.addItem(lyricsContentsView)
            
            flex.addItem()
                .backgroundColor(Colors.gray03)
                .height(1)
            
            flex.addItem().direction(.row).define { flex in
                flex.addItem(albumImageView)
                
                flex.addItem().direction(.column).define { flex in
                    flex.addItem(musicTitleLabel)
                    
                    flex.addItem(artistNameLabel)
                }
                flex.addItem().grow(1)
                flex.addItem(playMusicButton)
            }
            flex.addItem().direction(.row).define { flex in
                flex.addItem(likeNoteButton)
                flex.addItem(likeAmountLabel)
                flex.addItem(commentButton)
                flex.addItem(commentAmountLabel)
                flex.addItem().grow(1)
                flex.addItem(bookmarkButton)
            }
        }
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
