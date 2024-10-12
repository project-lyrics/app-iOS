//
//  FeelinButtonBarPagerTabViewController.swift
//  SharedDesignSystem
//
//  Created by 황인우 on 9/22/24.
//

import UIKit

public enum ButtonBarItemSpec<CellType: UICollectionViewCell> {
    case cellClass(width:((IndicatorInfo)-> CGFloat))

    public var weight: ((IndicatorInfo) -> CGFloat) {
        switch self {
        case .cellClass(let widthCallback):
            return widthCallback
        }
    }
}

public struct ButtonBarPagerTabStripSettings {
    public struct Style {
        public var buttonBarBackgroundColor: UIColor?
        public var buttonBarMinimumInteritemSpacing: CGFloat?
        public var buttonBarMinimumLineSpacing: CGFloat?
        public var buttonBarLeftContentInset: CGFloat?
        public var buttonBarRightContentInset: CGFloat?

        public var defaultBarBackgroundColor = UIColor.clear
        public var selectedBarBackgroundColor = UIColor.black
        public var selectedBarHeight: CGFloat = 5
        public var selectedBarVerticalAlignment: SelectedBarVerticalAlignment = .bottom
        public var selectedBarItemTitleColor: UIColor?

        public var buttonBarItemBackgroundColor: UIColor?
        public var buttonBarItemFont = UIFont.systemFont(ofSize: 18)
        public var buttonBarItemLeftRightMargin: CGFloat = 8
        public var buttonBarItemTitleColor: UIColor?
        public var buttonBarItemsShouldFillAvailableWidth = true
        // only used if button bar is created programaticaly and not using storyboards or nib files
        public var buttonBarHeight: CGFloat?
    }

    public var style = Style()
}


open class ButtonBarPagerTabStripViewController: FeelinPagerTabViewController, PagerTabStripDataSource, PagerTabStripIsProgressiveDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    public var buttonBarView: ButtonBarView!
    public var settings = ButtonBarPagerTabStripSettings()
    public var buttonBarItemSpec: ButtonBarItemSpec<ButtonBarViewCell>!

    public var changeCurrentIndex: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ animated: Bool) -> Void)?
    public var changeCurrentIndexProgressive: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    public var onChangeItemInfo: (() -> Void)?
    
    private var shouldUpdateButtonBarView = true
    private var collectionViewDidLoad = false
    
    lazy private var cachedCellWidths: [CGFloat]? = { [unowned self] in
        return self.calculateWidths()
    }()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.delegate = self
        self.datasource = self
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBarItemSpec = .cellClass(width: { [weak self] childItemInfo in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = self?.settings.style.buttonBarItemFont
            label.text = childItemInfo.title
            let labelSize = label.intrinsicContentSize
            return labelSize.width + (self?.settings.style.buttonBarItemLeftRightMargin ?? 8) * 2
        })
        
        let buttonBarViewAux = buttonBarView ?? {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            
            let buttonBarHeight = settings.style.buttonBarHeight ?? 44
            let buttonBar = ButtonBarView(
                frame: CGRect(x: 0,
                y: 0,
                width: view.frame.size.width,
                height: buttonBarHeight),
                collectionViewLayout: flowLayout
            )
            buttonBar.backgroundColor = .orange
            buttonBar.selectedBar.backgroundColor = .black
            buttonBar.autoresizingMask = .flexibleWidth
            var newContainerViewFrame = containerView.frame
            newContainerViewFrame.origin.y = buttonBarHeight
            newContainerViewFrame.size.height = containerView.frame.size.height - (buttonBarHeight - containerView.frame.origin.y)
            containerView.frame = newContainerViewFrame
            return buttonBar
        }()
        
        buttonBarView = buttonBarViewAux

        if buttonBarView.superview == nil {
            view.addSubview(buttonBarView)
        }
        if buttonBarView.delegate == nil {
            buttonBarView.delegate = self
        }
        if buttonBarView.dataSource == nil {
            buttonBarView.dataSource = self
        }
        buttonBarView.scrollsToTop = false
        let flowLayout = buttonBarView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = settings.style.buttonBarMinimumInteritemSpacing ?? flowLayout.minimumInteritemSpacing
        flowLayout.minimumLineSpacing = settings.style.buttonBarMinimumLineSpacing ?? flowLayout.minimumLineSpacing
        let sectionInset = flowLayout.sectionInset
        flowLayout.sectionInset = UIEdgeInsets(top: sectionInset.top, left: settings.style.buttonBarLeftContentInset ?? sectionInset.left, bottom: sectionInset.bottom, right: settings.style.buttonBarRightContentInset ?? sectionInset.right)
        
        flowLayout.itemSize = CGSize(
            width: view.frame.width / CGFloat(integerLiteral: viewControllers.count),
            height: containerView.frame.height
        )
        buttonBarView.showsHorizontalScrollIndicator = false
        buttonBarView.backgroundColor = settings.style.buttonBarBackgroundColor ?? buttonBarView.backgroundColor
        buttonBarView.selectedBar.backgroundColor = settings.style.selectedBarBackgroundColor
        buttonBarView.defaultBar.backgroundColor = settings.style.defaultBarBackgroundColor

        buttonBarView.selectedBarHeight = settings.style.selectedBarHeight
        buttonBarView.selectedBarVerticalAlignment = settings.style.selectedBarVerticalAlignment

        // register button bar item cell
        buttonBarView.register(ButtonBarViewCell.self, forCellWithReuseIdentifier:"Cell")
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isViewAppearing || isViewRotating else { return }
        
        cachedCellWidths = calculateWidths()
        buttonBarView.collectionViewLayout.invalidateLayout()
        
        buttonBarView.moveTo(index: currentIndex, animated: false, swipeDirection: .none, pagerScroll: .scrollOnlyIfOutOfScreen)
        buttonBarView.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: false, scrollPosition: [])
    }
    
    open override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
        guard isViewLoaded else { return }
        buttonBarView.reloadData()
        cachedCellWidths = calculateWidths()
        buttonBarView.moveTo(
            index: currentIndex,
            animated: false,
            swipeDirection: .none,
            pagerScroll: .yes
        )
    }

    open func calculateStretchedCellWidths(_ minimumCellWidths: [CGFloat], suggestedStretchedCellWidth: CGFloat, previousNumberOfLargeCells: Int) -> CGFloat {
        var numberOfLargeCells = 0
        var totalWidthOfLargeCells: CGFloat = 0

        for minimumCellWidthValue in minimumCellWidths where minimumCellWidthValue > suggestedStretchedCellWidth {
            totalWidthOfLargeCells += minimumCellWidthValue
            numberOfLargeCells += 1
        }

        guard numberOfLargeCells > previousNumberOfLargeCells else { return suggestedStretchedCellWidth }

        let flowLayout = buttonBarView.collectionViewLayout as! UICollectionViewFlowLayout // swiftlint:disable:this force_cast
        let collectionViewAvailiableWidth = buttonBarView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let numberOfCells = minimumCellWidths.count
        let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumLineSpacing

        let numberOfSmallCells = numberOfCells - numberOfLargeCells
        let newSuggestedStretchedCellWidth = (collectionViewAvailiableWidth - totalWidthOfLargeCells - cellSpacingTotal) / CGFloat(numberOfSmallCells)

        return calculateStretchedCellWidths(minimumCellWidths, suggestedStretchedCellWidth: newSuggestedStretchedCellWidth, previousNumberOfLargeCells: numberOfLargeCells)
    }
    
    open func updateIndicator(
        for viewController: FeelinPagerTabViewController,
        fromIndex: Int,
        toIndex: Int
    ) {
        guard shouldUpdateButtonBarView else { return }
        buttonBarView.moveTo(index: toIndex, animated: false, swipeDirection: toIndex < fromIndex ? .right : .left, pagerScroll: .yes)

        if let changeCurrentIndex = changeCurrentIndex {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)

            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndex(cells.first!, cells.last!, true)
        }
    }

    open func updateIndicator(
        for viewController: FeelinPagerTabViewController,
        fromIndex: Int,
        toIndex: Int,
        withProgressPercentage progressPercentage: CGFloat,
        indexWasChanged: Bool
    ) {
        guard shouldUpdateButtonBarView else { return }
        buttonBarView.move(fromIndex: fromIndex, toIndex: toIndex, progressPercentage: progressPercentage, pagerScroll: .yes)
        if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)

            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndexProgressive(cells.first!, cells.last!, progressPercentage, indexWasChanged, true)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ButtonBarViewCell else {
            fatalError("UICollectionViewCell should be or extend from ButtonBarViewCell")
        }
        
        let childController = viewControllers[indexPath.item] as! IndicatorInfoProvider
        let indicatorInfo = childController.indicatorInfo(for: self)
        
        // 셀의 label 설정
        cell.label.text = indicatorInfo.title
        cell.label.font = settings.style.buttonBarItemFont

        if indexPath.item == currentIndex {
             cell.label.textColor = settings.style.selectedBarItemTitleColor  ?? cell.label.textColor
         } else {
             cell.label.textColor = settings.style.buttonBarItemTitleColor
         }

        cell.contentView.backgroundColor = settings.style.buttonBarItemBackgroundColor ?? cell.contentView.backgroundColor
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    open func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath
    ) -> CGSize {
        guard let cellWidthValue = cachedCellWidths?[indexPath.row] else {
            fatalError("cachedCellWidths for \(indexPath.row) must not be nil")
        }
        return CGSize(width: cellWidthValue, height: collectionView.frame.size.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != currentIndex else { return }

        buttonBarView.moveTo(index: indexPath.item, animated: true, swipeDirection: .none, pagerScroll: .yes)
        shouldUpdateButtonBarView = false

        let oldIndexPath = IndexPath(item: currentIndex, section: 0)
        let newIndexPath = IndexPath(item: indexPath.item, section: 0)

        let oldCell = collectionView.cellForItem(at: oldIndexPath) as? ButtonBarViewCell
        let newCell = collectionView.cellForItem(at: newIndexPath) as? ButtonBarViewCell

        oldCell?.label.textColor = settings.style.buttonBarItemTitleColor
        newCell?.label.textColor = settings.style.selectedBarItemTitleColor ?? settings.style.buttonBarItemTitleColor

        let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)

        if pagerBehaviour.isProgressiveIndicator {
            if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
                changeCurrentIndexProgressive(cells.first!, cells.last!, 1, true, true)
            }
        } else {
            if let changeCurrentIndex = changeCurrentIndex {
                changeCurrentIndex(cells.first!, cells.last!, true)
            }
        }
        moveToViewController(at: indexPath.item)
    }
    
    private func cellForItems(at indexPaths: [IndexPath], reloadIfNotVisible reload: Bool = true) -> [ButtonBarViewCell?] {
        let cells = indexPaths.map { buttonBarView.cellForItem(at: $0) as? ButtonBarViewCell }

        if reload {
            let indexPathsToReload = cells.enumerated()
                .compactMap { (arg) -> IndexPath? in
                    let (index, cell) = arg
                    return cell == nil ? indexPaths[index] : nil
                }
                .compactMap { (indexPath: IndexPath) -> IndexPath? in
                    return (indexPath.item >= 0 && indexPath.item < buttonBarView.numberOfItems(inSection: indexPath.section)) ? indexPath : nil
                }

            if !indexPathsToReload.isEmpty {
                buttonBarView.reloadItems(at: indexPathsToReload)
            }
        }

        return cells
    }
    
    // MARK: - UIScrollViewDelegate

    open override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)

        guard scrollView == containerView else { return }
        shouldUpdateButtonBarView = true
    }

    open func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
    }
    
    private func calculateWidths() -> [CGFloat] {
        let flowLayout = buttonBarView.collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfCells = viewControllers.count

        var minimumCellWidths = [CGFloat]()
        var collectionViewContentWidth: CGFloat = 0

        for viewController in viewControllers {
            let childController = viewController as! IndicatorInfoProvider
            let indicatorInfo = childController.indicatorInfo(for: self)
            switch buttonBarItemSpec! {
            case .cellClass(let widthCallback):
                let width = widthCallback(indicatorInfo)
                minimumCellWidths.append(width)
                collectionViewContentWidth += width
            }
        }

        let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumLineSpacing
        collectionViewContentWidth += cellSpacingTotal

        let collectionViewAvailableVisibleWidth = buttonBarView.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right

        if !settings.style.buttonBarItemsShouldFillAvailableWidth || collectionViewAvailableVisibleWidth < collectionViewContentWidth {
            return minimumCellWidths
        } else {
            let stretchedCellWidthIfAllEqual = (collectionViewAvailableVisibleWidth - cellSpacingTotal) / CGFloat(numberOfCells)
            let generalMinimumCellWidth = calculateStretchedCellWidths(
                minimumCellWidths,
                suggestedStretchedCellWidth: stretchedCellWidthIfAllEqual,
                previousNumberOfLargeCells: 0
            )
            var stretchedCellWidths = [CGFloat]()

            for minimumCellWidthValue in minimumCellWidths {
                let cellWidth = (minimumCellWidthValue > generalMinimumCellWidth) ? minimumCellWidthValue : generalMinimumCellWidth
                stretchedCellWidths.append(cellWidth)
            }

            return stretchedCellWidths
        }
    }
}
