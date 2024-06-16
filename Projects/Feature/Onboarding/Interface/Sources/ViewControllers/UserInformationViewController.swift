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
        
        genderCollectionView.delegate = self
        genderCollectionView.dataSource = self
    }
}

private extension UserInformationViewController {
    var genderCollectionView: GenderCollectionView {
        userInformationView.genderCollectionView
    }
    
    var birthYearDropDownButton: FeelinDropDownButton {
        userInformationView.birthYearDropDownButton
    }
    
    var nextButton: FeelinConfirmButton {
        userInformationView.nextButton
    }
}

extension UserInformationViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenderCell else {
            return
        }
        cell.setSelected(true)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GenderCell else {
            return
        }
        cell.setSelected(false)
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
