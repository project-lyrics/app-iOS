//
//  MyNoteContentView.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/7/24.
//

import Combine
import UIKit

import Domain
import Shared

import FeatureHomeInterface

final class MyNoteContentView: UIView {

    // MARK: - UI Components
    static let favoriteArtistsSectionIndex = 0
    static let relatedNoteSectionIndex = 1

    private (set) var noteDetailCollectionView: UICollectionView = {
        let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            switch sectionIndex {
            case MyNoteContentView.favoriteArtistsSectionIndex:
                return MyNoteContentView.createFavoriteArtistsSection()

            case MyNoteContentView.relatedNoteSectionIndex:
                return MyNoteContentView.createRelatedNoteSection()

            default:
                return nil
            }
        }

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
        )

        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: RequiredLoginNoteCell.self)
        collectionView.register(cellType: EmptyMyNoteCell.self)
        collectionView.register(cellType: NoteCell.self)
        collectionView.register(cellType: ArtistNameCollectionViewCell.self)

        return collectionView
    }()

    // MARK: - init

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpDefaults()
        setUpLayouts()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        noteDetailCollectionView.pin.all(pin.safeArea)
        noteDetailCollectionView.flex.layout()
    }

    private func setUpDefaults() {
        backgroundColor = Colors.background
    }

    private func setUpLayouts() {
        addSubview(noteDetailCollectionView)
        noteDetailCollectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension MyNoteContentView {
    static func createFavoriteArtistsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(54),
            heightDimension: .absolute(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(54),
            heightDimension: .absolute(32)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = .init(
            top: 0,
            leading: 20,
            bottom: 0,
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

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
