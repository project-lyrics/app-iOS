//
//  ProfileViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import Combine
import Domain
import Shared

public protocol ProfileViewControllerDelegate: AnyObject {
    func popViewController()
    func pushWelcomeViewController()
}

public final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    private let editProfileViewController = EditProfileViewController(bottomSheetHeight: 284)

    public weak var coordinator: ProfileViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ProfileViewModel

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = profileView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func bind() {
        let nicknameTextPublisher = PassthroughSubject<String?, Never>()
        let profileImagePublisher = PassthroughSubject<String?, Never>()

        let combinedSignUpModelPublisher = Publishers.CombineLatest(
            nicknameTextPublisher,
            profileImagePublisher
        )
            .compactMap { (nickname, profileCharacter) -> UserSignUpEntity? in
                guard let nickname = nickname,
                      let profileCharacter = profileCharacter else { return nil }

                return UserSignUpEntity(nickname: nickname, profileCharacter: profileCharacter)
            }
            .eraseToAnyPublisher()

        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        profileEditButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.editProfileViewController.modalPresentationStyle = .overFullScreen
                self.present(self.editProfileViewController, animated: false)
            }
            .store(in: &cancellables)

        let profileSelectionPublisher = profileSelectionPublisher
            .map { ProfileCharacterType.allCases[$0].character }

        let nicknameTextPublisher = nicknameTextField.textField.textPublisher
            .share()

        let profileImagePublisher = CurrentValueSubject<String, Never>(ProfileCharacterType.defaultCharacter)

        profileSelectionPublisher
            .sink { character in
                profileImagePublisher.send(character)
            }
            .store(in: &cancellables)

        let input = ProfileViewModel.Input(
            nicknameTextPublisher: nicknameTextPublisher.eraseToAnyPublisher(),
            profileImagePublisher: profileImagePublisher.eraseToAnyPublisher(),
            nextButtonTapPublisher: nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        )

        let output = viewModel.transform(input)

        output.isNextButtonEnabled
            .assign(to: \.isEnabled, on: nextButton)
            .store(in: &cancellables)

        output.profileImage
            .sink { [weak self] profileImage in
                self?.profileEditButton.setProfileImage(with: profileImage)
            }
            .store(in: &cancellables)

        output.signUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.pushWelcomeViewController()
                case .failure(let error):
                    self?.showAlert(title: "알림", message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)

        profileImagePublisher.send(ProfileCharacterType.defaultCharacter)
    }
}

private extension ProfileViewController {
    var backButton: UIButton {
        return profileView.backButton
    }

    var profileEditButton: ProfileEditButton {
        return profileView.profileEditButton
    }

    var nicknameTextField: FeelinLineInputField {
        return profileView.nicknameTextField
    }

    var nextButton: FeelinConfirmButton {
        return profileView.nextButton
    }

    var profileSelectionPublisher: PassthroughSubject<Int, Never> {
        return editProfileViewController.profileSelectionPublisher
    }
}
