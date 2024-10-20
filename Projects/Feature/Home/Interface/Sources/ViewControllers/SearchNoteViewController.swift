//
//  SearchNoteViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 9/3/24.
//

import Combine
import UIKit

import Domain
import Shared

public protocol SearchNoteViewControllerDelegate: AnyObject {
    func pushNoteDetailViewController(selectedNote: SearchedNote)
}

public final class SearchNoteViewController: UIViewController {
    public weak var coordinator: SearchNoteViewControllerDelegate?

    private var viewModel: SearchNoteViewModel

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
    
    private func setUpDelegates() {
        self.searchNoteTableView.delegate = self
    }

    private func updateSearchNoteTableView(with searchedNotes: [SearchedNote]) {
        var snapshot = noteListDataSource.snapshot()
        
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])
        }
        let currentItem = snapshot.itemIdentifiers(inSection: .main)
        
        snapshot.deleteItems(currentItem)
        snapshot.appendItems(searchedNotes, toSection: .main)
        
        noteListDataSource.apply(snapshot, animatingDifferences: false)
    }

    private func fetchInitialSearchedNotes() {
        self.viewModel.searchNotes(isInitialFetch: true)
    }
}

// MARK: - Bindings

private extension SearchNoteViewController {
    func bindUI() {
        CombineKeyboard.keyboardHeightPublisher
            .sink { [unowned self] height in
                UIView.animate(withDuration: 0) {
                    if !height.isZero {
                        self.searchNoteTableView.contentInset = .init(
                            top: 0,
                            left: 0,
                            bottom: height - self.view.safeAreaInsets.bottom,
                            right: 0
                        )
                    } else {
                        self.searchNoteTableView.contentInset = .zero
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showAlert(
                    title: error.errorMessageWithCode,
                    message: nil,
                    singleActionTitle: "확인"
                )
            }
            .store(in: &cancellables)

        viewModel.$searchedNotes
            .sink { [unowned self] searchedNotes in
                self.updateSearchNoteTableView(with: searchedNotes)
            }
            .store(in: &cancellables)
        
        viewModel.$refreshState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] refreshState in
                switch refreshState {
                case .failed(let error):
                    self?.showAlert(
                        title: error.errorMessageWithCode,
                        message: nil,
                        singleActionTitle: "확인"
                    )

                case .completed:
                    self?.searchNoteTableView.refreshControl?.endRefreshing()

                default:
                    return
                }
            })
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
        
        self.searchNoteTableView.refreshControl?.isRefreshingPublisher
            .filter { $0 }
            .sink(receiveValue: { [unowned self] _ in
                let currentKeyword = self.noteSearchBar.searchTextField.text
                self.viewModel.searchNotes(
                    isInitialFetch: true,
                    searchText: currentKeyword ?? ""
                )
            })
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

// MARK: - UITableViewDelegate

extension SearchNoteViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.noteListDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.coordinator?.pushNoteDetailViewController(selectedNote: item)
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
