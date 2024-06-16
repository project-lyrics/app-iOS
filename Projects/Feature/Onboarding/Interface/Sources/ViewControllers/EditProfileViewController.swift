//
//  EditProfileViewController.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import SharedDesignSystem

public final class EditProfileViewController: BottomSheetViewController<EditProfileView> {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAction()
        profileCharacterCollectionView.delegate = self
        profileCharacterCollectionView.dataSource = self
    }
    
    private func setUpAction() {
        xButton.addTarget(
            self,
            action: #selector(xButtonDidTap),
            for: .touchUpInside
        )
        
        selectButton.addTarget(
            self,
            action: #selector(selectButtonDidTap),
            for: .touchUpInside
        )
    }
    
    @objc private func xButtonDidTap() {
        dismiss(animated: true)
    }
    
    @objc private func selectButtonDidTap() {
        dismiss(animated: true)
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

extension EditProfileViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileCharacterCell else {
            return
        }
        cell.setSelected(true)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileCharacterCell else {
            return
        }
        cell.setSelected(false)
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
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileCharacterCell.self)
        cell.configure(with: ProfileCharacterType.allCases[indexPath.row])
        return cell
    }
}
