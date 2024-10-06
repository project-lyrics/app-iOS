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

public class SearchMoreFavoriteArtistViewController: UIViewController {
    private let viewModel: SearchMoreFavoriteArtistViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Diffable DataSource
    
    private typealias ArtistListDataSource = UICollectionViewDiffableDataSource<ArtistListSection, Artist>
    private typealias ArtistListSnapshot = NSDiffableDataSourceSnapshot<ArtistListSection, Artist>
    
    private enum ArtistListSection: CaseIterable {
        case main
    }
    
    private lazy var artistListDataSource: ArtistListDataSource = {
        let artistCellRegistration = UICollectionView.CellRegistration<FeelinArtistCell, Artist> { cell, indexPath, artist in
            
            cell.configure(
                artistName: artist.name,
                artistImageURL: try? artist.imageSource?.asURL()
            )
        }
        
        return ArtistListDataSource(
            collectionView: self.artistCollectionView,
            cellProvider: { collectionView, indexPath, artist -> FeelinArtistCell in
                return collectionView.dequeueConfiguredReusableCell(
                    using: artistCellRegistration,
                    for: indexPath,
                    item: artist
                )
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
        var snapshot = ArtistListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(artists, toSection: .main)
        artistListDataSource.applySnapshotUsingReloadData(snapshot)
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
                self?.showAlert(
                    title: error.localizedDescription,
                    message: nil,
                    singleActionTitle: "확인"
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
            .sink { _ in
                // TODO: - dismiss viewController
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchMoreFavoriteArtistViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 키보드가 올라와 있다면 일단 resign
        self.artistSearchBar.searchTextField.resignFirstResponder()
        // TODO: - Navigation to CommunityMainPageVC
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
