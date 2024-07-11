//
//  WelcomeView.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick Kim on 7/10/24.
//

import UIKit
import Shared

final class WelcomeView: UIView {
    private let flexContainer = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.extraBold.font(size: 28)
        label.text = "Feelin에 오신걸 환영해요!"
        label.textAlignment = .center
        return label
    }()

    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = FeelinImages.welcomeBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Colors.background
        setUpLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all(pin.safeArea)
        flexContainer.flex.layout()
    }

    private func setUpLayout() {
        addSubview(flexContainer)

        flexContainer.flex.define { flex in
            flex.addItem(titleLabel)
                .alignSelf(.center)
                .marginTop(pin.safeArea.top + 120)
                .marginBottom(20)
            
            flex.addItem(welcomeImageView)
                .grow(1)
                .alignSelf(.center)
                .marginBottom(10)
        }
    }
}
