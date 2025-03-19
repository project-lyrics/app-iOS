//
//  FeelinPopUpViewController.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 2/23/25.
//

import UIKit
import SharedUtil

public final class FeelinPopUpViewController: UIViewController {
    
    private var leftTopButton: UIButton = .init()
    
    private var rightTopButton: UIButton = .init()
    
    private var topButtonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        
        return view
    }()
    
    private var totalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var popUpContentView: UIView
    
    public init(popUpContentView: UIView) {
        self.popUpContentView = popUpContentView
        self.popUpContentView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overFullScreen
        self.overrideUserInterfaceStyle = .light
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setColor()
        self.addViews()
        self.activateConstraints()
        
    }
    
    public func setLeftTopButton(
        title: String?,
        image: UIImage?,
        onTap: (() -> Void)?
    ) {
        if let title = title {
            self.leftTopButton.setAttributedTitle(
                title,
                color: .white,
                font: SharedDesignSystemFontFamily.Pretendard.semiBold.font(
                    size: 14
                ),
                for: .normal
            )
        }
        self.leftTopButton.setImage(image, for: .normal)
        self.leftTopButton.addAction(
            .init(handler: {
                [weak self] _ in
                self?.dismiss(
                    animated: false,
                    completion: onTap
                )
            }),
            for: .touchUpInside
        )
    }
    
    public func setRightTopButton(
        title: String?,
        image: UIImage?,
        onTap: (() -> Void)?
    ) {
        if let title = title {
            self.rightTopButton.setAttributedTitle(
                title,
                color: .white,
                font: SharedDesignSystemFontFamily.Pretendard.semiBold.font(
                    size: 16
                ),
                for: .normal
            )
        }
        
        self.rightTopButton.setImage(image, for: .normal)
        
        self.rightTopButton.addAction(
            .init(handler: {
                [weak self] _ in
                self?.dismiss(
                    animated: false,
                    completion: onTap
                )
            }),
            for: .touchUpInside
        )
    }
    
    private func setColor() {
        self.view.backgroundColor = Colors.dim
    }
    
    private func addViews() {
        let gapView = UIView()
        gapView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        topButtonStackView.addArrangedSubview(leftTopButton)
        topButtonStackView.addArrangedSubview(gapView)
        topButtonStackView.addArrangedSubview(rightTopButton)
        
        totalStackView.addArrangedSubview(topButtonStackView)
        totalStackView.addArrangedSubview(popUpContentView)
        
        self.view.addSubview(totalStackView)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            totalStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            totalStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
