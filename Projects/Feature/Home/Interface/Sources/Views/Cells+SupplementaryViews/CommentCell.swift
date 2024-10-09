//
//  CommentCell.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/10/24.
//

import Combine
import UIKit

import Domain
import Shared

final class CommentCell: UICollectionViewCell, Reusable {
    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - UI Components
    
    private let flexContainer = UIView()
    
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
    
    private let commentWrittenTimeLabel: UILabel = {
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
    
    private let commentContentLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray09
        label.numberOfLines = 0
        
        return label
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
    
    private func setUpLayout() {
        addSubview(flexContainer)

        flexContainer.flex
            .backgroundColor(Colors.background)
            .define { flex in
            // 작성자 정보 row
            flex.addItem().direction(.row).define { flex in
                flex.addItem(authorCharacterImageView)
                    .height(32)
                    .width(32)
                
                flex.addItem(authorNameLabel)
                    .marginLeft(8)
                    .paddingRight(8)
                
                flex.addItem(commentWrittenTimeLabel)
                    .grow(1)
                
                flex.addItem(moreAboutContentButton)
            }
            .paddingBottom(16)
            
            flex.addItem(commentContentLabel)
                .grow(1)
        }
        .paddingHorizontal(20)
        .paddingTop(20)
        .paddingBottom(24)
    }
    
    func configure(with comment: Comment) {
        self.authorCharacterImageView.image = comment.writer.profileCharacterType.image
        self.authorNameLabel.text = comment.writer.nickname
        self.commentWrittenTimeLabel.text = comment.createdAt.formattedTimeInterval()
        self.commentContentLabel.text = comment.content
        self.authorNameLabel.flex.markDirty()
        self.commentWrittenTimeLabel.flex.markDirty()
        self.commentContentLabel.flex.markDirty()
        
        self.flexContainer.flex.layout()
    }
    
    func configureBackgroundColor(_ backgroundColor: UIColor) {
        self.flexContainer.backgroundColor = backgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.authorCharacterImageView.image = nil
        self.authorNameLabel.text = nil
        self.commentContentLabel.text = nil
        self.cancellables = .init()
        self.flexContainer.flex.layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.flexContainer.pin.width(size.width)
        self.flexContainer.flex.layout(mode: .adjustHeight)
        
        return self.flexContainer.frame.size
    }
}
