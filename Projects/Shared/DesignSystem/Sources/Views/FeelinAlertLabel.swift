//
//  FeelinAlertLabel.swift
//  SharedDesignSystem
//
//  Created by jiyeon on 6/21/24.
//

import UIKit

public final class FeelinAlertLabel: UILabel {
    /// `isValid`가 true이면 텍스트 색상을 `Colors.alertSuccess`로 설정하고,
    /// false이면 `Colors.alertWarning`으로 설정합니다.
    public var isValid: Bool = true {
        didSet {
            textColor = isValid ? Colors.alertSuccess : Colors.alertWarning
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isValid = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
