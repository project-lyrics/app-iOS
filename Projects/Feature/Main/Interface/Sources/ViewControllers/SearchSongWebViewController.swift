//
//  SearchSongWebViewController.swift
//  FeatureMain
//
//  Created by Derrick kim on 8/21/24.
//

import Combine
import UIKit

import Domain
import Shared

public final class SearchSongWebViewController: BottomSheetViewController<SearchSongWebView> {
    private var selectedBackgroundIndex: Int = 0
    public let lyricsBackgroundSelectionIndexPublisher = CurrentValueSubject<Int, Never>(0)

    private var cancellables = Set<AnyCancellable>()

    public override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    private func bind() {
        cancelButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
}

private extension SearchSongWebViewController {
    var cancelButton: UIButton {
        return bottomSheetView.cancelButton
    }
}
