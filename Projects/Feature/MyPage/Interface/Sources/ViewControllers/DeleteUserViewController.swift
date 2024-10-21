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
    func popViewController()
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
        
        self.hidesBottomBarWhenPushed = true
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
        bindUI()
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

        infoConfirmationButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.deleteUserButton.isEnabled = !self.deleteUserButton.isEnabled
            }
            .store(in: &cancellables)

        deleteUserButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewModel.deleteUserInfo()
                
            }
            .store(in: &cancellables)
    }
    
    private func bindUI() {
        viewModel.$deleteUserResult
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.showAlert(
                        title: "탈퇴가 완료되었어요.",
                        message: nil,
                        singleActionTitle: "확인",
                        actionCompletion: {
                            self?.coordinator?.didFinish()
                    })
                    
                case .failure(let error):
                    self?.showAlert(
                        title: error.errorMessageWithCode,
                        message: nil,
                        singleActionTitle: "확인"
                    )
                    
                default:
                    break
                }
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
