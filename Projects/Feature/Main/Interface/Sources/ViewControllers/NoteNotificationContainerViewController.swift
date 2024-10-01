//
//  NoteNotificationContainerViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/29/24.
//

import FlexLayout
import PinLayout
import Shared

import UIKit

public final class NoteNotificationContainerViewController: UIViewController {
    private let noteNotificationPageViewController = NoteNotificationPageViewController()
    
    // MARK: - UI
    
    private let flexContainer = UIView()
    private let navigationBar = NavigationBar()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let userInterfaceStyle = self.traitCollection.userInterfaceStyle
        let image = userInterfaceStyle == .light ? FeelinImages.backLight : FeelinImages.backDark
        button.setImage(image, for: .normal)

        return button
    }()
    
    private var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        
        return label
    }()
    
    // MARK: - View Lifecycle
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        flexContainer.pin
            .top(view.pin.safeArea)
            .horizontally()
            .bottom()
        
        flexContainer.flex.layout()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDefault()
    }
    
    private func setUpDefault() {
        self.view.backgroundColor = Colors.background
        self.view.addSubview(flexContainer)
        
        navigationBar.addLeftBarView(backButton)
        navigationBar.addTitleView(navigationTitleLabel)
        
        flexContainer.flex.define { flex in
            flex.addItem(navigationBar)
                .height(44)
            
            flex.addItem(noteNotificationPageViewController.view)
        }
    }

}
