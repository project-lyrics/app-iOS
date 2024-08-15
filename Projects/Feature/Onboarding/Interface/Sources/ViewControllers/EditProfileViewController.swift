//
//  EditProfileViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit
import Combine
import Shared

public final class EditProfileViewController: BottomSheetViewController<EditProfileView> {
    private var cancellables = Set<AnyCancellable>()
    private var selectedProfileIndex: Int = 0
    public let profileSelectionIndexPublisher = CurrentValueSubject<Int, Never>(0)

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        profileCharacterCollectionView.dataSource = self
    }

    private func bind() {
        xButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)

        selectButton.publisher(for: .touchUpInside)
            .sink { [weak self] (_) in
                self?.profileSelectionIndexPublisher.send(self?.selectedProfileIndex ?? 0)
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)

        profileCharacterCollectionView.publisher(for: [.didSelectItem, .didDeselectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                if let cell = self.profileCharacterCollectionView.cellForItem(at: indexPath) as? ProfileCharacterCell {
                    let isSelected = self.profileCharacterCollectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
                    cell.setSelected(isSelected)
                    selectButton.isEnabled = isSelected
                    selectedProfileIndex = indexPath.row
                }
            }
            .store(in: &cancellables)
    }
}

private extension EditProfileViewController {
    var xButton: UIButton {
        bottomSheetView.xButton
    }

    var profileCharacterCollectionView: UICollectionView {
        bottomSheetView.profileCharacterCollectionView
    }

    var selectButton: UIButton {
        bottomSheetView.selectButton
    }
}

extension EditProfileViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return ProfileCharacterType.allCases.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            for: indexPath,
            cellType: ProfileCharacterCell.self
        )
        cell.configure(with: ProfileCharacterType.allCases[indexPath.row])
        return cell
    }
}
