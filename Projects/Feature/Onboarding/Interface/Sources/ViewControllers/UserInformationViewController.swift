//
//  UserInformationViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

import SharedDesignSystem

public final class UserInformationViewController: UIViewController {
    private let userInformationView = UserInformationView()
    
    public override func loadView() {
        view = userInformationView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        userInformationView.genderCollectionView.delegate = self
        userInformationView.genderCollectionView.dataSource = self
    }
}

extension UserInformationViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenderCell else {
            return
        }
        cell.didSelect()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenderCell else {
            return
        }
        cell.didDeselect()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenderCell.reuseIdentifier, for: indexPath) as? GenderCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: GenderType.allCases[indexPath.row])
        return cell
    }
}
