//
//  FeelinConfirmButton.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 6/9/24.
//

import UIKit

public class FeelinConfirmButton: UIButton {
    public enum Setting {
        case background
        case text
    }

    private var enabledColor = Colors.active
    private var disabledColor = Colors.disabled
    private var setting: Setting = .background

    public init(
        initialEnabled: Bool = false,
        title: String,
        enabledColor: UIColor = Colors.active,
        disabledColor: UIColor = Colors.disabled,
        setting: FeelinConfirmButton.Setting = .background
    ) {
        super.init(frame: .zero)

        self.isEnabled = initialEnabled
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
        self.setting = setting

        setupButton(title: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupButton(title: String) {
        updateAppearance()

        self.setTitle(title, for: .normal)

        let font = setting == .background ? SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16) : SharedDesignSystemFontFamily.Pretendard.regular.font(size: 16)

        self.titleLabel?.font = font
    }

    private func updateAppearance() {
        switch setting {
        case .background:
            backgroundColor = isEnabled ? enabledColor : disabledColor
            setTitleColor(.white, for: .normal)
        case .text:
            backgroundColor = Colors.background

            let titleColor = isEnabled ? Colors.primary : disabledColor
            setTitleColor(titleColor, for: .normal)
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }
}
