//
//  UIViewController+.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 7/9/24.
//

import UIKit

extension UIViewController {
    public func showAlert(
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
                attributedMessageText: attributedMessage
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
        title: String,
        message: String?,
        attributedMessage: NSAttributedString? = nil,
        singleActionTitle: String,
        actionCompletion: (() -> Void)? = nil
    ) {
        let alertViewController = FeelinAlertViewController(
            titleText: title,
            messageText: message,
            attributedMessageText: attributedMessage
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
