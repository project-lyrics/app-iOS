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
    func addLeftBarView(_ contentViews: [UIView]) {
        let count = contentViews.count > rightBarView.subviews.count ? contentViews.count : rightBarView.subviews.count

        leftBarView.flex
            .direction(.row)
            .shrink(1)
            .define { flex in
                contentViews.enumerated().forEach { index, contentView in
                    flex.addItem(contentView)
                        .marginRight(index < contentViews.count - 1 ? 20 : 0) // 마지막 아이템 오른쪽에는 마진 없음
                }
            }
        leftBarView.flex.width(CGFloat(count == 1 ? 44 : 68)) // 한 개일 때 44, 두 개일 때 96
        rootFlexContainer.flex.layout()
    }

    func addTitleView(_ contentView: UIView) {
        titleView.flex
            .grow(1)
            .define { flex in
                flex.addItem(contentView)
            }

        contentView.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
    
    func addRightBarView(_ contentViews: [UIView]) {
        let count = contentViews.count > leftBarView.subviews.count ? contentViews.count : leftBarView.subviews.count

        rightBarView.flex
            .direction(.row)
            .shrink(1)
            .define { flex in
                contentViews.enumerated().forEach { index, contentView in
                    flex.addItem(contentView)
                        .marginRight(index < contentViews.count - 1 ? 20 : 0) // 마지막 아이템 오른쪽에는 마진 없음
                }
            }
        rightBarView.flex.width(CGFloat(count == 1 ? 44 : 68))
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
                    .width(44)
                    .height(100%)
                    .margin(
                        UIEdgeInsets(
                            top: 10,
                            left: 0,
                            bottom: 10,
                            right: 0
                        )
                    )
                    .markDirty()

                flex.addItem(titleView)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .grow(1)
                    .shrink(1)
                    .margin(
                        UIEdgeInsets(
                            top: 10,
                            left: 0,
                            bottom: 10,
                            right: 0
                        )
                    )
                    .markDirty()

                flex.addItem(rightBarView)
                    .justifyContent(.center)
                    .alignItems(.center)
                    .width(44)
                    .height(100%)
                    .margin(
                        UIEdgeInsets(
                            top: 10,
                            left: 0,
                            bottom: 10,
                            right: 0
                        )
                    )
                    .markDirty()
            }
    }
}

// MARK: - Change Navigation Bar Display

public extension NavigationBar {
    func hideRightBarView(_ mustHide: Bool) {
        rightBarView.isHidden = mustHide
        rightBarView.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
    
    func hideTitleView(_ mustHide: Bool) {
        titleView.isHidden = mustHide
        titleView.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
    
    func hideLeftView(_ mustHide: Bool) {
        leftBarView.isHidden = mustHide
        leftBarView.flex.markDirty()
        rootFlexContainer.flex.layout()
    }
    
    func changeBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
        rootFlexContainer.flex.layout()
    }
}
