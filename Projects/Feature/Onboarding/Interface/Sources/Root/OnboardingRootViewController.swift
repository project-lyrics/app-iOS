//
//  OnboardingRootViewController.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 4/20/24.
//

import UIKit
import FlexLayout

public protocol OnboardingRootViewControllerDelegate: AnyObject {
    func didFinish()
}

public final class OnboardingRootViewController: UIViewController {
    private let onboardingView = OnboardingView()
    public weak var coordinator: OnboardingRootViewControllerDelegate?

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = onboardingView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        onboardingView.configureLayouts()
        bind()
        addButtonAction()
    }

    private func bind() {

    private func addButtonAction() {
        onboardingView.actionAppleLogin { [weak self] in
            self?.viewModel.inputs.appleLogin()
        }

        onboardingView.actionKakaoLogin { [weak self] in
            self?.viewModel.inputs.kakaoLogin()
        }

        onboardingView.actionContinueWithoutLogin { [weak self] in
            self?.coordinator?.didFinish()
        }
    }
}
