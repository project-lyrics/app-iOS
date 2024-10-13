//
//  DeleteUserViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import UIKit
import Combine

import Shared

public protocol DeleteUserViewControllerDelegate: AnyObject {
    func popViewController(isHiddenTabBar: Bool)
    func didFinish()
}

public final class DeleteUserViewController: UIViewController {

    public weak var coordinator: DeleteUserViewControllerDelegate?

    private let deleteUserView = DeleteUserView()
    private let viewModel: DeleteUserViewModel
    private var cancellables = Set<AnyCancellable>()

    public init(viewModel: DeleteUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = deleteUserView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        bindAction()
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background
    }

    private func bindAction() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController(isHiddenTabBar: false)
            }
            .store(in: &cancellables)

        infoConfirmationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.deleteUserButton.isEnabled = true
            }
            .store(in: &cancellables)

        deleteUserButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.showAlert(title: "탈퇴가 완료되었어요.", message: nil, singleActionTitle: "확인", actionCompletion: {
                    self?.viewModel.deleteUserInfo()
                    self?.coordinator?.popViewController(isHiddenTabBar: false)
                    self?.coordinator?.didFinish()
                })
            }
            .store(in: &cancellables)
    }
}

private extension DeleteUserViewController {
    var backButton: UIButton {
        return deleteUserView.backButton
    }
    
    var infoConfirmationButton: UIButton {
        return deleteUserView.infoConfirmationButton
    }

    var deleteUserButton: UIButton {
        return deleteUserView.deleteUserButton
    }
}
