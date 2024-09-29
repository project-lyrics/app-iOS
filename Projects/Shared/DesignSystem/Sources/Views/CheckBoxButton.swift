//
//  CheckBoxButton.swift
//  FeatureOnboardingInterface
//
//  Created by 황인우 on 6/9/24.
//

import FlexLayout
import UIKit

public final class CheckBoxButton: UIButton {
    let flexContainer = UIView()

    private var uncheckedImage: UIImage = SharedDesignSystem.FeelinImages.checkBoxInactive
    private var checkedImage = SharedDesignSystem.FeelinImages.checkBoxActive

    public override var isSelected: Bool {
        didSet {
            updateImage()
        }
    }

    // MARK: - View
    private var checkBoxImageView: UIImageView = {
        let imageView = UIImageView(image: SharedDesignSystem.FeelinImages.checkBoxInactive)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private var additionalView: UIView?

    public init(
        additionalView: UIView? = nil,
        action: UIAction? = nil
    ) {
        super.init(frame: .zero)
        if let action = action {
            self.addAction(action, for: .touchUpInside)
        }
        addSubview(flexContainer)
        self.additionalView = additionalView

        if let additionalView = additionalView {
            addSubview(additionalView)
        }

        setupButton()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin.all()
        flexContainer.flex.layout()
    }

    private func setupButton() {
        addTarget(
            self,
            action: #selector(buttonTapped),
            for: .touchUpInside
        )
        updateImage()
        setUpView()
    }

    @objc private func buttonTapped() {
        isSelected.toggle()
    }

    private func updateImage() {
        let image = isSelected ? checkedImage : uncheckedImage
        self.checkBoxImageView.image = image
    }

    private func setUpView() {
        flexContainer.isUserInteractionEnabled = false

        flexContainer.flex
            .direction(.row)
            .alignItems(.center)
            .define { flex in
                flex.addItem(checkBoxImageView)

                if let additionalView = additionalView {
                    flex.addItem(additionalView)
                }
            }
    }
}
