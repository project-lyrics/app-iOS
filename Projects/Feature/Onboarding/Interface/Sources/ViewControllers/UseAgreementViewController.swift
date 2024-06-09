//
//  UseAgreementViewController.swift
//  FeatureOnboardingInterface
//
//  Created by 황인우 on 6/7/24.
//

import FlexLayout
import SharedDesignSystem
import UIKit

public final class UseAgreementViewController: UIViewController {
    // MARK: - View
    private var agreementTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Feelin 이용을 위해 약관을\n동의해주세요"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 24)
        label.textColor = Colors.gray08
        
        return label
    }()
    private let useAgreementListView: UseAgreementListView = .init()
    
    private let startButton: UIButton = {
        let button = FeelinConfirmButton(title: "시작하기")
        
        return button
    }()
    
    private let rootFlexContainer: UIView = .init()
    
    // MARK: - init
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = Colors.background
        self.view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(agreementTitleLabel)
                .marginTop(46)
                .marginHorizontal(20)
            
            flex.addItem(useAgreementListView)
            
            flex.addItem()
                .grow(1)
            
            flex.addItem(startButton)
                .marginHorizontal(20)
                .minHeight(56)
                .cornerRadius(8)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @available(*, unavailable)
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(self.view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}

// MARK: - Agreement Buttons
private extension UseAgreementViewController {
    var allAgreeButton: UIButton {
        return useAgreementListView.allAgreeButton
    }
    
    var ageAgreeButton: UIButton {
        return useAgreementListView.ageAgreeButton
    }
    
    var serviceUsageAgreeButton: UIButton {
        return useAgreementListView.serviceUsageAgreeButton
    }
    
    var checkServiceUsageButton: UIButton {
        return useAgreementListView.checkServiceUsageButton
    }
    
    var personalInfoAgreeButton: UIButton {
        return useAgreementListView.personalInfoAgreeButton
    }
    
    var checkPersonalInfoUsageButton: UIButton {
        return useAgreementListView.checkPersonalInfoUsageButton
    }
}
