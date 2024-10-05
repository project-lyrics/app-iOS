//
//  ButtonBarView.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 9/22/24.
//

import UIKit

public enum PagerScroll {
    case no
    case yes
    case scrollOnlyIfOutOfScreen
}

public enum SelectedBarAlignment {
    case left
    case center
    case right
    case progressive
}

public enum SelectedBarVerticalAlignment {
    case top
    case middle
    case bottom
}

open class ButtonBarView: UICollectionView {

    open lazy var selectedBar: UIView = { [unowned self] in
        let bar  = UIView(frame: CGRect(x: 0, y: self.frame.size.height - CGFloat(self.selectedBarHeight), width: 0, height: CGFloat(self.selectedBarHeight)))
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.layer.zPosition = 9999
        return bar
    }()
    
    open lazy var defaultBar: UIView = { [unowned self] in
        let bar  = UIView(
            frame: CGRect(x: 0,
            y: self.frame.size.height - CGFloat(self.selectedBarHeight),
            width: self.frame.width,
            height: CGFloat(self.selectedBarHeight))
        )
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.layer.zPosition = 9999
        return bar
    }()

    internal var selectedBarHeight: CGFloat = 4 {
        didSet {
            updateSelectedBarYPosition()
        }
    }
    var selectedBarVerticalAlignment: SelectedBarVerticalAlignment = .bottom
    var selectedBarAlignment: SelectedBarAlignment = .center
    var selectedIndex = 0

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(defaultBar)
        addSubview(selectedBar)
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        addSubview(defaultBar)
        addSubview(selectedBar)
    }

    open func moveTo(index: Int, animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) {
        selectedIndex = index
        updateSelectedBarPosition(animated, swipeDirection: swipeDirection, pagerScroll: pagerScroll)
    }

    open func move(fromIndex: Int, toIndex: Int, progressPercentage: CGFloat, pagerScroll: PagerScroll) {
        selectedIndex = progressPercentage > 0.5 ? toIndex : fromIndex

        let fromFrame = layoutAttributesForItem(at: IndexPath(item: fromIndex, section: 0))!.frame
        let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)

        var toFrame: CGRect

        if toIndex < 0 || toIndex > numberOfItems - 1 {
            if toIndex < 0 {
                let cellAtts = layoutAttributesForItem(at: IndexPath(item: 0, section: 0))
                toFrame = cellAtts!.frame.offsetBy(dx: -cellAtts!.frame.size.width, dy: 0)
            } else {
                let cellAtts = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: 0))
                toFrame = cellAtts!.frame.offsetBy(dx: cellAtts!.frame.size.width, dy: 0)
            }
        } else {
            toFrame = layoutAttributesForItem(at: IndexPath(item: toIndex, section: 0))!.frame
        }

        var targetFrame = fromFrame
        targetFrame.size.height = selectedBar.frame.size.height
        targetFrame.size.width += (toFrame.size.width - fromFrame.size.width) * progressPercentage
        targetFrame.origin.x += (toFrame.origin.x - fromFrame.origin.x) * progressPercentage

        selectedBar.frame = CGRect(x: targetFrame.origin.x, y: selectedBar.frame.origin.y, width: targetFrame.size.width, height: selectedBar.frame.size.height)

        var targetContentOffset: CGFloat = 0.0
        if contentSize.width > frame.size.width {
            let toContentOffset = contentOffsetForCell(withFrame: toFrame, andIndex: toIndex)
            let fromContentOffset = contentOffsetForCell(withFrame: fromFrame, andIndex: fromIndex)

            targetContentOffset = fromContentOffset + ((toContentOffset - fromContentOffset) * progressPercentage)
        }

        setContentOffset(CGPoint(x: targetContentOffset, y: 0), animated: false)
    }

    open func updateSelectedBarPosition(_ animated: Bool, swipeDirection: SwipeDirection, pagerScroll: PagerScroll) {
        var selectedBarFrame = selectedBar.frame

        let selectedCellIndexPath = IndexPath(item: selectedIndex, section: 0)
        let attributes = layoutAttributesForItem(at: selectedCellIndexPath)
        let selectedCellFrame = attributes!.frame

        updateContentOffset(animated: animated, pagerScroll: pagerScroll, toFrame: selectedCellFrame, toIndex: (selectedCellIndexPath as NSIndexPath).row)

        selectedBarFrame.size.width = selectedCellFrame.size.width
        selectedBarFrame.origin.x = selectedCellFrame.origin.x

        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.selectedBar.frame = selectedBarFrame
            })
        } else {
            selectedBar.frame = selectedBarFrame
        }
    }

    // MARK: - Helpers

    private func updateContentOffset(animated: Bool, pagerScroll: PagerScroll, toFrame: CGRect, toIndex: Int) {
        // 만약 pagerScroll이 .no가 아니거나,
        // .scrollOnlyIfOutOfScreen인 경우에만 해당 셀이 화면 밖에 있을 때 스크롤을 수행한다.
        // 셀이 화면 왼쪽 바깥에 있거나, 셀이 화면 오른쪽 바깥에 있을 경우 스크롤을 진행한다.
        guard pagerScroll != .no || (pagerScroll != .scrollOnlyIfOutOfScreen && (toFrame.origin.x < contentOffset.x || toFrame.origin.x >= (contentOffset.x + frame.size.width - contentInset.left))) else { return }
        let targetContentOffset = contentSize.width > frame.size.width ? contentOffsetForCell(withFrame: toFrame, andIndex: toIndex) : 0
        setContentOffset(CGPoint(x: targetContentOffset, y: 0), animated: animated)
    }

    private func contentOffsetForCell(withFrame cellFrame: CGRect, andIndex index: Int) -> CGFloat {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset // swiftlint:disable:this force_cast
        var alignmentOffset: CGFloat = 0.0

        switch selectedBarAlignment {
        case .left:
            alignmentOffset = sectionInset.left
        case .right:
            alignmentOffset = frame.size.width - sectionInset.right - cellFrame.size.width
        case .center:
            alignmentOffset = (frame.size.width - cellFrame.size.width) * 0.5
        case .progressive:
            let cellHalfWidth = cellFrame.size.width * 0.5
            let leftAlignmentOffset = sectionInset.left + cellHalfWidth
            let rightAlignmentOffset = frame.size.width - sectionInset.right - cellHalfWidth
            let numberOfItems = dataSource!.collectionView(self, numberOfItemsInSection: 0)
            let progress = index / (numberOfItems - 1)
            alignmentOffset = leftAlignmentOffset + (rightAlignmentOffset - leftAlignmentOffset) * CGFloat(progress) - cellHalfWidth
        }

        var contentOffset = cellFrame.origin.x - alignmentOffset
        contentOffset = max(0, contentOffset)
        contentOffset = min(contentSize.width - frame.size.width, contentOffset)
        return contentOffset
    }

    private func updateSelectedBarYPosition() {
        var selectedBarFrame = selectedBar.frame

        switch selectedBarVerticalAlignment {
        case .top:
            selectedBarFrame.origin.y = 0
        case .middle:
            selectedBarFrame.origin.y = (frame.size.height - selectedBarHeight) / 2
        case .bottom:
            selectedBarFrame.origin.y = frame.size.height - selectedBarHeight
        }

        selectedBarFrame.size.height = selectedBarHeight
        selectedBar.frame = selectedBarFrame
        defaultBar.frame = .init(
            x: 0,
            y: selectedBarFrame.minY,
            width: self.frame.width,
            height: selectedBarFrame.height
        )
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        updateSelectedBarYPosition()
    }
}
