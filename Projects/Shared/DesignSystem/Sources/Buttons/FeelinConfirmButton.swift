//
//  FeelinConfirmButton.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 6/9/24.
//

import UIKit

public class FeelinConfirmButton: UIButton {
    private var enabledBackgroundColor = Colors.active
    private var disabledBackgroundColor = Colors.disabled
    
    public init(
        initialEnabled: Bool = false,
        title: String,
        enabledBackgroundColor: UIColor = Colors.active,
        disabledBackgroundColor: UIColor = Colors.disabled
    ) {
        super.init(frame: .zero)
        self.isEnabled = initialEnabled
        self.enabledBackgroundColor = enabledBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        setupButton(title: title)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupButton(title: String) {
        updateAppearance()
        
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.pretendard(size: 16, type: .semiBold)
    }
    
    private func updateAppearance() {
        backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
        setTitleColor(.white, for: .normal)
    }
    
    public override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }
}
