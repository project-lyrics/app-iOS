//
//  UserLinkedWebView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/13/24.
//

import FlexLayout
import Shared

import Combine
import UIKit
import WebKit


public final class UserLinkedWebView: UIView {
    
    // MARK: - Properties
    
    private let urlString: String
    private let tabItemSize: CGFloat = 24
    private let tabItemMarginTop: CGFloat = 14
    private let tabItemMarginBottom: CGFloat = 5
    
    public var tabViewHeight: CGFloat {
        return tabItemSize + tabItemMarginTop + tabItemMarginBottom
    }
    
    // MARK: - UI Components
    
    private let flexContainer = UIView()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.x, for: .normal)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09
        label.textAlignment = .center
        label.text = urlString
        
        return label
    }()
    
    let reloadButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.reload, for: .normal)
        
        return button
    }()
    
    let bottomBackButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.webBackEnabled, for: .normal)
        button.setImage(FeelinImages.webBackDisabled, for: .disabled)
        
        return button
    }()
    
    let bottomForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.webForwardEnabled, for: .normal)
        button.setImage(FeelinImages.webForwardDisabled, for: .disabled)
        
        return button
    }()
    
    let bottomShareButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.webShare, for: .normal)
        
        return button
    }()
    
    let bottomMoreAboutButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.webMoreAbout, for: .normal)
        
        return button
    }()
    
    
    let webView: WKWebView = .init()
    
    public init(urlString: String, frame: CGRect = .zero) {
        self.urlString = urlString
        super.init(frame: frame)
        
        self.backgroundColor = Colors.background
        self.setUpLayout()
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        flexContainer.pin
            .top(pin.safeArea)
            .left()
            .right()
            .bottom(pin.safeArea)
        
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        
        flexContainer.flex
            .define { flex in
                flex.addItem()
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .paddingLeft(20)
                    .paddingRight(20)
                    .paddingVertical(10)
                    .define { flex in
                        flex.addItem(closeButton)
                            .size(24)
                        
                        flex.addItem(titleLabel)
                            .maxWidth(80%)
                        
                        flex.addItem(reloadButton)
                            .size(24)
                    }
                
                flex.addItem(webView)
                    .grow(1)
                
                flex.addItem()
                    .direction(.row)
                    .justifyContent(.spaceBetween)
                    .marginTop(tabItemMarginTop)
                    .paddingHorizontal(20)
                    .marginBottom(tabItemMarginBottom)
                    .define { flex in
                        flex.addItem(bottomBackButton)
                            .size(tabItemSize)
                        
                        flex.addItem(bottomForwardButton)
                            .size(tabItemSize)
                        
                        flex.addItem(bottomShareButton)
                            .size(tabItemSize)
                        
                        flex.addItem(bottomMoreAboutButton)
                            .size(tabItemSize)
                    }
            }
    }
}
