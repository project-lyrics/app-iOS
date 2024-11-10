//
//  EditUserInfoViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/13/24.
//

import UIKit
import Combine

import Shared
import Domain
import FeatureOnboardingInterface

public protocol EditUserInfoViewControllerDelegate: AnyObject {
    func popViewController()
    func handleError(
        errorCode: String?,
        errorMessage: String,
        errorData: AnyType?
    )
}

public final class EditUserInfoViewController: UIViewController {
    private let userInformationView = EditUserInfoView()
    private let selectBirthYearViewController = SelectBirthYearViewController(
        bottomSheetHeight: 284,
        baseYear: 2000
    )
    private let genderPublisher = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    public weak var coordinator: EditUserInfoViewControllerDelegate?
    private var viewModel: EditUserInfoViewModel

    public override func loadView() {
        view = userInformationView
    }

    public init(viewModel: EditUserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        genderCollectionView.delegate = self
        genderCollectionView.dataSource = self
        configure(model: viewModel.userProfile)
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.showAlert(
                    title: "저장하지 않고 나가시겠어요?",
                    message: nil,
                    leftActionTitle: "취소",
                    rightActionTitle: "나가기",
                    rightActionCompletion: {
                        self?.coordinator?.popViewController()
                    }
                )
            }
            .store(in: &cancellables)

        birthYearDropDownButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }

                selectBirthYearViewController.modalPresentationStyle = .overFullScreen
                present(selectBirthYearViewController, animated: false)
            }
            .store(in: &cancellables)

        birthYearDropDownButtonPublisher
            .sink { [weak self] year in
                self?.birthYearDropDownButton.setDescription("\(year)년")
            }
            .store(in: &cancellables)

        let saveButtonTapPublisher = saveProfileButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
      
        let input = EditUserInfoViewModel.Input(
            birthYearPublisher: birthYearDropDownButtonPublisher.eraseToAnyPublisher(),
            genderPublisher: genderPublisher.eraseToAnyPublisher(),
            saveButtonTapPublisher: saveButtonTapPublisher
        )

        let output = viewModel.transform(input)

        output.isSaveButtonEnabled
            .assign(to: \.isEnabled, on: saveProfileButton)
            .store(in: &cancellables)

        output.patchUserProfileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.popViewController()
                case .failure(let error):
                    self?.coordinator?.handleError(
                        errorCode: error.errorCode,
                        errorMessage: error.userMessage,
                        errorData: error.data
                    )
                }
            }
            .store(in: &cancellables)
    }

    private func configure(model: UserProfile) {
        if let gender = model.gender {
            genderPublisher.send(gender.rawValue)
        }

        if let birthYear = model.birthYear {
            birthYearDropDownButtonPublisher.send(birthYear)
        }
    }
}

extension EditUserInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let cell = genderCollectionView.cellForItem(at: indexPath) as? GenderCell {
            let isSelected = genderCollectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
            cell.setSelected(isSelected)
            genderPublisher.send(GenderEntity.allCases[indexPath.row].rawValue)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = genderCollectionView.cellForItem(at: indexPath) as? GenderCell {
            let isSelected = genderCollectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
            cell.setSelected(isSelected)
        }
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return GenderEntity.allCases.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let model = GenderEntity.allCases[indexPath.row]
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GenderCell.self)
        cell.configure(with: model)

        if let gender = viewModel.userProfile.gender,
           indexPath.row == gender.index {
            cell.setSelected(true)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
        
        return cell
    }
}

private extension EditUserInfoViewController {
    var genderCollectionView: UICollectionView {
        return userInformationView.genderCollectionView
    }

    var birthYearDropDownButton: FeelinDropDownButton {
        return userInformationView.birthYearDropDownButton
    }

    var saveProfileButton: FeelinConfirmButton {
        return userInformationView.saveProfileButton
    }

    var backButton: UIButton {
        return userInformationView.backButton
    }

    var birthYearDropDownButtonPublisher: PassthroughSubject<Int, Never> {
        return selectBirthYearViewController.selectedYearSubject
    }
}
