//
//  SearchSongViewController.swift
//  FeatureMainInterface
//
//  Created by Derrick kim on 8/25/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol SearchSongViewControllerDelegate: AnyObject {
    func didFinish(selectedItem: Song)
    func popViewController()
}

public final class SearchSongViewController: UIViewController {

    private var cancellables = Set<AnyCancellable>()

    private let searchSongView = SearchSongView()
    private let viewModel: SearchSongViewModel

    public weak var coordinator: SearchSongViewControllerDelegate?

    public init(viewModel: SearchSongViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        songCollectionView.delegate = self
    }

    private func bind() {
        backButton.publisher(for: .touchUpInside)
            .sink { _ in
                self.coordinator?.popViewController()
            }
            .store(in: &cancellables)

        viewModel.$fetchedSongs
            .receive(on: DispatchQueue.main)
            .sink { songs in
                guard !songs.isEmpty else { return }
                
                self.songCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        songCollectionView.publisher(for: [.didSelectItem, .didDeselectItem])
            .sink { [weak self] indexPath in
                guard let self = self else { return }

                self.coordinator?.didFinish(selectedItem: viewModel.fetchedSongs[indexPath.row])
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

        self.songSearchBar.clearButton.publisher(for: .touchUpInside)
            .sink { [weak viewModel] _ in
                viewModel?.searchSongs()
            }
            .store(in: &cancellables)
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

extension SearchSongViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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
