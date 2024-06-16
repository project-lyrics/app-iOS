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
    
    // MARK: - components
    
    private let dimmedView = {
        let view = UIView()
        view.backgroundColor = Colors.dim
        view.alpha = 0.0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    public let bottomSheetView: View = {
        let view = View()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    // MARK: - init
    
    public init(bottomSheetHeight: CGFloat) {
        self.bottomSheetHeight = bottomSheetHeight
        
        super.init(nibName: nil, bundle: nil)
        
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
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        bottomSheetViewBottomConstraint?.constant = bottomSheetHeight
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            super.dismiss(animated: false, completion: completion)
        }
    }
    
    // MARK: - set up
    
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
            action: #selector(handleDimmedViewTap)
        )
        dimmedView.addGestureRecognizer(tapGesture)
        
        // SwipeGesture
        let swipeGesture = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleDownGesture)
        )
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleDimmedViewTap(_ tapRecognizer: UITapGestureRecognizer) {
        dismiss(animated: false)
    }
    
    @objc private func handleDownGesture(_ swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .ended {
            switch swipeRecognizer.direction {
            case .down: dismiss(animated: false)
            default: break
            }
        }
    }
}
