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
        
        guard !isFeelinAlertAlreadyPresented else { return }
        
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
            
            guard !isFeelinAlertAlreadyPresented else { return }
            
            present(alertViewController, animated: false, completion: nil)
        }
    
    private func getTopMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        
        var topMostViewController = keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }

    fileprivate var isFeelinAlertAlreadyPresented: Bool {
        return getTopMostViewController() is FeelinAlertViewController
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

    public var safeAreaBottomInset: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first(where: { $0.isKeyWindow })
            return window?.safeAreaInsets.bottom ?? 0.0
        } else {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        }
    }
}

public extension UIViewController {
    var topMostPresented: UIViewController {
        if let presented = presentedViewController {
            return presented.topMostPresented
        }
        return self
    }
}

// MARK: - Event PopUp

extension UIViewController {
    fileprivate var isFeelinPopUpAlreadyPresented: Bool {
        return getTopMostViewController() is FeelinAlertViewController
    }
    
    private func showPopUp(
        contentImageUrl: URL,
        leftTopActionTitle: String?,
        leftTopActionImage: UIImage?,
        rightTopActionTitle: String?,
        rightTopActionImage: UIImage?,
        leftTopActionCompletion: (() -> Void)?,
        rightTopActionCompletion: (() -> Void)?,
        bottomActionTitle: String,
        bottomActionCompletion: (() -> Void)?
    ) {
        let eventView = FeelinEventView()
        eventView.loadImage(from: contentImageUrl)
        eventView.setButton(
            title: bottomActionTitle,
            onTap: bottomActionCompletion
        )
        
        let popUpViewController = FeelinPopUpViewController(popUpContentView: eventView)
        
        popUpViewController.setLeftTopButton(
            title: leftTopActionTitle,
            image: leftTopActionImage,
            onTap: leftTopActionCompletion
        )
        
        popUpViewController.setRightTopButton(
            title: rightTopActionTitle,
            image: rightTopActionImage,
            onTap: rightTopActionCompletion
        )
        
        guard !isFeelinAlertAlreadyPresented || !isFeelinPopUpAlreadyPresented else {
            print("is feelin alert pres: \(isFeelinAlertAlreadyPresented), is feelin popup : \(isFeelinPopUpAlreadyPresented)")
            return
        }
        
        present(popUpViewController, animated: false)
    }
    
    public func showEventPopUp(
        contentImageUrl: URL,
        leftTopActionTitle: String = "오늘 하루 보지 않기",
        rightTopActionImage: UIImage = FeelinImages.x.withTintColor(.white),
        leftTopActionCompletion: (() -> Void)?,
        rightTopActionCompletion: (() -> Void)?,
        bottomActionTitle: String,
        bottomActionCompletion: (() -> Void)?
    ) {
        self.showPopUp(
            contentImageUrl: contentImageUrl,
            leftTopActionTitle: leftTopActionTitle,
            leftTopActionImage: nil,
            rightTopActionTitle: nil,
            rightTopActionImage: rightTopActionImage,
            leftTopActionCompletion: leftTopActionCompletion,
            rightTopActionCompletion: rightTopActionCompletion,
            bottomActionTitle: bottomActionTitle,
            bottomActionCompletion: bottomActionCompletion
        )
    }
}
