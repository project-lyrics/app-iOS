//
//  ProfileCharacterCollectionView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

import SharedUtil

final class ProfileCharacterCollectionView: UICollectionView {
    private let flowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self
        register(cellType: ProfileCharacterCell.self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellWidth = (frame.width - flowLayout.minimumInteritemSpacing * 3) / 4
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
}

extension ProfileCharacterCollectionView: UICollectionViewDelegate {
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

extension ProfileCharacterCollectionView: UICollectionViewDataSource {
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
