//
//  GenderCollectionView.swift
//  FeatureOnboardingInterface
//
//  Created by jiyeon on 6/12/24.
//

import UIKit

final class GenderCollectionView: UICollectionView {
    
    private let flowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 14
        return layout
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        delegate = self
        dataSource = self
        register(GenderCell.self, forCellWithReuseIdentifier: GenderCell.reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let genderCellWidth = (frame.width - flowLayout.minimumInteritemSpacing) / 2
        let genderCellHeight = frame.height
        flowLayout.itemSize = CGSize(width: genderCellWidth, height: genderCellHeight)
    }
}

extension GenderCollectionView: UICollectionViewDelegate {
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

extension GenderCollectionView: UICollectionViewDataSource {
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
