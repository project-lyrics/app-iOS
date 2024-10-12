//
//  NoteCommentsView.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/14/24.
//

import FlexLayout
import Shared

import Combine
import UIKit

final class NoteCommentsView: UIView {
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: - UI Components

    private var flexContainer = UIView()
    
    private let navigationBar = NavigationBar()

    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(FeelinImages.back, for: .normal)

        return button
    }()

    private let naviTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "노트"
        label.font = SharedDesignSystemFontFamily.Pretendard.bold.font(size: 18)
        label.textColor = Colors.gray09

        return label
    }()

    private (set) var noteCommentsCollectionView: UICollectionView = {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case NoteCommentsView.noteSectionIndex:
                return NoteCommentsView.createNoteSection()
                
            case NoteCommentsView.commentsSectionIndex:
                return NoteCommentsView.createCommentsSection()
                
            default:
                return nil
            }
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
        )
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.backgroundColor = Colors.background
        
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    
    private (set) var writeCommentView = WriteCommentView()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = Colors.background
        self.setUpLayout()
        self.bindHeight()
        self.setupTapGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainer.pin
            .top(pin.safeArea)
            .left()
            .right()
            .bottom(pin.safeArea)
        
        flexContainer.flex.layout()
    }
    
    private func setUpLayout() {
        self.addSubview(flexContainer)
        self.backgroundColor = Colors.background

        navigationBar.addLeftBarView([backButton])
        navigationBar.addTitleView(naviTitleLabel)

        flexContainer.flex
            .define { flex in
                flex.addItem(navigationBar)
                    .marginHorizontal(10)
                    .height(44)

                flex.addItem(noteCommentsCollectionView)
                    .grow(1)

                flex.addItem()
                    .height(1)
                    .width(100%)
                    .backgroundColor(Colors.backgroundTertiary)

                flex.addItem(writeCommentView)
                    .width(100%)
                    .minHeight(80)
            }
    }
    
    // MARK: - Tap Gesture
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        self.writeCommentView.textView.resignFirstResponder()
    }
    
    // MARK: - Binding
    
    private func bindHeight() {
        CombineKeyboard.keyboardHeightPublisher
            .sink { [unowned self] keyboardHeight in
                UIView.animate(withDuration: 0.3) {
                    // 키보드 높이만큼 collectionview에 inset 부여
                    // safeAreaInset대응하여 위치 조정하는 로직 추가
                    self.noteCommentsCollectionView.contentInset = .init(
                        top: 0,
                        left: 0,
                        bottom: max(0, keyboardHeight - self.safeAreaInsets.bottom),
                        right: 0
                    )
                    // 키보드 높이 변경시 writeComment의 위치 조정
                    self.writeCommentView.flex.position(.relative).bottom(max(0, keyboardHeight - self.safeAreaInsets.bottom))
                    
                    
                    self.flexContainer.flex.layout(mode: .adjustHeight)
                }
            }
            .store(in: &cancellables)
        
        self.writeCommentView.didChangeHeightPublisher
            .sink { [unowned self] updatedHeight in
                
                // WriteCommentView의 높이가 바뀔 때 마다 flexContainer의 height를 재조정
                self.flexContainer.flex.markDirty()
                self.flexContainer.flex.layout(mode: .adjustHeight)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension NoteCommentsView {
    static let noteSectionIndex = 0
    static let commentsSectionIndex = 1
    
    static func createNoteSection() -> NSCollectionLayoutSection {
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
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        
        return section
    }
    
    static func createCommentsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(130)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(130)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(72)
        )
        let headerView = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: CommentHeaderView.reuseIdentifier,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerView]
        return section
    }
}
