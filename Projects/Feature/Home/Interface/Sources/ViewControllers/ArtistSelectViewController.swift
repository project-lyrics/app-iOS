//
//  ArtistSelectViewController.swift
//  FeatureHome
//
//  Created by 황인우 on 6/19/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol ArtistSelectViewControllerDelegate: AnyObject {
    func didFinishSelectingInitialFavoriteArtists()
    func dismissViewController()
}

public final class ArtistSelectViewController: UIViewController {
    public weak var coordinator: ArtistSelectViewControllerDelegate?
    
    private let viewModel: ArtistSelectViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Keychain
    
    @KeychainWrapper<UserInformation>(.userInfo)
    public var userInfo
    
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
                artistImageURL: try? artist.imageSource?.asURL(),
                imageBorderWidth: 2,
                imageBorderInset: 5
            )
            artist.isFavorite ?
            cell.setArtistBorder(color: Colors.active) :
            cell.setArtistBorder(color: Colors.disabled)
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
    
    private var artistSelectView: ArtistSelectView = .init()
    
    // MARK: - Init
    
    public init(viewModel: ArtistSelectViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func loadView() {
        self.view = artistSelectView
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
        if !height.isZero {
            artistSelectView.flowLayout.sectionInset = .zero
        } else {
            // 키보드가 없는 화면에서 collectionView에 inset이 0일 경우 유저가 아티스트 목록을 끝까지 스크롤 할 때 마지막 cell들이 finishButton에 가려져서 이름 확인이 어렵다.
            // 따라서 키보드가 내려갈 경우 finishSelectButton의 높이만큼 collectionView와 section사이에 inset을 준다.
            artistSelectView.flowLayout.sectionInset = .init(
                top: 0,
                left: 0,
                bottom: artistSelectView.finishSelectButtonHeight,
                right: 0
            )
        }
        artistSelectView.rootFlexContainer.flex.paddingBottom(
            height
        )
        artistSelectView.rootFlexContainer.flex.layout()
    }
    
    private func fetchInitialArtists() {
        self.viewModel.fetchArtists(isInitialFetch: true)
    }
}

private extension ArtistSelectViewController {
    
    // MARK: - Bindings
    
    func bindUI() {
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showAlert(
                    title: error.errorMessage,
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
        
        viewModel.$favoriteArtists
            .map { $0.count >= 1 }
            .assign(to: \.isEnabled, on: finishSelectButton)
            .store(in: &cancellables)
        
        CombineKeyboard.keyboardHeightPublisher
            .sink { [unowned self] height in
                UIView.animate(withDuration: 0.5) {
                    self.updateOnKeyboardHeightChange(height)
                }
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
                viewModel?.searchArtists(keyword: searchText)
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
            .sink { [weak viewModel] _ in
                viewModel?.fetchArtists(isInitialFetch: true)
            }
            .store(in: &cancellables)
        
        self.finishSelectButton.publisher(for: .touchUpInside)
            .flatMap { [weak viewModel] _ -> AnyPublisher<ArtistSelectViewModel.InformFavoriteArtistsResult, Never> in
                guard let viewModel = viewModel else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return viewModel.confirmFavoriteArtistsPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.coordinator?.didFinishSelectingInitialFavoriteArtists()
                    self?.coordinator?.dismissViewController()
                    
                case .failure(let error):
                    self?.showAlert(
                        title: error.errorMessage,
                        message: nil,
                        singleActionTitle: "확인"
                    )
                }
            })
            .store(in: &cancellables)
        
        self.closeButton.publisher(for: .touchUpInside)
            .sink { [unowned self] _ in
                self.showAlert(
                    title: "선택한 정보를 저장하지 않고\n 나가시겠어요?",
                    message: nil,
                    leftActionTitle: "취소",
                    rightActionTitle: "나가기",
                    rightActionCompletion: {
                        self.coordinator?.dismissViewController()
                    }
                )
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate

extension ArtistSelectViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let isSearching = self.artistSearchBar.searchTextField.text?.isNotEmpty ?? false
        self.viewModel.markFavoriteArtist(
            at: indexPath.item,
            isSearching: isSearching
        )
    }
}

// MARK: - ArtistSelectView Subviews

private extension ArtistSelectViewController {
    var artistCollectionView: UICollectionView {
        return self.artistSelectView.artistCollectionView
    }
    
    var closeButton: UIButton {
        return self.artistSelectView.closeButton
    }
    
    var artistSearchBar: FeelinSearchBar {
        return self.artistSelectView.artistSearchBar
    }
    
    var finishSelectButton: FeelinConfirmButton {
        return self.artistSelectView.finishSelectButton
    }
}
