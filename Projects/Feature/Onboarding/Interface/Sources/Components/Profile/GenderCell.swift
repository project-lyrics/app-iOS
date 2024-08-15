//
//  GenderCell.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit
import Domain
import Shared

import FlexLayout
import PinLayout

final class GenderCell: UICollectionViewCell, Reusable {
    private var gender: GenderEntity?

    // MARK: - components
    
    private let imageView = UIImageView()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
        label.textAlignment = .center
        return label
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
        layer.cornerRadius = 8
        layer.borderColor = Colors.gray01.cgColor
    }
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
    }
    
    private func setUpLayout() {
        contentView.flex.alignItems(.center).define { flex in
            flex.addItem(imageView)
                .width(120)
                .height(120)
                .marginTop(28)
            
            flex.addItem(descriptionLabel)
                .marginTop(8)
        }
    }
    
    // MARK: - configure
    
    func configure(with gender: GenderEntity) {
        self.gender = gender
        descriptionLabel.text = gender.description
        setSelected(false)
    }
    
    func setSelected(_ isSelected: Bool) {
        imageView.image = isSelected ? gender?.activeImage : gender?.inactiveImage
        descriptionLabel.textColor = isSelected ? Colors.alertSuccess : Colors.gray03
        layer.borderWidth = isSelected ? 0 : 1
        backgroundColor = isSelected ? Colors.secondary : Colors.background
    }
}
