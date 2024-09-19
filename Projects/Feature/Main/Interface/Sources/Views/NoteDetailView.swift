//
//  NoteDetailView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/7/24.
//

import UIKit

import Shared

final class NoteDetailView: UIView {
    
    // MARK: - UI Components
    
    private (set) var noteDetailCollectionView: UICollectionView = {
        let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case NoteDetailView.songSectionIndex:
                return NoteDetailView.createSongSection()
                
            case NoteDetailView.relatedNoteSectionIndex:
                return NoteDetailView.createRelatedNoteSection()
                
            default:
                return nil
            }
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
        )
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(cellType: SongCell.self)
        collectionView.register(cellType: NoteCell.self)
        collectionView.register(
            supplementaryViewType: NoteDetailHeaderView.self,
            ofKind: NoteDetailHeaderView.reuseIdentifier
        )
        
        return collectionView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        self.addSubview(noteDetailCollectionView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        noteDetailCollectionView.pin.all()
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension NoteDetailView {
    static let songSectionIndex = 0
    static let relatedNoteSectionIndex = 1
    
    static func createSongSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(72)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(72)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 28,
            leading: 20,
            bottom: 28,
            trailing: 20
        )
        
        return section
    }
    
    static func createRelatedNoteSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = .init(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(64)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: NoteDetailHeaderView.reuseIdentifier,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
