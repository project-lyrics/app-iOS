//
//  SearchSongWebViewController.swift
//  FeatureMain
//
//  Created by Derrick Kim on 8/21/24.
//

import Combine
import UIKit
import WebKit

import Domain
import Shared

public final class SearchSongWebViewController: BottomSheetViewController<SearchSongWebView> {

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    public let songPublisher = PassthroughSubject<Song?, Never>()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        bindCancelButton()
        bindModelPublisher()
    }

    private func bindCancelButton() {
        cancelButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }

    private func bindModelPublisher() {
        songPublisher
            .compactMap { $0 } // 모델 값이 nil이 아닌 경우에만 처리
            .sink { [weak self] song in
                self?.loadSongWebPage(for: song)
            }
            .store(in: &cancellables)
    }

    private func loadSongWebPage(for song: Song) {
        guard let urlRequest = createURLRequest(for: song) else { return }
        webView.load(urlRequest)
    }

    private func createURLRequest(for song: Song) -> URLRequest? {
        let query = "\(song.artist.name)+\(song.name)"
        guard let url = URL(string: "https://search.naver.com/search.naver?query=\(query)") else { return nil }
        return URLRequest(url: url)
    }
}

// MARK: - Computed Properties

private extension SearchSongWebViewController {
    var cancelButton: UIButton {
        return bottomSheetView.cancelButton
    }

    var webView: WKWebView {
        return bottomSheetView.webView
    }
}
