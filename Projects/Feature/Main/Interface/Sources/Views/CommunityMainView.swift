//
//  CommunityMainView.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 10/1/24.
//

import Shared

import UIKit

class CommunityMainView: UIView {
    
    // MARK: - UI Components
    
    private (set) var communityMainCollectionView: UICollectionView = {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case CommunityMainView.artistSectionIndex:
                return CommunityMainView.createArtistSection()
                
            case CommunityMainView.noteSectionIndex:
                return CommunityMainView.createNotesSection()
                
            default:
                return nil
            }
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
        )
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: CommunityArtistCell.self)
        collectionView.register(cellType: NoteCell.self)
        collectionView.register(cellType: EmptyNoteCell.self)
        collectionView.register(
            supplementaryViewType: CommunityNoteHeaderView.self,
            ofKind: CommunityNoteHeaderView.reuseIdentifier
        )
        
        return collectionView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        addSubview(communityMainCollectionView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        communityMainCollectionView.refreshControl?.bounds = CGRect(
            x: communityMainCollectionView.refreshControl?.bounds.minX ?? 0,
            y: -UIApplication.shared.safeAreaInsets.top,
            width: communityMainCollectionView.refreshControl?.bounds.width ?? 0,
            height: communityMainCollectionView.refreshControl?.bounds.height ?? 0
        )
        communityMainCollectionView.pin.all()
    }
}

extension CommunityMainView {
    static let artistSectionIndex = 0
    static let noteSectionIndex = 1
    static let artistSectionHeight: CGFloat = 390
    
    static func createArtistSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Self.artistSectionHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Self.artistSectionHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    static func createNotesSection() -> NSCollectionLayoutSection {
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
            elementKind: CommunityNoteHeaderView.reuseIdentifier,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        return section
    }
}
