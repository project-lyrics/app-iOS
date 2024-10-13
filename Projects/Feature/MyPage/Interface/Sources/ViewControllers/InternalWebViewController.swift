//
//  InternalWebViewController.swift
//  FeatureMyPageInterface
//
//  Created by Derrick kim on 10/12/24.
//

import UIKit
import WebKit
import Combine

import Shared

public protocol InternalWebViewControllerDelegate: AnyObject {
    func dismissViewController()
}

public final class InternalWebViewController: UIViewController {

    public weak var coordinator: InternalWebViewControllerDelegate?

    private let internalWebView = InternalWebView()
    private let url: String
    private var cancellables = Set<AnyCancellable>()

    public init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    public override func loadView() {
        view = internalWebView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpDefault()
        bindAction()
        loadWebView()
    }

    private func setUpDefault() {
        view.backgroundColor = Colors.background
    }

    private func bindAction() {
        cancelButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.dismissViewController()
            }
            .store(in: &cancellables)

        refreshButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.webView.reload()
            }
            .store(in: &cancellables)
    }

    private func loadWebView() {
        guard let url = URL(string: url) else {
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
}

private extension InternalWebViewController {
    var cancelButton: UIButton {
        return internalWebView.cancelButton
    }

    var refreshButton: UIButton {
        return internalWebView.refreshButton
    }

    var webView: WKWebView {
        return internalWebView.webView
    }
}
