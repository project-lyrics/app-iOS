//
//  ProfileCharacterCell.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout

final class ProfileCharacterCell: UICollectionViewCell, Reusable {
    private var profileType: ProfileCharacterType?
    
    // MARK: - components
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpCell()
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCell() {
        clipsToBounds = true
        layer.borderColor = Colors.disabled.cgColor
        layer.borderWidth = 2
    }
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    private func setUpLayout() {
        contentView.flex
            .alignItems(.center)
            .justifyContent(.center)
            .define { flex in
            flex.addItem(imageView)
                .width(90%)
                .height(90%)
        }
    }
    
    // MARK: - configure
    
    func configure(with profileType: ProfileCharacterType) {
        self.profileType = profileType
        imageView.image = profileType.image
        setSelected(false)
    }
    
    func setSelected(_ isSelected: Bool) {
        layer.borderColor = isSelected ? Colors.active.cgColor : Colors.disabled.cgColor
    }
}
