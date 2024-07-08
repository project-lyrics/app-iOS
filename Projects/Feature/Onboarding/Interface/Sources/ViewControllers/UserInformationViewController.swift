//
//  UserInformationViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import Combine
import UIKit
import Domain
import Shared

public protocol UserInformationViewControllerDelegate: AnyObject {
    func pushProfileViewController(model: UserSignUpEntity)
    func popViewController()
}

public final class UserInformationViewController: UIViewController {
    private let userInformationView = UserInformationView()
    private let selectBirthYearViewController = SelectBirthYearViewController(
        bottomSheetHeight: 284,
        baseYear: 2000
    )

    private let genderSelectionPublisher = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    public weak var coordinator: UserInformationViewControllerDelegate?
    private var model: UserSignUpEntity

    public override func loadView() {
        view = userInformationView
    }

    public init(model: UserSignUpEntity) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        genderCollectionView.dataSource = self
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        skipButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                coordinator?.pushProfileViewController(model: model)
            }
            .store(in: &cancellables)

        genderCollectionView.publisher(for: [.didSelectItem, .didDeselectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                if let cell = genderCollectionView.cellForItem(at: indexPath) as? GenderCell {
                    let isSelected = genderCollectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
                    cell.setSelected(isSelected)
                    model.gender = indexPath.row == 0 ? .male : .female
                    genderSelectionPublisher.send(true)
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
                self?.model.birthYear = year
                self?.birthYearDropDownButton.setDescription(year)
            }
            .store(in: &cancellables)

        Publishers.CombineLatest(genderSelectionPublisher, birthYearDropDownButtonPublisher)
            .map { isGenderSelected, birthYear in
                return isGenderSelected && !birthYear.isEmpty
            }
            .sink { [weak self] isEnabled in
                self?.nextButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)

        nextButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                coordinator?.pushProfileViewController(model: model)
            }
            .store(in: &cancellables)
    }
}

extension UserInformationViewController: UICollectionViewDataSource {
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
        return cell
    }
}

private extension UserInformationViewController {
    var genderCollectionView: UICollectionView {
        return userInformationView.genderCollectionView
    }

    var birthYearDropDownButton: FeelinDropDownButton {
        return userInformationView.birthYearDropDownButton
    }

    var nextButton: FeelinConfirmButton {
        return userInformationView.nextButton
    }

    var backButton: UIButton {
        return userInformationView.backButton
    }
    
    var skipButton: UIButton {
        return userInformationView.skipButton
    }

    var birthYearDropDownButtonPublisher: PassthroughSubject<String, Never> {
        return selectBirthYearViewController.selectedYearSubject
    }
}
