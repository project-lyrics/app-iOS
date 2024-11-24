//
//  BlockedUserCell.swift
//  FeatureMyPageInterface
//
//  Created by 황인우 on 11/23/24.
//

import Combine
import UIKit

import Domain
import Shared

class BlockedUserCell: UICollectionViewCell, Reusable {
    var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - UI
    
    private let flexContainer = UIView()
    
    private let userCharacterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textColor = Colors.gray09

        return label
    }()
    
    private (set) var unblockUserButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("차단 해제", for: .normal)
        button.setTitleColor(Colors.primary, for: .normal)
        button.backgroundColor = Colors.secondary
        
        return button
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpColor()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.userCharacterImageView.image = nil
        self.userNameLabel.text = nil
        self.cancellables = .init()
    }
    
    private func setUpColor() {
        self.backgroundColor = Colors.background
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex
            .direction(.row)
            .justifyContent(.spaceBetween)
            .paddingHorizontal(20)
            .paddingVertical(16)
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .define { flex in
                        flex.addItem(userCharacterImageView)
                            .size(.init(width: 40, height: 40))
                            .marginRight(8)
                        
                        flex.addItem(userNameLabel)
                    }
                flex.addItem(unblockUserButton)
                    .size(.init(width: 68, height: 28))
            }
    }
    
    func configure(
        userName: String,
        characterImage: UIImage
    ) {
        self.userNameLabel.text = userName
        self.userCharacterImageView.image = characterImage
        self.userNameLabel.flex.markDirty()
        self.flexContainer.flex.layout()
    }
    
}
