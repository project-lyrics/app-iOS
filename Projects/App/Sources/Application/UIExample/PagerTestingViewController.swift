//
//  PagerTestingViewController.swift
//  Feelin-DEV
//
//  Created by 황인우 on 9/25/24.
//

import Shared

import UIKit

class PagerContainerViewController: UIViewController {
    private let flexContainer = UIView()
    
    let pagerTestinViewController = PagerTestingViewController()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        flexContainer.pin
            .top(self.view.pin.safeArea)
            .horizontally()
            .bottom()
        
        flexContainer.flex.layout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(flexContainer)
        
        flexContainer.flex.define { flex in
            
            flex.addItem()
                .height(150)
                .backgroundColor(.black)
            
            flex.addItem(pagerTestinViewController.view)
        }
    }
}

class PagerTestingViewController: ButtonBarPagerTabStripViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLoad() {
        
        // MARK: - Settings should be called before super.viewDidLoad is called.
        
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .blue
        settings.style.selectedBarBackgroundColor = .yellow
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: FeelinPagerTabViewController) -> [UIViewController] {
        return [TestingFirstTabVC(), TestingSecondTabVC(), TestingThirdTabVC()]
    }
}

class TestingFirstTabVC: UIViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("red")
        self.view.backgroundColor = .red
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("red appeared")
    }
    
    func indicatorInfo(for pagerTabStripController: FeelinPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "첫 번째")
    }
}


class TestingSecondTabVC: UIViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("blue")
        self.view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("blue appeared")
    }
    
    func indicatorInfo(for pagerTabStripController: FeelinPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "두 번째")
    }
}

class TestingThirdTabVC: UIViewController, IndicatorInfoProvider {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("green")
        self.view.backgroundColor = .green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("green appeared")
    }
    
    func indicatorInfo(for pagerTabStripController: FeelinPagerTabViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "세 번째")
    }
}

#if canImport(SwiftUI)
import SwiftUI

struct PagerTestingViewController_Preview: PreviewProvider {
    static var previews: some View {
        return PagerTestingViewController()
            .asPreview()
    }
}

#endif
