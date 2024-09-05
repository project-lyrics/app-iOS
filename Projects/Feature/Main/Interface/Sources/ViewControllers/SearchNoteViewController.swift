//
//  SearchNoteViewController.swift
//  FeatureMainInterface
//
//  Created by 황인우 on 9/3/24.
//

import Combine
import UIKit

import Domain
import Shared

public final class SearchNoteViewController: UIViewController {
    var viewModel: SearchNoteViewModel
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Diffable DataSource
    
    private typealias NoteListDataSource = UITableViewDiffableDataSource<NoteListSection, SearchedNote>
    private typealias NoteListSnapshot = NSDiffableDataSourceSnapshot<NoteListSection, SearchedNote>
    
    private enum NoteListSection: CaseIterable {
        case main
    }
    
    private lazy var noteListDataSource: NoteListDataSource = {
        return NoteListDataSource(
            tableView: self.searchNoteTableView,
            cellProvider: { tableView, indexPath, searchedNote -> SearchNoteCell in
                let cell: SearchNoteCell = tableView.dequeueReusableCell(for: indexPath)
                
                cell.configure(
                    songName: searchedNote.songName,
                    artistName: searchedNote.artistName,
                    noteCount: searchedNote.noteCount,
                    albumImageURL: try? searchedNote.albumImageUrl.asURL()
                )
                
                return cell
            })
    }()
    
    let searchNoteView: SearchNoteView = .init()
    
    // MARK: - init
    
    public init(viewModel: SearchNoteViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle
    
    override public func loadView() {
        self.view = searchNoteView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDelegates()
        self.bindUI()
        self.bindAction()
        self.fetchInitialSearchedNotes()
    }
    
    private func updateSearchNoteCollectionView(with searchedNotes: [SearchedNote]) {
        var snapshot = NoteListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(searchedNotes, toSection: .main)
        noteListDataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    private func fetchInitialSearchedNotes() {
        self.viewModel.searchNotes(isInitialFetch: true)
    }
    
    private func setUpDelegates() {
        searchNoteTableView.delegate = self
    }
}

// MARK: - SearchNoteTableViewDelegate

extension SearchNoteViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: - Bindings

private extension SearchNoteViewController {
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
        
        viewModel.$searchedNotes
            .sink { [unowned self] searchedNotes in
                self.updateSearchNoteCollectionView(with: searchedNotes)
            }
            .store(in: &cancellables)
    }
    
    func bindAction() {
        self.searchNoteTableView.didScrollToBottomPublisher()
            .sink { [unowned self] _ in
                let currentKeyword = self.noteSearchBar.searchTextField.text
                
                self.viewModel.searchNotes(
                    isInitialFetch: false,
                    searchText: currentKeyword ?? ""
                )
            }
            .store(in: &cancellables)
        
        self.noteSearchBar.searchTextField.textPublisher
            .dropFirst()
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [ weak viewModel] searchingText in
                viewModel?.searchNotes(
                    isInitialFetch: true,
                    searchText: searchingText
                )
            }
            .store(in: &cancellables)
        
        self.noteSearchBar.searchTextField.editEndPublisher
            .dropFirst()
            .compactMap { $0 }
            .filter { $0.isEmpty }
            .sink { [weak viewModel] searchingText in
                viewModel?.searchNotes(
                    isInitialFetch: true,
                    searchText: searchingText
                )
            }
            .store(in: &cancellables)
        
        self.noteSearchBar.clearButton.publisher(for: .touchUpInside)
            .sink { [weak viewModel] _ in
                viewModel?.searchNotes(isInitialFetch: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - SearchNoteView

private extension SearchNoteViewController {
    var searchNoteTableView: UITableView {
        return self.searchNoteView.searchNoteTableView
    }
    
    var noteSearchBar: FeelinSearchBar {
        return self.searchNoteView.noteSearchBar
    }
}
