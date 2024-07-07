//
//  UserInformationViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

import Shared

public final class UserInformationViewController: UIViewController {
    private let userInformationView = UserInformationView()
    public override func loadView() {
        view = userInformationView
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        genderCollectionView.dataSource = self
    }


    }
}

extension UserInformationViewController: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return GenderType.allCases.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GenderCell.self)
        cell.configure(with: GenderType.allCases[indexPath.row])
        return cell
    }
}

    }
}
