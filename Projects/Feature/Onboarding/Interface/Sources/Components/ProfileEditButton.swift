//
//  ProfileEditButton.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Shared

import FlexLayout
import PinLayout

final class ProfileEditButton: UIButton {
    // MARK: - components
    
    private let flexContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let profileImageView = {
        let imageView = UIImageView()
        imageView.image = ProfileCharacterType.defaultImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let circleView = {
        let view = UIView()
        view.backgroundColor = Colors.primary
        view.clipsToBounds = true
        view.layer.borderColor = Colors.background.cgColor
        view.layer.borderWidth = 5
        return view
    }()
    
    private let editImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.pencil
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        flexContainer.flex
            .direction(.row)
            .justifyContent(.center)
            .alignItems(.end)
            .define { flex in
            flex.addItem(profileImageView)
                .width(176)
                .height(176)
                .marginLeft(20)
            
            flex.addItem(circleView)
                .width(56)
                .height(56)
                .marginLeft(-36)
                .cornerRadius(28)
                .justifyContent(.center)
                .define { flex in
                    flex.addItem(editImageView)
                        .width(24)
                        .height(24)
                        .alignSelf(.center)
                }
        }
    }
    
    func setProfileImage(with image: UIImage) {
        profileImageView.image = image
    }
}
