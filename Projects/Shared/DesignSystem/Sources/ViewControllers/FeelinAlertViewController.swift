//
//  FeelinAlertViewController.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 7/9/24.
//

import UIKit

public final class FeelinAlertViewController: UIViewController {
    private var titleText: String?
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.modal
        view.layer.cornerRadius = 12
        view.transform = CGAffineTransform(
            scaleX: 1.1,
            y: 1.1
        )
        
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12.0
        view.alignment = .center
        
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 18)
        label.numberOfLines = 0
        label.textColor = Colors.gray09
        
        return label
    }()
    
    private lazy var messageLabel: UILabel? = {
        guard messageText != nil || attributedMessageText != nil else { return nil }
        
        let label = UILabel()
        label.text = messageText
        label.textAlignment = .center
        label.font = SharedDesignSystemFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = Colors.gray05
        label.numberOfLines = 0
        
        if let attributedMessageText = attributedMessageText {
            label.attributedText = attributedMessageText
        }
        
        return label
    }()
    
    private var leftButton: UIButton = {
        let leftButton = UIButton(type: .custom)
        leftButton.setTitleColor(Colors.gray02, for: .normal)
        leftButton.setBackgroundImage(Colors.modal.image(), for: .normal)
        leftButton.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        leftButton.layer.cornerRadius = 12
        leftButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        leftButton.layer.masksToBounds = true
        
        return leftButton
    }()
    
    private var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setTitleColor(Colors.primary, for: .normal)
        rightButton.setBackgroundImage(Colors.modal.image(), for: .normal)
        rightButton.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        rightButton.layer.cornerRadius = 12
        rightButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
        rightButton.layer.masksToBounds = true
        
        return rightButton
    }()
    
    private var singleButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setTitleColor(Colors.primary, for: .normal)
        rightButton.setBackgroundImage(Colors.modal.image(), for: .normal)
        rightButton.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        rightButton.layer.cornerRadius = 12
        rightButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        rightButton.layer.masksToBounds = true
        
        return rightButton
    }()
    
    public convenience init(
        titleText: String? = nil,
        messageText: String? = nil,
        attributedMessageText: NSAttributedString? = nil) {
            self.init()
            
            self.titleText = titleText
            self.messageText = messageText
            self.attributedMessageText = attributedMessageText
            modalPresentationStyle = .overFullScreen
        }
    
    public convenience init(contentView: UIView) {
        self.init()
        
        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseOut
        ) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseIn
        ) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.addSubviews()
        self.makeConstraints()
        self.setInitialColor()
    }
    
    private func setInitialColor() {
        switch self.traitCollection.userInterfaceStyle {
        case .light:
            self.leftButton.setTitleColor(Colors.gray02, for: .normal)
            
        case .dark:
            self.leftButton.setTitleColor(Colors.gray06, for: .normal)
            
        default:
            return
        }
    }
    
    public override func willTransition(to newCollection: UITraitCollection, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        // MARK: - 버튼에 배경색에 다크모드를 실시간 적용하기 위해 setBackgroundImage를 해당 메서드에서 호출
        
        self.leftButton.setBackgroundImage(Colors.modal.image(), for: .normal)
        self.rightButton.setBackgroundImage(Colors.modal.image(), for: .normal)
        self.singleButton.setBackgroundImage(Colors.modal.image(), for: .normal)
        self.singleButton.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        self.leftButton.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        self.rightButton.setBackgroundImage(Colors.gray01.image(), for: .highlighted)
        
        
        // MARK: - 디자이너 요청에 따라 cancelButton만 다크모드시 gray06색상 적용
        
        switch newCollection.userInterfaceStyle {
        case .light:
            self.leftButton.setTitleColor(Colors.gray02, for: .normal)
            
        case .dark:
            self.leftButton.setTitleColor(Colors.gray06, for: .normal)
        default:
            return
        }
    }
    
    public func setLeftButton(title: String, onTapCompletion: (() -> Void)?) {
        self.singleButton.isHidden = true
        
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
            ]
        )
        
        leftButton.setAttributedTitle(attributedString, for: .normal)
        leftButton.addAction(UIAction(handler: { _ in
            self.dismiss(
                animated: false,
                completion: onTapCompletion
            )
        }), for: .touchUpInside)
    }
    
    public func setRightButton(title: String, onTapCompletion: (() -> Void)?) {
        self.singleButton.isHidden = true
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
            ]
        )
        
        rightButton.setAttributedTitle(attributedString, for: .normal)
        rightButton.addAction(UIAction(handler: { _ in
            self.dismiss(
                animated: false,
                completion: onTapCompletion
            )
        }), for: .touchUpInside)
    }
    
    public func setSingleButton(title: String, onTapCompletion: (() -> Void)?) {
        self.leftButton.isHidden = true
        self.rightButton.isHidden = true
        
        let attributedString = NSAttributedString(
            string: title,
            attributes: [
                .font: SharedDesignSystemFontFamily.Pretendard.semiBold.font(size: 16)
            ]
        )
        
        singleButton.setAttributedTitle(attributedString, for: .normal)
        singleButton.addAction(UIAction(handler: { _ in
            self.dismiss(
                animated: false,
                completion: onTapCompletion
            )
        }), for: .touchUpInside)
        
    }
    
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        view.backgroundColor = Colors.dim
    }
    
    private func addSubviews() {
        view.addSubview(containerStackView)
        
        if let contentView = contentView {
            containerStackView.addSubview(contentView)
        } else {
            if let titleLabel = titleLabel {
                containerStackView.addArrangedSubview(titleLabel)
            }
            
            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
            }
        }
        
        buttonStackView.addArrangedSubview(leftButton)
        buttonStackView.addArrangedSubview(rightButton)
        buttonStackView.addArrangedSubview(singleButton)
        
        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 32),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -32),
            
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 52),
            buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
        ])
    }
}
