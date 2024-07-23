//
//  LoginViewController.swift
//  FeatureOnboardingInterface
//
//  Created by Derrick kim on 4/20/24.
//

import UIKit
import FlexLayout
import Combine
import Domain

public protocol LoginViewControllerDelegate: AnyObject {
    func didFinish()
    func pushUseAgreementViewController(model: UserSignUpEntity)
    func connectTabBarFlow()
}

public final class LoginViewController: UIViewController {
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()

    private var loginButtonTapped: PassthroughSubject<OAuthType, Never> = .init()
    private var recentLoginLoaded: PassthroughSubject<Void, Never> = .init()

    public weak var coordinator: LoginViewControllerDelegate?

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = loginView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        recentLoginLoaded.send()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
    }

    private func setUpDefault() {
        loginView.configureLayouts()
        bindUI()
        bind()
    }

    private func bindUI() {
        kakaoLoginButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.loginButtonTapped.send(.kakao)
            }
            .store(in: &cancellables)

        appleLoginButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.loginButtonTapped.send(.apple)
            }
            .store(in: &cancellables)

        continueWithoutLoginLabel.tapPublisher
            .sink { [weak self] _ in
                self?.coordinator?.didFinish()
            }
            .store(in: &cancellables)
    }

    private func bind() {
        let loginButtonTappedPublisher = loginButtonTapped.eraseToAnyPublisher()
        let recentLoginPublisher = recentLoginLoaded.eraseToAnyPublisher()

        let input = LoginViewModel.Input(
            loginButtonTappedPublisher: loginButtonTappedPublisher,
            recentLoginPublisher: recentLoginPublisher
        )

        let output = viewModel.transform(input)

        output.loginResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let type):
                    self?.coordinator?.connectTabBarFlow()

                case .failure(let error):
                    switch error {
                    case let .feelinError(.userNotFound((accessToken, oAuthType))):
                        let model = UserSignUpEntity(
                            socialAccessToken: accessToken,
                            oAuthType: oAuthType
                        )
                        
                        self?.coordinator?.pushUseAgreementViewController(model: model)

                    default:
                        self?.showAlert(title: "알림", message: error.localizedDescription)
                    }
                }
            }
            .store(in: &cancellables)

        output.recentLoginResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                switch type {
                case .none:
                    break
                default:
                    self?.loginView.setUpRecentLoginRecordBallonView(type)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: UI Properties
private extension LoginViewController {
    var kakaoLoginButton: UIButton {
        return loginView.kakaoLoginButton
    }

    var appleLoginButton: UIButton {
        return loginView.appleLoginButton
    }

    var continueWithoutLoginLabel: UILabel {
        return loginView.continueWithoutLoginLabel
    }
}
