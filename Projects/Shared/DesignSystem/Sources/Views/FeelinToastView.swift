//
//  FeelinToastView.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 10/13/24.
//

import UIKit

public final class FeelinToastView: UIView {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    public init(
        iconImage: UIImage,
        message: String,
        frame: CGRect
    ) {
        super.init(frame: frame)
        
        self.iconImageView.image = iconImage
        self.messageLabel.text = message
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        backgroundColor = Colors.gray07
        layer.cornerRadius = 8
        clipsToBounds = true
        
        // 뷰 계층 설정
        addSubview(iconImageView)
        addSubview(messageLabel)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            // iconImageView constraints
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // messageLabel constraints
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
