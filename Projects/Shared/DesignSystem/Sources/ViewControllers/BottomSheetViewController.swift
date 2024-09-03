//
//  BottomSheetViewController.swift
//  SharedDesignSystem
//
//  Created by jiyeon on 6/14/24.
//

import UIKit

open class BottomSheetViewController<View: UIView>: UIViewController {
    private var bottomSheetViewBottomConstraint: NSLayoutConstraint?
    private let bottomSheetHeight: CGFloat
    private let animationDuration = 0.3
    
    // MARK: - components
    
    private let dimmedView = {
        let view = UIView()
        view.backgroundColor = Colors.dim
        view.alpha = 0.0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    public var bottomSheetView: View
    
    // MARK: - init
    
    public init(
        bottomSheetHeight: CGFloat,
        bottomSheetView: View? = nil
    ) {
        // 커스텀 이니셜라이저가 있는 뷰 같은 경우 외부에서 주입하기 위한 설정
        if let bottomSheetView = bottomSheetView {
            self.bottomSheetView = bottomSheetView
        } else {
            self.bottomSheetView = View()
        }
        self.bottomSheetHeight = bottomSheetHeight
        
        super.init(nibName: nil, bundle: nil)
        
        setUpBottomSheetView()
        setUpLayout()
        setUpGestureRecognizer()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheets()
    }
    
    private func showBottomSheets() {
        bottomSheetViewBottomConstraint?.constant = 0
        UIView.animate(withDuration: animationDuration, animations: {
            self.dimmedView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        bottomSheetViewBottomConstraint?.constant = bottomSheetHeight
        UIView.animate(withDuration: animationDuration, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    // MARK: - set up
    
    private func setUpBottomSheetView() {
        self.bottomSheetView.clipsToBounds = true
        self.bottomSheetView.layer.cornerRadius = 20
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setUpLayout() {
        view.addSubview(dimmedView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(bottomSheetView)
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewBottomConstraint = bottomSheetView.bottomAnchor.constraint(
            equalTo: dimmedView.bottomAnchor,
            constant: bottomSheetHeight
        )
        NSLayoutConstraint.activate([
            bottomSheetView.heightAnchor.constraint(equalToConstant: bottomSheetHeight),
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheetViewBottomConstraint!
        ])
    }
    
    private func setUpGestureRecognizer() {
        // TapGesture
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dimmedViewDidTap)
        )
        dimmedView.addGestureRecognizer(tapGesture)
        
        // SwipeGesture
        let swipeGesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(didSwipeDown)
        )
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func dimmedViewDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        dismiss(animated: false)
    }
    
    @objc private func didSwipeDown(_ swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .ended {
            switch swipeRecognizer.direction {
            case .down: dismiss(animated: false)
            default: break
            }
        }
    }
}
