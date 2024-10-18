//
//  SearchSongViewController.swift
//  FeatureHomeInterface
//
//  Created by Derrick kim on 8/25/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol SearchSongViewControllerDelegate: AnyObject {
    func didFinish(selectedItem: Song)
    func popRootViewController()
}

public final class SearchSongViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()

    private let searchSongView = SearchSongView()
    private let viewModel: SearchSongViewModel

    public weak var coordinator: SearchSongViewControllerDelegate?

    public init(viewModel: SearchSongViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        self.view = searchSongView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        bind()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.searchSongs()
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background

        songCollectionView.dataSource = self
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.coordinator?.popRootViewController()
            }
            .store(in: &cancellables)

        viewModel.$fetchedSongs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] songs in
                guard !songs.isEmpty else { return }

                self?.songCollectionView.reloadData()
                self?.searchSongView.rootFlexContainer.flex.layout()
            }
            .store(in: &cancellables)

        songCollectionView.publisher(for: [.didSelectItem, .didDeselectItem])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                coordinator?.didFinish(
                    selectedItem: viewModel.fetchedSongs[indexPath.row]
                )

                songSearchBar.resignFirstResponder()
            }
            .store(in: &cancellables)

        songCollectionView.didScrollToBottomPublisher()
            .sink { [unowned self] _ in
                let currentKeyword = self.songSearchBar.searchTextField.text ?? ""
                self.viewModel.fetchMoreSongs(keyword: currentKeyword)
            }
            .store(in: &cancellables)

        songSearchBar.searchTextField.textPublisher
            .dropFirst()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak viewModel] searchText in
                viewModel?.searchSongs(keyword: searchText)
            }
            .store(in: &cancellables)

        songSearchBar.searchTextField.editEndPublisher
            .dropFirst()
            .compactMap { $0 }
            .filter { $0.isEmpty }
            .sink { [weak viewModel] searchText in
                viewModel?.searchSongs()
            }
            .store(in: &cancellables)

        songSearchBar.clearButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak viewModel] _ in
                viewModel?.searchSongs()
            }
            .store(in: &cancellables)

        CombineKeyboard.keyboardHeightPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] height in
                self?.updateOnKeyboardHeightChange(height)
            }
            .store(in: &cancellables)
    }

    private func updateOnKeyboardHeightChange(_ height: CGFloat) {
        searchSongView.rootFlexContainer.flex
            .paddingBottom(height)

        searchSongView.rootFlexContainer.flex.layout()
    }
}

extension SearchSongViewController {
    var songCollectionView: UICollectionView {
        return searchSongView.collectionView
    }

    var backButton: UIButton {
        return searchSongView.backButton
    }

    var songSearchBar: FeelinSearchBar {
        return searchSongView.searchBarView
    }
}

extension SearchSongViewController: UICollectionViewDataSource {

    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.fetchedSongs.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: SongCollectionViewCell.self)
        cell.configure(model: viewModel.fetchedSongs[indexPath.row])

        return cell
    }
}
