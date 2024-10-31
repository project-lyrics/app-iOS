//
//  UseAgreementViewController.swift
//  FeatureOnboardingInterface
//
//  Created by 황인우 on 6/7/24.
//

import FlexLayout
import PinLayout
import SharedDesignSystem
import UIKit
import Combine
import Core
import Domain

public protocol UseAgreementViewControllerDelegate: AnyObject {
    func pushUserInformationViewController(model: UserSignUpEntity)
    func presentInternalWebViewController(url: String)
    func popViewController()
}

public final class UseAgreementViewController: UIViewController {

    private let navigationBar = NavigationBar()

    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

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
    private var cancellables = Set<AnyCancellable>()
    private var model: UserSignUpEntity
    public weak var coordinator: UseAgreementViewControllerDelegate?

    // MARK: - init
    public init(model: UserSignUpEntity) {
        self.model = model
        super.init(nibName: nil, bundle: nil)

        setUpDefault()
        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        rootFlexContainer.pin.all(self.view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }

    private func setUpDefault() {
        self.view.backgroundColor = Colors.background
        self.view.addSubview(rootFlexContainer)

        navigationBar.addLeftBarView([backButton])

        rootFlexContainer.flex.define { flex in
            flex.addItem(navigationBar)
                .height(44)

            flex.addItem(agreementTitleLabel)
                .marginTop(46)
                .marginTop(28)
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

    private func bind() {
        let ageAgreePublisher = ageAgreeButton.publisher(for: .touchUpInside)
        let serviceUsageAgreePublisher = serviceUsageAgreeButton.publisher(for: .touchUpInside)
        let personalInfoAgreePublisher = personalInfoAgreeButton.publisher(for: .touchUpInside)

        Publishers.CombineLatest3(
            ageAgreePublisher,
            serviceUsageAgreePublisher,
            personalInfoAgreePublisher
        )
        .sink { [weak self] ageAgreed, serviceUsageAgreed, personalInfoAgreed in
            let isSelected = ageAgreed.isSelected && serviceUsageAgreed.isSelected && personalInfoAgreed.isSelected
            self?.allAgreeButton.isSelected = isSelected
            self?.startButton.isEnabled = isSelected
        }
        .store(in: &cancellables)

        allAgreeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.allAgreeButtonTapped()
            }
            .store(in: &cancellables)

        checkServiceUsageButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                let url = TermEntity.serviceUsage.notionLink
                self?.coordinator?.presentInternalWebViewController(url: url)
            }
            .store(in: &cancellables)

        checkPersonalInfoUsageButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                let url = TermEntity.personalInfo.notionLink
                self?.coordinator?.presentInternalWebViewController(url: url)
            }
            .store(in: &cancellables)

        startButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let terms = TermEntity.defaultTerms.map { $0.toDTO() }
                model.terms = terms
                coordinator?.pushUserInformationViewController(model: model)
            }
            .store(in: &cancellables)

        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)
    }

    private func allAgreeButtonTapped() {
        let isSelected = allAgreeButton.isSelected
        startButton.isEnabled = isSelected
        if !ageAgreeButton.isSelected,
            !serviceUsageAgreeButton.isSelected,
            !personalInfoAgreeButton.isSelected {
            ageAgreeButton.sendActions(for: .touchUpInside)
            serviceUsageAgreeButton.sendActions(for: .touchUpInside)
            personalInfoAgreeButton.sendActions(for: .touchUpInside)
        } else {
            ageAgreeButton.isSelected = isSelected
            serviceUsageAgreeButton.isSelected = isSelected
            personalInfoAgreeButton.isSelected = isSelected
        }
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

    var personalInfoAgreeButton: UIButton {
        return useAgreementListView.personalInfoAgreeButton
    }

    var checkServiceUsageButton: UIButton {
        return useAgreementListView.checkServiceUsageButton
    }

    var checkPersonalInfoUsageButton: UIButton {
        return useAgreementListView.checkPersonalInfoUsageButton
    }
}
