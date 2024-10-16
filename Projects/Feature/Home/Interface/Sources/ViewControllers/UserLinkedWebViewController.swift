//
//  UserLinkedWebViewController.swift
//  FeatureHomeInterface
//
//  Created by 황인우 on 10/13/24.
//

import Combine
import UIKit
import WebKit

import Domain
import Shared

public protocol UserLinkedWebViewControllerDelegate: AnyObject {
    func dismissViewController()
}

public final class UserLinkedWebViewController: UIViewController {
    public weak var coordinator: UserLinkedWebViewControllerDelegate?
    
    // MARK: - Properties
    
    private let url: URL
    private var cancellables: Set<AnyCancellable> = .init()
    private var onCopyURL: PassthroughSubject<URL, Never> = .init()
    private var onOpenURL: PassthroughSubject<URL, Never> = .init()
    
    private lazy var fileShareModel = FileShareModel(
        url: self.url,
        title: url.lastPathComponent
    )
    
    // MARK: - UI
    
    private let userLinkedWebView: UserLinkedWebView
    
    // MARK: - Init
    
    public init(url: URL) {
        self.url = url
        self.userLinkedWebView = UserLinkedWebView(
            urlString: url.host ?? url.absoluteString
        )
        super.init(nibName: nil, bundle: .main)
        
        self.hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        self.view = userLinkedWebView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDelegate()
        self.loadUserLinkedWebPage()
        self.bindAction()
    }
    
    // MARK: - SetUp
    
    private func setUpDelegate() {
        self.webView.navigationDelegate = self
    }
    
    // MARK: - Binding
    
    private func bindAction() {
        self.reloadButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.webView.reload()
            }
            .store(in: &cancellables)
        
        self.closeButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.coordinator?.dismissViewController()
            }
            .store(in: &cancellables)
        
        self.bottomBackButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.webView.goBack()
            }
            .store(in: &cancellables)
        
        self.bottomForwardButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.webView.goForward()
            }
            .store(in: &cancellables)
        
        self.bottomShareButton.publisher(for: .touchUpInside)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.presentActivityViewController()
            }
            .store(in: &cancellables)
        
        self.bottomMoreAboutContentButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.presentUserLinkedMenuViewController()
            }
            .store(in: &cancellables)
        
        self.onCopyURL.eraseToAnyPublisher()
            .sink { [weak self] url in
                guard let self = self else { return }
                self.showToast(
                    iconImage: FeelinImages.checkBoxActive,
                    message: "복사되었습니다",
                    bottomMargin: self.view.safeAreaInsets.bottom + self.userLinkedWebView.tabViewHeight + 5
                )
                UIPasteboard.general.string = url.absoluteString
            }
            .store(in: &cancellables)
        
        self.onOpenURL.eraseToAnyPublisher()
            .sink { url in
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - WebView Logic

extension UserLinkedWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        bottomBackButton.isEnabled = webView.canGoBack
        bottomForwardButton.isEnabled = webView.canGoForward
    }
}

private extension UserLinkedWebViewController {
    func loadUserLinkedWebPage() {
        self.webView.load(URLRequest(url: url))
    }
    
    func presentActivityViewController() {
        fileShareModel.fetchData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fileShareModel):
                    let activityViewController = UIActivityViewController(
                        activityItems: [fileShareModel],
                        applicationActivities: nil
                    )
                    activityViewController.popoverPresentationController?.sourceView = self?.view
                    
                    self?.present(activityViewController, animated: true)
                case .failure(let error):
                    break
                }
            }
        }
    }

}

// MARK: - UserLinkedMenu

private extension UserLinkedWebViewController {
    func presentUserLinkedMenuViewController() {
        let userLinkedMenuViewController = UserLinkedMenuViewController(
            linkURL: self.url,
            onCopyURL: self.onCopyURL,
            onOpenURL: self.onOpenURL
        )
        userLinkedMenuViewController.modalPresentationStyle = .overFullScreen
        
        self.present(userLinkedMenuViewController, animated: true)
    }
}

// MARK: - Subview

private extension UserLinkedWebViewController {
    var reloadButton: UIButton {
        return userLinkedWebView.reloadButton
    }
    
    var closeButton: UIButton {
        return userLinkedWebView.closeButton
    }
    
    var bottomBackButton: UIButton {
        return userLinkedWebView.bottomBackButton
    }
    
    var bottomForwardButton: UIButton {
        return userLinkedWebView.bottomForwardButton
    }
    
    var bottomShareButton: UIButton {
        return userLinkedWebView.bottomShareButton
    }
    
    var bottomMoreAboutContentButton: UIButton {
        return userLinkedWebView.bottomMoreAboutButton
    }
    
    var webView: WKWebView {
        return userLinkedWebView.webView
    }
}
