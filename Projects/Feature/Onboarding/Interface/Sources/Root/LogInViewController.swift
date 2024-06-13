//
//  LogInViewController.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 4/20/24.
//

import UIKit
import FlexLayout
import Combine

public protocol LogInViewControllerDelegate: AnyObject {
    func didFinish()
}

public final class LogInViewController: UIViewController {
    private let loginView = LogInView()
    private let viewModel: LogInViewModel
    private var cancellables = Set<AnyCancellable>()

    public weak var coordinator: LogInViewControllerDelegate?

    public init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        super.loadView()
        view = loginView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
    }

    private func setUpDefault() {
        loginView.configureLayouts()
        addButtonTargets()
        bind()
        viewModel.fetchRecentLogInRecord()
    }

    private func bind() {
        viewModel.outputs.loginSuccess
            .sink { [weak self] success in
                if success {
                    self?.coordinator?.didFinish()
                }
            }
            .store(in: &cancellables)

        // TODO: 공통 Modal View 구현 필요
        viewModel.outputs.loginFailure
            .sink { error in
                
            }
            .store(in: &cancellables)

        viewModel.outputs.recentLogInRecord
            .sink { [weak self] type in
                switch type {
                case .none:
                    break
                case .appleLogin:
                    self?.loginView.setUpRecentLogInRecordBallonView(true)
                case .kakaoLogin:
                    self?.loginView.setUpRecentLogInRecordBallonView(false)
                }
            }
            .store(in: &cancellables)
    }

    private func addButtonTargets() {
        appleLogInButton.addTarget(
            self,
            action: #selector(appleLogInButtonTapped),
            for: .touchUpInside
        )

        kakaoLogInButton.addTarget(
            self,
            action: #selector(kakaoLogInButtonTapped),
            for: .touchUpInside
        )

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(continueWithoutLogInLabelTapped)
        )
        continueWithoutLogInLabel.addGestureRecognizer(tapGesture)
    }

    @objc private func appleLogInButtonTapped(_ sender: UIButton) {
        viewModel.inputs.appleLogIn()
    }

    @objc private func kakaoLogInButtonTapped(_ sender: UIButton) {
        viewModel.inputs.kakaoLogin()
    }

    @objc private func continueWithoutLogInLabelTapped(_ sender: UIGestureRecognizer) {
        coordinator?.didFinish()
    }
}

// MARK: UI Properties
private extension LogInViewController {
    var kakaoLogInButton: UIButton {
        return loginView.kakaoLogInButton
    }

    var appleLogInButton: UIButton {
        return loginView.appleLogInButton
    }

    var continueWithoutLogInLabel: UILabel {
        return loginView.continueWithoutLogInLabel
    }
}
