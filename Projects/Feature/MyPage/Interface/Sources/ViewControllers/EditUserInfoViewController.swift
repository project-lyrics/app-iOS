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
    func popViewController(isHiddenTabBar: Bool)
}

public final class EditUserInfoViewController: UIViewController {
    private let userInformationView = EditUserInfoView()
    private let selectBirthYearViewController = SelectBirthYearViewController(
        bottomSheetHeight: 284,
        baseYear: 2000
    )
    private let genderPublisher = PassthroughSubject<String, Never>()
    private let genderSelectionPublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    public weak var coordinator: EditUserInfoViewControllerDelegate?
    private var viewModel: EditUserInfoViewModel

    public override func loadView() {
        view = userInformationView
    }

    public init(viewModel: EditUserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .light
        bind()
        genderCollectionView.dataSource = self
        configure(model: viewModel.model)
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
                        self?.coordinator?.popViewController(isHiddenTabBar: false)
                    }
                )
            }
            .store(in: &cancellables)

        genderCollectionView.publisher(for: [.didSelectItem, .didDeselectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                if let cell = genderCollectionView.cellForItem(at: indexPath) as? GenderCell {
                    let isSelected = genderCollectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
                    cell.setSelected(isSelected)
                    genderSelectionPublisher.send(true)
                    genderPublisher.send(GenderEntity.allCases[indexPath.row].rawValue)
                }
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

        Publishers.CombineLatest(genderSelectionPublisher, birthYearDropDownButtonPublisher)
            .map { isGenderSelected, birthYear in
                return isGenderSelected && !"\(birthYear)".isEmpty
            }
            .sink { [weak self] isEnabled in
                self?.saveProfileButton.isEnabled = isEnabled
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

    private func configure(model: UserProfile) {
        if let birthYear = model.birthYear {
            birthYearDropDownButtonPublisher.send(birthYear)
        }
    }
}

extension EditUserInfoViewController: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GenderCell.self)
        cell.configure(with: GenderEntity.allCases[indexPath.row])

        if let gender = viewModel.model.gender,
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
