//
//  NoteDetailView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/7/24.
//

import UIKit

import Shared

final class NoteDetailView: UIView {

    // MARK: - UI Components

    private let rootFlexContainer = UIView()
    private let navigationBar = NavigationBar()

    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "노트 검색"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

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
        
        collectionView.backgroundColor = Colors.background
        collectionView.showsVerticalScrollIndicator = false

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

        rootFlexContainer.pin.all(pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    private func setUpDefaults() {
        backgroundColor = Colors.background
    }

    private func setUpLayouts() {
        addSubview(rootFlexContainer)
        
        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(titleLabel)

        rootFlexContainer
            .flex
            .direction(.column)
            .define { flex in
                flex.addItem(navigationBar)
                    .height(44)
                    .marginHorizontal(10)

                flex.addItem(noteDetailCollectionView)
                    .grow(1)
            }
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
