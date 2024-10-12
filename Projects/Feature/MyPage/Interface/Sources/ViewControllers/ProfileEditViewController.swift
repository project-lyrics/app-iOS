//
//  ProfileEditViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/9/24.
//

import UIKit
import Combine

import Shared
import FeatureOnboardingInterface

public protocol ProfileEditViewControllerDelegate: AnyObject {
    func popViewController(isHiddenTabBar: Bool)
}

public final class ProfileEditViewController: UIViewController {
    private let profileView = ProfileEditView()
    private let editProfileViewController = EditProfileViewController(bottomSheetHeight: 284)

    public weak var coordinator: ProfileEditViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ProfileEditViewModel

    public init(viewModel: ProfileEditViewModel) {
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
        setUpProfilePlaceHolder()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController(isHiddenTabBar: false)
            }
            .store(in: &cancellables)

        profileEditButton.publisher(for: .touchUpInside)
            .sink { _ in
                self.editProfileViewController.modalPresentationStyle = .overFullScreen
                self.present(self.editProfileViewController, animated: false)
            }
            .store(in: &cancellables)

        let profileSelectionPublisher = profileSelectionIndexPublisher
            .map { ProfileCharacterType.allCases[$0].character }
            .eraseToAnyPublisher()

        let nicknameTextPublisher = nicknameTextField.textField.textPublisher
            .eraseToAnyPublisher()

        let saveButtonTapPublisher = saveProfileButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()

        let input = ProfileEditViewModel.Input(
            nicknameTextPublisher: nicknameTextPublisher,
            profileImagePublisher: profileSelectionPublisher,
            saveButtonTapPublisher: saveButtonTapPublisher
        )

        let output = viewModel.transform(input)

        output.isNextButtonEnabled
            .assign(to: \.isEnabled, on: saveProfileButton)
            .store(in: &cancellables)

        output.profileImage
            .sink { [weak self] profileImage in
                self?.profileEditButton.setProfileImage(with: profileImage)
            }
            .store(in: &cancellables)

        output.patchUserProfileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.popViewController(isHiddenTabBar: false)
                case .failure(let error):
                    self?.showAlert(
                        title: error.localizedDescription,
                        message: nil,
                        singleActionTitle: "확인"
                    )
                }
            }
            .store(in: &cancellables)
    }

    private func setUpProfilePlaceHolder() {
        nicknameTextField.textField.placeholder = viewModel.userProfile.nickname
    }
}

private extension ProfileEditViewController {
    var backButton: UIButton {
        return profileView.backButton
    }

    var profileEditButton: ProfileEditButton {
        return profileView.profileEditButton
    }

    var nicknameTextField: FeelinLineInputField {
        return profileView.nicknameTextField
    }

    var saveProfileButton: FeelinConfirmButton {
        return profileView.saveProfileButton
    }

    var profileSelectionIndexPublisher: CurrentValueSubject<Int, Never> {
        return editProfileViewController.profileSelectionIndexPublisher
    }
}
