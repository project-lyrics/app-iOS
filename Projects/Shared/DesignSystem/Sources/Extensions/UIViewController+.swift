//
//  UIViewController+.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 7/9/24.
//

import UIKit

// MARK: - Alert

extension UIViewController {
    public func showAlert(
        shouldIgnoreDarkMode: Bool = false,
        title: String,
        message: String?,
        attributedMessage: NSAttributedString? = nil,
        leftActionTitle: String = "취소",
        rightActionTitle: String = "확인",
        leftActionCompletion: (() -> Void)? = nil,
        rightActionCompletion: (() -> Void)? = nil) {
            let alertViewController = FeelinAlertViewController(
                titleText: title,
                messageText: message,
                attributedMessageText: attributedMessage,
                shouldIgnoreDarkMode: shouldIgnoreDarkMode
            )
            
            showAlert(
                alertViewController: alertViewController,
                leftActionTitle: leftActionTitle,
                rightActionTitle: rightActionTitle,
                leftActionCompletion: leftActionCompletion,
                rightActionCompletion: rightActionCompletion
            )
        }
    
    public func showAlert(
        shouldIgnoreDarkMode: Bool = false,
        title: String,
        message: String?,
        attributedMessage: NSAttributedString? = nil,
        singleActionTitle: String,
        actionCompletion: (() -> Void)? = nil
    ) {
        let alertViewController = FeelinAlertViewController(
            titleText: title,
            messageText: message,
            attributedMessageText: attributedMessage,
            shouldIgnoreDarkMode: shouldIgnoreDarkMode
        )
        
        showAlert(
            alertViewController: alertViewController,
            actionTitle: singleActionTitle,
            actionCompletion: actionCompletion
        )
    }
    
    public func showAlert(
        contentView: UIView,
        leftActionTitle: String = "취소",
        rightActionTitle: String = "확인",
        leftActionCompletion: (() -> Void)? = nil,
        rightActionCompletion: (() -> Void)? = nil
    ) {
        let alertViewController = FeelinAlertViewController(contentView: contentView)
        
        showAlert(
            alertViewController: alertViewController,
            leftActionTitle: leftActionTitle,
            rightActionTitle: rightActionTitle,
            leftActionCompletion: leftActionCompletion,
            rightActionCompletion: rightActionCompletion
        )
    }
    
    private func showAlert(
        alertViewController: FeelinAlertViewController,
        actionTitle: String,
        actionCompletion: (() -> Void)?
    ) {
        alertViewController.setSingleButton(
            title: actionTitle,
            onTapCompletion: actionCompletion
        )
        
        present(alertViewController, animated: false, completion: nil)
    }
    
    private func showAlert(
        alertViewController: FeelinAlertViewController,
        leftActionTitle: String,
        rightActionTitle: String,
        leftActionCompletion: (() -> Void)?,
        rightActionCompletion: (() -> Void)?) {
            alertViewController.setLeftButton(
                title: leftActionTitle,
                onTapCompletion: leftActionCompletion
            )
            alertViewController.setRightButton(
                title: rightActionTitle,
                onTapCompletion: rightActionCompletion
            )
            
            present(alertViewController, animated: false, completion: nil)
        }
}

// MARK: - Toast

extension UIViewController {
    public func showToast(
        iconImage: UIImage,
        message: String,
        duration: TimeInterval = 3,
        bottomMargin: CGFloat? = nil
    ) {
        let feelinToastView = FeelinToastView(
            iconImage: iconImage,
            message: message,
            frame: .zero
        )
        feelinToastView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(feelinToastView)
        
        // Safe Area와 Tab Bar를 고려한 Auto Layout Constraints 설정
        let safeArea = self.view.safeAreaLayoutGuide
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        
        let bottomMargin = -(bottomMargin ?? (tabBarHeight + 5))
        
        NSLayoutConstraint.activate([
            feelinToastView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            feelinToastView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            feelinToastView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: bottomMargin),
            feelinToastView.heightAnchor.constraint(equalToConstant: 56)
            ])
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState],
            animations: {
                feelinToastView.alpha = 0.0
            }) { _ in
                feelinToastView.removeFromSuperview()
            }
    }
}
