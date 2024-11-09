//
//  SearchMoreFavoriteArtistViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/5/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol SearchMoreFavoriteArtistDelegate: AnyObject {
    func dismissViewController()
    func pushCommunityMainViewController(artistID: Int)
    func handleError(
        errorCode: String?,
        errorMessage: String,
        errorData: AnyType?
    )
}

public class SearchMoreFavoriteArtistViewController: UIViewController {
    
    public weak var coordinator: SearchMoreFavoriteArtistDelegate?
    
    private let viewModel: SearchMoreFavoriteArtistViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Diffable DataSource
    
    private typealias ArtistListDataSource = UICollectionViewDiffableDataSource<ArtistListSection, ArtistListRow>
    
    private enum ArtistListSection: CaseIterable {
        case main
    }
    
    private enum ArtistListRow: Hashable {
        case emptyArtist
        case artist(Artist)
    }
    
    private lazy var artistListDataSource: ArtistListDataSource = {
        let emptyArtistCellRegistration = UICollectionView.CellRegistration<EmptyArtistCell, Void> { cell, indexPath, _ in
            
            cell.requestArtistButton.publisher(for: .touchUpInside)
                .sink { _ in
                    guard let url = URL(string: "https://forms.gle/nvxuLVfr1WuvFqrq8") else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                .store(in: &cell.cancellables)
        }
        
        let artistCellRegistration = UICollectionView.CellRegistration<FeelinArtistCell, Artist> { cell, indexPath, artist in
            
            cell.configure(
                artistName: artist.name,
                artistImageURL: try? artist.imageSource?.asURL()
            )
        }
        
        return ArtistListDataSource(
            collectionView: self.artistCollectionView,
            cellProvider: { collectionView, indexPath, row in
                switch row {
                case .artist(let artist):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: artistCellRegistration,
                        for: indexPath,
                        item: artist
                    )
                case .emptyArtist:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: emptyArtistCellRegistration,
                        for: indexPath,
                        item: ()
                    )
                }
            })
    }()
    
    // MARK: - View
    
    private var searchMoreFavoriteArtistView: SearchMoreFavoriteArtistView = .init()
    
    // MARK: - Init
    
    public init(viewModel: SearchMoreFavoriteArtistViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    public override func loadView() {
        self.view = searchMoreFavoriteArtistView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assignDelegates()
        self.bindUI()
        self.bindAction()
        self.fetchInitialArtists()
    }
    
    private func assignDelegates() {
        self.artistCollectionView.delegate = self
    }
    
    private func updateArtistCollectionView(with artists: [Artist]) {
        var snapshot = artistListDataSource.snapshot()
        
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])
        }
        let newItems = artists.map { ArtistListRow.artist($0) }
        let currentItems = snapshot.itemIdentifiers(inSection: .main)
        
        if newItems.isEmpty {
            snapshot.deleteItems(currentItems)
            snapshot.appendItems([.emptyArtist])
        } else {
            snapshot.deleteItems(currentItems)
            snapshot.appendItems(newItems, toSection: .main)
        }
        
        artistListDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateOnKeyboardHeightChange(_ height: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            if !height.isZero {
                self.artistCollectionView.contentInset.bottom = height
            } else {
                self.artistCollectionView.contentInset.bottom = self.view.safeAreaInsets.bottom
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func fetchInitialArtists() {
        self.viewModel.fetchArtists(isInitialFetch: true)
    }
}

// MARK: - Bindings

private extension SearchMoreFavoriteArtistViewController {
    func bindUI() {
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.coordinator?.handleError(
                    errorCode: error.errorCode,
                    errorMessage: error.userMessage,
                    errorData: error.data
                )
            }
            .store(in: &cancellables)
        
        viewModel.$fetchedArtists
            .sink { [weak self] fetchedArtists in
                self?.updateArtistCollectionView(with: fetchedArtists)
            }
            .store(in: &cancellables)
        
        CombineKeyboard.keyboardHeightPublisher
            .sink { [unowned self] height in
                self.updateOnKeyboardHeightChange(height)
            }
            .store(in: &cancellables)
    }
    
    func bindAction() {
        self.artistCollectionView.didScrollToBottomPublisher()
            .sink { [unowned self] _ in
                let currentKeyword = self.artistSearchBar.searchTextField.text
                self.viewModel.fetchMoreArtists(keyword: currentKeyword ?? "")
            }
            .store(in: &cancellables)
        
        self.artistSearchBar.searchTextField.textPublisher
            .dropFirst()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .compactMap { $0 }
            .sink(receiveValue: { [weak viewModel] searchText in
                viewModel?.searchArtists(
                    isInitial: true,
                    keyword: searchText
                )
            })
            .store(in: &cancellables)
        
        self.artistSearchBar.searchTextField.editEndPublisher
            .dropFirst()
            .compactMap { $0 }
            .filter { $0.isEmpty }
            .sink { [weak viewModel] searchText in
                viewModel?.fetchArtists(isInitialFetch: true)
            }
            .store(in: &cancellables)
        
        self.artistSearchBar.clearButton.publisher(for: .touchUpInside)
            .sink { [weak viewModel]  _ in
                viewModel?.fetchArtists(isInitialFetch: true)
            }
            .store(in: &cancellables)
        
        self.closeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.dismissViewController()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchMoreFavoriteArtistViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = artistListDataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }
        
        switch item {
        case .artist:
            let totalHorizontalSpacing = searchMoreFavoriteArtistView.flowLayout.minimumInteritemSpacing * 2 + 27 * 2
            let cellWidth: CGFloat = (self.view.frame.width - totalHorizontalSpacing) / 3
            let cellHeight: CGFloat = 146
            
            return CGSize(
                width: cellWidth,
                height: cellHeight
            )
            
        case .emptyArtist:
            return CGSize(
                width: collectionView.frame.width,
                height: collectionView.frame.height
            )
        }
    }
}


// MARK: - UICollectionViewDelegate

extension SearchMoreFavoriteArtistViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 키보드가 올라와 있다면 일단 resign
        self.artistSearchBar.searchTextField.resignFirstResponder()
        
        if let selectedArtist = self.viewModel.fetchedArtists[safe: indexPath.item] {
            self.coordinator?.dismissViewController()
            self.coordinator?.pushCommunityMainViewController(artistID: selectedArtist.id)
            
        }
    }
}

private extension SearchMoreFavoriteArtistViewController {
    var artistCollectionView: UICollectionView {
        return self.searchMoreFavoriteArtistView.artistCollectionView
    }
    
    var closeButton: UIButton {
        return self.searchMoreFavoriteArtistView.closeButton
    }
    
    var artistSearchBar: FeelinSearchBar {
        return self.searchMoreFavoriteArtistView.artistSearchBar
    }
}
