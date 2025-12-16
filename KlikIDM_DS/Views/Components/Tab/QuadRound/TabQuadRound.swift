//
//  TabQuadRound.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 28/05/25.
//

import UIKit

@IBDesignable public class TabQuadRound: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBInspectable public var tabBackgroundColor: UIColor? {
        get { return tabBgColor }
        set { tabBgColor = newValue }
    }
    
    @IBInspectable public var tabBackgroundActiveColor: UIColor? {
        get { return tabBgActiveColor }
        set { tabBgActiveColor = newValue }
    }
    
    @IBInspectable public var tabTextColor: UIColor? {
        get { return tabLblColor }
        set { tabLblColor = newValue }
    }
    
    @IBInspectable public var tabTextActiveColor: UIColor? {
        get { return tabLblActiveColor }
        set { tabLblActiveColor = newValue }
    }
    
    @IBInspectable public var tabBadgeColor: UIColor? {
        get { return tabBdgColor }
        set { tabBdgColor = newValue }
    }
    
    @IBInspectable public var tabBadgeActiveColor: UIColor? {
        get { return tabBdgActiveColor }
        set { tabBdgActiveColor = newValue }
    }
    
    @IBInspectable public var tabBadgeTextColor: UIColor? {
        get { return tabBdgLblColor }
        set { tabBdgLblColor = newValue }
    }
    
    @IBInspectable public var tabBadgeTextActiveColor: UIColor? {
        get { return tabBdgLblActiveColor }
        set { tabBdgLblActiveColor = newValue }
    }
    
    public weak var delegate: TabQuadRoundDelegate?
    
    public var data: [TabQuadRoundModel] = [] {
        didSet {
            collectionView.reloadData()
            updateScrollSettings()
        }
    }
    
    public var selectTabIndex: Int? {
        didSet {
            guard let index = selectTabIndex else { return }
            selectTab(at: index)
        }
    }
    
    private var currentlySelectedId: String? = nil
    private var currentlySelectedIndex: Int? = 0
    
    private var tabBgColor = UIColor.blue20
    private var tabBgActiveColor = UIColor.white
    private var tabLblColor = UIColor.grey50
    private var tabLblActiveColor = UIColor.blue50
    private var tabBdgColor = UIColor.grey50
    private var tabBdgActiveColor = UIColor.blue50
    private var tabBdgLblColor = UIColor.white
    private var tabBdgLblActiveColor = UIColor.white

    private enum Constants {
        static let selectedWidth: CGFloat = 150
        static let unselectedWidth: CGFloat = 86
        static let animationDuration: TimeInterval = 0.3
        static let paddingFactor: CGFloat = 1.2
        static let maxTabsWithoutScroll = 3
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        
        guard let nib = bundle.loadNibNamed("TabQuadRound", owner: self, options: nil),
              let tab = nib.first as? UIView else {
            print("Failed to load TabQuadRound XIB from bundle: \(bundle)")
            return
        }
        
        containerView = tab
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(containerView)
        
        setupUI()
    }

    private func setupUI() {
        containerView.backgroundColor = UIColor.clear
        setupTabView()
        
        DispatchQueue.main.async {
            self.selectDefaultTab()
        }
    }

    private func setupTabView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = .zero
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = UIColor.blue50
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(TabQuadRoundCell.self, forCellWithReuseIdentifier: "TabQuadRoundCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        updateScrollSettings()
    }
    
    private func selectTab(at index: Int) {
        guard index >= 0 && index < data.count else { return }

        currentlySelectedIndex = index
        currentlySelectedId = data[index].id
        
        collectionView.layoutIfNeeded()
        if collectionView.visibleCells.isEmpty {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
        }
        
        updateCell(selectedIndex: index)
        animateSelection(to: IndexPath(item: index, section: 0))
    }
    
    private func selectDefaultTab() {
        guard !data.isEmpty else { return }

        currentlySelectedId = data[0].id
        currentlySelectedIndex = 0
        
        updateCell(selectedIndex: 0)
        collectionView.reloadData()
    }
    
    private func updateCell(selectedIndex: Int) {
        for i in 0..<data.count {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? TabQuadRoundCell else { continue }
            
            configureCellState(cell, at: i, selectedIndex: selectedIndex)
        }
    }
    
    private func configureCellState(_ cell: TabQuadRoundCell, at index: Int, selectedIndex: Int) {
        if shouldUseEqualWidth() {
            cell.shouldUseEqualWidth = true
        }
        
        cell.isSelectedState = (index == selectedIndex)
        cell.isBeforeSelectedState = (index == selectedIndex - 1)
        cell.isAfterSelectedState = (index == selectedIndex + 1)
        cell.isFirstItem = (index == 0)
        cell.isLastItem = (index == data.count - 1)
    }
    
    private func animateSelection(to indexPath: IndexPath) {
        let shouldScroll = shouldUseEqualWidth() ?
            (data.count > Constants.maxTabsWithoutScroll && collectionView.isScrollEnabled) :
            (data.count > Constants.maxTabsWithoutScroll)
        
        guard shouldScroll else { return }
        
        collectionView.collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: Constants.animationDuration) {
            self.collectionView.performBatchUpdates(nil) { _ in
                self.scrollToCenter(at: indexPath)
            }
        }
    }

    private func updateScrollSettings() {
        let totalItems = data.count
        let shouldScroll = totalItems > 2

        collectionView.isScrollEnabled = shouldScroll
        collectionView.alwaysBounceHorizontal = shouldScroll
    }

    private func shouldUseEqualWidth() -> Bool {
        let totalItems = data.count

        switch totalItems {
        case 1, 3, 4:
            return false
        case 2:
            return true
        default:
            let totalWidth = CGFloat(totalItems) * Constants.unselectedWidth
            return totalWidth <= collectionView.frame.width
        }
    }

    private func calculateEqualWidth() -> CGFloat {
        let totalItems = data.count
        let width = collectionView.frame.width

        if totalItems <= 2 {
            return width / CGFloat(totalItems)
        }

        let baseWidth = width / CGFloat(totalItems)
        return baseWidth * Constants.paddingFactor
    }

    private func calculateWidthThreeItems(isSelected: Bool) -> CGFloat {
        if isSelected {
            return Constants.selectedWidth
        } else {
            let remainingWidth = collectionView.frame.width - Constants.selectedWidth
            return remainingWidth / 2
        }
    }
    
    private func calculateCellWidth(for indexPath: IndexPath) -> CGFloat {
        let tabData = data[indexPath.item]
        let isSelected = tabData.id == currentlySelectedId
        let totalItems = data.count

        if totalItems == 1 {
            return Constants.selectedWidth
        }

        if totalItems == 3 {
            return calculateWidthThreeItems(isSelected: isSelected)
        }

        if shouldUseEqualWidth() {
            return calculateEqualWidth()
        }

        return isSelected ? Constants.selectedWidth : Constants.unselectedWidth
    }

    private func scrollToCenter(at indexPath: IndexPath) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellFrame = flowLayout.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
        let contentOffsetX = cellFrame.midX - (collectionView.bounds.width / 2)
        let adjustedOffsetX = max(0, min(contentOffsetX,
                                        collectionView.contentSize.width - collectionView.bounds.width))
        
        collectionView.setContentOffset(CGPoint(x: adjustedOffsetX, y: 0), animated: true)
    }
}

public struct TabQuadRoundModel {
    var id: String
    var title: String
    var badge: Int
    
    public init(id: String, title: String, badge: Int) {
        self.id = id
        self.title = title
        self.badge = badge
    }
}

@MainActor
public protocol TabQuadRoundDelegate: AnyObject {
    func didSelectTabQuadRound(at index: Int, withId id: String)
}

extension TabQuadRound: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabQuadRoundCell", for: indexPath) as! TabQuadRoundCell
        
        configureCell(cell, at: indexPath)
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateCellWidth(for: indexPath)
        return CGSize(width: width, height: collectionView.frame.height)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = data[indexPath.item]
        currentlySelectedId = selectedData.id
        currentlySelectedIndex = indexPath.item

        collectionView.reloadData()
        animateSelection(to: indexPath)

        delegate?.didSelectTabQuadRound(at: indexPath.item, withId: selectedData.id)
    }
    
    private func configureCell(_ cell: TabQuadRoundCell, at indexPath: IndexPath) {
        cell.tabBackgroundColor = tabBgColor
        cell.tabBackgroundActiveColor = tabBgActiveColor
        cell.tabTextColor = tabLblColor
        cell.tabTextActiveColor = tabLblActiveColor
        cell.tabBadgeColor = tabBadgeColor
        cell.tabBadgeActiveColor = tabBadgeActiveColor
        cell.tabBadgeTextColor = tabBadgeTextColor
        cell.tabBadgeTextActiveColor = tabBadgeTextActiveColor
        
        let tabData = data[indexPath.item]
        
        if currentlySelectedId == nil && indexPath.item == 0 {
            currentlySelectedId = tabData.id
            currentlySelectedIndex = 0
        }

        let isEqualWidthMode = shouldUseEqualWidth()
        cell.shouldUseEqualWidth = isEqualWidthMode
        cell.totalTabCount = data.count

        if isEqualWidthMode {
            cell.setEqualWidth(calculateEqualWidth())
        } else if data.count == 3 {
            let isSelected = (tabData.id == currentlySelectedId)
            cell.setEqualWidth(calculateWidthThreeItems(isSelected: isSelected))
            cell.shouldUseEqualWidth = true
        }

        cell.loadData(data: tabData)
        cell.isSelectedState = (tabData.id == currentlySelectedId)

        if let selectedIndex = currentlySelectedIndex {
            cell.isBeforeSelectedState = (indexPath.item == selectedIndex - 1)
            cell.isAfterSelectedState = (indexPath.item == selectedIndex + 1)
            cell.isFirstItem = (indexPath.item == 0)
            cell.isLastItem = (indexPath.item == data.count - 1)
        } else {
            cell.isBeforeSelectedState = false
            cell.isAfterSelectedState = false
        }
    }
}
