import UIKit
import FlexLayout

public final class NavigationBar: UIView {
    private let rootFlexContainer = UIView()
    private let leftBarView = UIView()
    private let titleView = UIView()
    private let rightBarView = UIView()
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = Colors.background
        setupDefault()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
    }
}

public extension NavigationBar {
    func addLeftBarView(_ contentView: UIView) {
        leftBarView.flex
            .define { flex in
                flex.addItem(contentView)
            }
        rootFlexContainer.flex.layout()
    }
    
    func addTitleView(_ contentView: UIView) {
        titleView.flex
            .grow(1)
            .define { flex in
                flex.addItem(contentView)
            }
        rootFlexContainer.flex.layout()
    }
    
    func addRightBarView(_ contentView: UIView) {
        rightBarView.flex
            .define { flex in
                flex.addItem(contentView)
            }
        rootFlexContainer.flex.layout()
    }
}

private extension NavigationBar {
    func setupDefault() {
        addSubview(rootFlexContainer)
        
        rootFlexContainer.flex
            .direction(.row)
            .alignItems(.center)
            .define { flex in
                flex.addItem(leftBarView)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .size(24)
                    .margin(
                        UIEdgeInsets(
                            top: 10,
                            left: 0,
                            bottom: 10,
                            right: 8
                        )
                    )
                
                flex.addItem(titleView)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .grow(1)
                    .shrink(1)
                    .margin(
                        UIEdgeInsets(
                            top: 10,
                            left: 16,
                            bottom: 10,
                            right: 16
                        )
                    )
                
                flex.addItem(rightBarView)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .size(44)
                    .margin(
                        UIEdgeInsets(
                            top: 5,
                            left: 0,
                            bottom: 5,
                            right: 0
                        )
                    )
            }
    }
}

// MARK: - Change Navigation Bar Display

public extension NavigationBar {
    func hideRightBarView(_ mustHide: Bool) {
        rightBarView.isHidden = mustHide
        rootFlexContainer.flex.layout()
    }
    
    func hideTitleView(_ mustHide: Bool) {
        titleView.isHidden = mustHide
        rootFlexContainer.flex.layout()
    }
    
    func hideLeftView(_ mustHide: Bool) {
        leftBarView.isHidden = mustHide
        rootFlexContainer.flex.layout()
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
        rootFlexContainer.flex.layout()
    }
}
