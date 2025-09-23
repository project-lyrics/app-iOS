//
//  DebuggerWindow.swift
//  Feelin
//
//  Created by 황인우 on 9/5/25.
//

//  DebuggerWindow.swift
//  Feelin
//
//  Created for Pulse Console Integration

import UIKit
import Combine
import SwiftUI
import Shared
import PulseUI

public final class DebuggerWindow: UIWindow {
    private enum Metric {
        static let padding: CGFloat = 12.0
        static let buttonSize: CGFloat = 50.0
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var toggleButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        config.image = UIImage(systemName: "wrench.and.screwdriver.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        let button = UIButton(configuration: config)
        button.alpha = 0.3
        
        return button
    }()
    
    private let _rootViewController: UIViewController = InvisibleViewController()
    
    private let navigationController: UINavigationController
    
    private var isMoving = false {
        didSet {
            updateToggleButtonAlpha()
        }
    }
    
    private var isSlightlyVisible: Bool = true {
        didSet {
            
        }
    }
    
    private var dragOffset: CGPoint = .zero
    
    override public init(windowScene: UIWindowScene) {
        
        UserDefaults.standard.set(true, forKey: "pulse-disable-support-prompts")
        UserDefaults.standard.set(true, forKey: "pulse-disable-report-issue-prompts")
        
        navigationController = UINavigationController(rootViewController: _rootViewController)
        navigationController.navigationBar.tintColor = .black
        
        super.init(windowScene: windowScene)
        
        self.rootViewController = navigationController
        backgroundColor = .clear
        
        setupUI()
        setupGestures()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(toggleButton)
        
        toggleButton.bounds = CGRect(
            x: 0,
            y: 0,
            width: Metric.buttonSize,
            height: Metric.buttonSize
        )
        
        let centerX = bounds.width - safeAreaInsets.right - Metric.padding - Metric.buttonSize / 2
        let centerY = safeAreaInsets.top + Metric.padding + Metric.buttonSize / 2
        
        toggleButton.center = CGPoint(x: centerX, y: centerY)
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer()
        toggleButton.addGestureRecognizer(panGesture)
        
        panGesture.publisher
            .sink { [weak self] gesture in
                self?.handlePanGesture(gesture)
            }
            .store(in: &cancellables)
        
        let tapGesture = UITapGestureRecognizer()
        toggleButton.addGestureRecognizer(tapGesture)
        
        tapGesture.publisher
            .sink { [weak self] _ in
                self?.showPulseConsole()
            }
            .store(in: &cancellables)
    }
    
    private func handlePanGesture(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            isMoving = true
            
            let gestureLocation = gesture.location(in: self)
            let buttonCenter = toggleButton.center
            dragOffset = CGPoint(
                x: buttonCenter.x - gestureLocation.x,
                y: buttonCenter.y - gestureLocation.y
            )
            
        case .changed:
            let location = gesture.location(in: self)
            updatePosition(location: location)
            
        case .ended, .cancelled, .failed:
            handlePanGestureEnded()
            
        default:
            break
        }
    }
    
    private func updatePosition(location: CGPoint) {
        var centerX = location.x + dragOffset.x
        var centerY = location.y + dragOffset.y
        
        let buttonHalfWidth = toggleButton.bounds.width / 2
        let buttonHalfHeight = toggleButton.bounds.height / 2
        
        let minX = safeAreaInsets.left + Metric.padding + buttonHalfWidth
        let maxX = bounds.width - safeAreaInsets.right - Metric.padding - buttonHalfWidth
        let minY = safeAreaInsets.top + Metric.padding + buttonHalfHeight
        let maxY = bounds.height - safeAreaInsets.bottom - Metric.padding - buttonHalfHeight
        
        centerX = min(maxX, max(minX, centerX))
        centerY = min(maxY, max(minY, centerY))
        
        toggleButton.center = CGPoint(x: centerX, y: centerY)
    }
    
    private func handlePanGestureEnded() {
        let isLeftSide = toggleButton.center.x < (bounds.width / 2)
        
        let buttonHalfWidth = toggleButton.bounds.width / 2
        let targetX: CGFloat
        
        if isLeftSide {
            // 왼쪽 가장자리로 스냅
            targetX = safeAreaInsets.left + Metric.padding + buttonHalfWidth
        } else {
            // 오른쪽 가장자리로 스냅
            targetX = bounds.width - safeAreaInsets.right - Metric.padding - buttonHalfWidth
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0
        ) {
            self.toggleButton.center.x = targetX
            // y 좌표는 현재 위치 유지
        } completion: { _ in
            self.isMoving = false
        }
    }
    
    private func updateToggleButtonAlpha() {
        let alpha: CGFloat = isMoving ? 0.8 : 0.3
        UIView.animate(withDuration: 0.2) {
            self.toggleButton.alpha = alpha
        }
    }
    
    private func showPulseConsole() {
        let consoleView = NavigationView {
            ConsoleView()
        }
        
        let hostingController = UIHostingController(rootView: consoleView)
        hostingController.modalPresentationStyle = .fullScreen
        
        navigationController.present(hostingController, animated: true)
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 오직 toggleButton만 터치 가능하도록 제한
        guard navigationController.viewControllers.count == 1 &&
              navigationController.presentedViewController == nil else {
            return super.hitTest(point, with: event)
        }
        
        if let view = hitTest(on: toggleButton, point: point, with: event) {
            return view
        }
        return nil
    }
    
    private func hitTest(on view: UIView, point: CGPoint, with event: UIEvent?) -> UIView? {
        view.hitTest(view.convert(point, from: self), with: event)
    }
}

// MARK: - InvisibleViewController

final class InvisibleViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
