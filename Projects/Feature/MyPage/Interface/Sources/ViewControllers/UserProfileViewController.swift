//
//  UserProfileViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import UIKit
import Combine

import Shared
import Domain

public protocol UserProfileViewControllerDelegate: AnyObject {
    func popViewController()
    func pushEditUserInfoViewController(data: UserProfile)
}

public final class UserProfileViewController: UIViewController {

    public weak var coordinator: UserProfileViewControllerDelegate?

    private let userProfileView = UserProfileView()
    private let viewModel: UserProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    public init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = userProfileView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        bindAction()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserProfile()
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background
    }

    private func bindAction() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)   

        copyButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                //TODO: 복사하기 토스트 필요.
                UIPasteboard.general.string = self?.viewModel.fetchedUserProfile?.feedbackID
            }
            .store(in: &cancellables)

        userProfileView.tapPublisher
            .sink { [weak self] _ in
                guard let self = self,
                      let data = viewModel.fetchedUserProfile 
                else { return }
                coordinator?.pushEditUserInfoViewController(data: data)
            }
            .store(in: &cancellables)

        viewModel.$fetchedUserProfile
            .sink { [weak self] userProfile in
                self?.userProfileView.configure(userProfile)
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showAlert(
                    title: error.localizedDescription,
                    message: nil,
                    singleActionTitle: "확인"
                )
            }
            .store(in: &cancellables)
    }
}

private extension UserProfileViewController {
    var backButton: UIButton {
        return userProfileView.backButton
    }    

    var copyButton: UIButton {
        return userProfileView.copyButton
    }    

    var otherInfoContainerView: UIView {
        return userProfileView.otherInfoContainerView
    }
}
