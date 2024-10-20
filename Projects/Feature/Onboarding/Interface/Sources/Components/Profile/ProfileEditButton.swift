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

public final class ProfileEditButton: UIButton {
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
        view.layer.borderWidth = 5
        return view
    }()
    
    private let editImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.pencil
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBorderColor(for: traitCollection.userInterfaceStyle)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin.all()
        flexContainer.flex.layout()
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
    
    private func setUpLayout() {
        addSubview(flexContainer)
        flexContainer.flex
            .direction(.row)
            .justifyContent(.center)
            .alignItems(.end)
            .define { flex in
            flex.addItem(profileImageView)
                .width(45%)
                .aspectRatio(1.0)
                .marginLeft(5%)
            
            flex.addItem(circleView)
                .width(14%)
                .aspectRatio(1.0)
                .marginLeft(-9%)
                .justifyContent(.center)
                .define { flex in
                    flex.addItem(editImageView)
                        .width(42%)
                        .aspectRatio(1.0)
                        .alignSelf(.center)
                }
        }
    }

    private func updateBorderColor(for userInterfaceStyle: UIUserInterfaceStyle) {
        if userInterfaceStyle == .dark {
            circleView.layer.borderColor = Colors.gray09.cgColor
           } else {
               circleView.layer.borderColor = Colors.fixedBackground.cgColor
           }
    }

    public func setProfileImage(with image: UIImage?) {
        profileImageView.image = image
    }
}
