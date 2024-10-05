//
//  NoteNotificationView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/29/24.
//

import Shared

import UIKit

class NoteNotificationView: UIView {
    
    // MARK: - UI Components
    
    private (set) lazy var noteNotificationCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        collectionView.refreshControl = .init()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: NoteNotificationCell.self)
        collectionView.register(cellType: EmptyNotificationCell.self)
        
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        self.addSubview(noteNotificationCollectionView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        noteNotificationCollectionView.pin.all()
    }
}
