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
        addUIComponents()
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
    func addTitleView(_ contentView: UIView) {
        titleView.flex.define { flex in
            flex.addItem(contentView).grow(1).shrink(1).marginHorizontal(5)
        }
        titleView.flex.layout()
    }

    func addLeftBarView(_ contentView: UIView) {
        leftBarView.flex.define { flex in
            flex.addItem(contentView).width(40).height(40)
        }
        leftBarView.flex.layout()
    }

    func addRightBarView(_ contentView: UIView) {
        rightBarView.flex.define { flex in
            flex.addItem(contentView).width(60).height(40)
        }
        rightBarView.flex.layout()
    }
}

private extension NavigationBar {
    func setupDefault() {
        rootFlexContainer.flex.direction(.row).alignItems(.center)
        leftBarView.flex.width(40).height(40)
        titleView.flex.grow(1).alignItems(.center).justifyContent(.center)
        rightBarView.flex.width(60).height(40)
    }

    func addUIComponents() {
        addSubview(rootFlexContainer)
        rootFlexContainer.flex.define { flex in
            flex.addItem(leftBarView)
            flex.addItem(titleView).grow(1).shrink(1)
            flex.addItem(rightBarView)
        }
    }
}
