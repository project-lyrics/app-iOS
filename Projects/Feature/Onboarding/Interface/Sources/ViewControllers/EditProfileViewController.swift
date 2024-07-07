//
//  EditProfileViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit
import Shared

public final class EditProfileViewController: BottomSheetViewController<EditProfileView> {
    public override func viewDidLoad() {
        super.viewDidLoad()
        profileCharacterCollectionView.dataSource = self
    }
    }
}

private extension EditProfileViewController {
    var xButton: UIButton {
        bottomSheetView.xButton
    }
    
    var profileCharacterCollectionView: ProfileCharacterCollectionView {
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
