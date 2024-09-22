//
//  UICollectionView+.swift
//  SharedUtil
//
//  Created by jiyeon on 6/14/24.
//

import UIKit
import Combine

public extension UICollectionView {
    final func register<Cell: UICollectionViewCell>(cellType: Cell.Type) where Cell: Reusable {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func register<ReusableView: UICollectionReusableView>(supplementaryViewType: ReusableView.Type, ofKind elementKind: String)
    where ReusableView: Reusable {
        self.register(
            supplementaryViewType.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: supplementaryViewType.reuseIdentifier
        )
    }

    final func dequeueReusableCell<Cell: UICollectionViewCell>(
        for indexPath: IndexPath,
        cellType: Cell.Type = Cell.self
    ) -> Cell where Cell: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(cellType.reuseIdentifier)")
        }
        return cell
    }
    
    final func dequeueReusableSupplementaryView<ReusableView: UICollectionReusableView>
    (ofKind elementKind: String, for indexPath: IndexPath, viewType: ReusableView.Type = ReusableView.self) -> ReusableView
    where ReusableView: Reusable {
        let view = self.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        )
        guard let typedView = view as? ReusableView else {
            fatalError(
                "Failed to dequeue a supplementary view with identifier \(viewType.reuseIdentifier)"
            )
        }
        return typedView
    }
}
