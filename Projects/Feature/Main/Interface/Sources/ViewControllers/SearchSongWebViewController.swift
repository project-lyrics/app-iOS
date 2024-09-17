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

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindCancelButton()
        loadSongWebPage()
    }

    // MARK: - Private Methods

    private func bindCancelButton() {
        cancelButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }

    private func loadSongWebPage() {
        guard let urlRequest = createURLRequest() else { return }
        webView.load(urlRequest)
    }

    private func createURLRequest() -> URLRequest? {
        guard let url = URL(string: "https://search.melon.com/search/mcom_index.htm") else { return nil }
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
