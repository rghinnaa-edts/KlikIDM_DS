//
//  TabQuadRound.swift
//  KlikIDM-DS-UiKit
//
//  Created by Rizka Ghinna Auliya on 28/05/25.
//

import UIKit

class TabQuadRound: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    weak var delegate: TabQuadRoundDelegate?
    var currentlySelectedId: String? = nil
    var currentlySelectedIndex: Int? = nil

    var data: [TabQuadRoundModel] = [] {
        didSet {
            collectionView.reloadData()
            updateScrollSettings()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTab()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTab()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        DispatchQueue.main.async {
            self.backgroundColor = UIColor.blue50
            self.setupUI()
        }
    }

    private func setupTab() {
        if let nib = Bundle.main.loadNibNamed("TabQuadRound", owner: self, options: nil),
           let card = nib.first as? UIView {
            containerView = card
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(containerView)

            setupUI()
        } else {
            print("Failed to load TabQuadRound XIB")
        }
    }

    private func setupUI() {
        containerView.backgroundColor = UIColor.blue50

        setupTabView()

        DispatchQueue.main.async {
            self.selectDefaultTab()
        }
    }

    private func setupTabView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = UIColor.blue50
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.decelerationRate = .normal
        collectionView.register(TabQuadRoundCell.self, forCellWithReuseIdentifier: "TabQuadRoundCell")

        collectionView.delegate = self
        collectionView.dataSource = self

        updateScrollSettings()
    }

    private func updateScrollSettings() {
        let totalItems = data.count

        if totalItems == 1 || totalItems == 2 {
            collectionView.isScrollEnabled = false
            collectionView.alwaysBounceHorizontal = false
        } else {
            collectionView.isScrollEnabled = true
            collectionView.alwaysBounceHorizontal = true
        }
    }

    private func shouldUseEqualWidth() -> Bool {
        let totalItems = data.count

        if totalItems == 1 {
            return false
        }

        if totalItems == 2 {
            return true
        }

        if totalItems == 3 {
            return false
        }
        
        if totalItems == 4 {
            return false
        }

        if totalItems > 4 {
            let totalContentWidth = CGFloat(totalItems) * 86
            let availableWidth = collectionView.frame.width

            return totalContentWidth <= availableWidth
        }

        return false
    }

    private func calculateEqualWidthWithPadding() -> CGFloat {
        let totalItems = data.count
        let availableWidth = collectionView.frame.width

        if totalItems <= 2 {
            return availableWidth / CGFloat(totalItems)
        }

        let baseWidth = availableWidth / CGFloat(totalItems)
        let paddingFactor: CGFloat = 1.2
        return baseWidth * paddingFactor
    }

    private func calculateWidthForThreeItems(isSelected: Bool) -> CGFloat {
        let availableWidth = collectionView.frame.width
        let selectedWidth: CGFloat = 150
        
        if isSelected {
            return selectedWidth
        } else {
            let remainingWidth = availableWidth - selectedWidth
            return remainingWidth / 2
        }
    }

    func selectDefaultTab() {
        guard !data.isEmpty else { return }

        currentlySelectedId = data[0].id
        currentlySelectedIndex = 0
        
        for index in 0..<data.count {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? TabQuadRoundCell {
                if shouldUseEqualWidth() {
                    cell.shouldUseEqualWidth = true
                }
                cell.isSelectedState = (index == 0)
                cell.isBeforeSelectedState = (index == (0 - 1))
                cell.isAfterSelectedState = (index == (index + 1))
                cell.isFirstItem = (index == 0)
                cell.isLastItem = (index == (data.count - 1))
            }
        }
        collectionView.reloadData()
    }

    func selectTab(at index: Int) {
        guard index >= 0 && index < data.count else { return }

        currentlySelectedIndex = index
        currentlySelectedId = data[index].id
        let targetIndexPath = IndexPath(item: index, section: 0)
        
        for index in 0..<data.count {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? TabQuadRoundCell {
                if shouldUseEqualWidth() {
                    cell.shouldUseEqualWidth = true
                }
                cell.isSelectedState = (index == 0)
                cell.isBeforeSelectedState = (index == (0 - 1))
                cell.isAfterSelectedState = (index == (index + 1))
                cell.isFirstItem = (index == 0)
                cell.isLastItem = (index == (data.count - 1))
            }
        }

        if shouldUseEqualWidth() {
            if data.count > 3 && collectionView.isScrollEnabled {
                collectionView.collectionViewLayout.invalidateLayout()

                UIView.animate(withDuration: 0.3) {
                    self.collectionView.performBatchUpdates(nil) { _ in
                        self.scrollToCenter(at: targetIndexPath)
                    }
                }
            }
        } else {
            collectionView.collectionViewLayout.invalidateLayout()

            UIView.animate(withDuration: 0.3) {
                self.collectionView.performBatchUpdates(nil) { _ in
                    if self.data.count > 3 {
                        self.scrollToCenter(at: targetIndexPath)
                    }
                }
            }
        }
        collectionView.reloadData()
    }

    private func scrollToCenter(at indexPath: IndexPath) {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellFrame = flowLayout.layoutAttributesForItem(at: indexPath)?.frame ?? .zero

            let contentOffsetX = cellFrame.midX - (collectionView.bounds.width / 2)

            let adjustedOffsetX = max(0, min(contentOffsetX,
                                             collectionView.contentSize.width - collectionView.bounds.width))

            collectionView.setContentOffset(CGPoint(x: adjustedOffsetX, y: 0), animated: true)
        }
    }

    func setData(_ tabData: [TabQuadRoundModel]) {
        self.data = tabData
    }
}

struct TabQuadRoundModel {
    var id: String
    var title: String
    var badge: Int
}

@MainActor
protocol TabQuadRoundDelegate: AnyObject {
    func didSelectTabQuadRound(at index: Int, withId id: String)
}

extension TabQuadRound: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabQuadRoundCell", for: indexPath) as! TabQuadRoundCell

        let tabData = data[indexPath.item]

        if currentlySelectedId == nil && indexPath.item == 0 {
            currentlySelectedId = tabData.id
            currentlySelectedIndex = 0
        }

        let isEqualWidthMode = shouldUseEqualWidth()
        cell.shouldUseEqualWidth = isEqualWidthMode
        cell.totalTabCount = data.count

        if isEqualWidthMode {
            let equalWidth = calculateEqualWidthWithPadding()
            cell.setEqualWidth(equalWidth)
        } else if data.count == 3 {
            let isSelected = (tabData.id == currentlySelectedId)
            let width = calculateWidthForThreeItems(isSelected: isSelected)
            cell.setEqualWidth(width)
            cell.shouldUseEqualWidth = true
        }

        cell.loadData(data: tabData)
        cell.isSelectedState = (tabData.id == currentlySelectedId)

        if let selectedIndex = currentlySelectedIndex {
            cell.isBeforeSelectedState = (indexPath.item == selectedIndex - 1)
            cell.isAfterSelectedState = (indexPath.item == selectedIndex + 1)
            cell.isFirstItem = (indexPath.item == 0)
            cell.isLastItem = (indexPath.item == (data.count - 1))
        } else {
            cell.isBeforeSelectedState = false
            cell.isAfterSelectedState = false
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let tabData = data[indexPath.item]
        let isSelected = tabData.id == currentlySelectedId
        let totalItems = data.count

        if totalItems == 1 {
            return CGSize(width: 150, height: collectionView.frame.height)
        }

        if totalItems == 3 {
            let width = calculateWidthForThreeItems(isSelected: isSelected)
            return CGSize(width: width, height: collectionView.frame.height)
        }

        if shouldUseEqualWidth() {
            let itemWidth = calculateEqualWidthWithPadding()
            return CGSize(width: itemWidth, height: collectionView.frame.height)
        }

        if isSelected {
            return CGSize(width: 150, height: collectionView.frame.height)
        } else {
            return CGSize(width: 86, height: collectionView.frame.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let selectedData = data[indexPath.item]
        currentlySelectedId = selectedData.id
        currentlySelectedIndex = indexPath.item

        collectionView.reloadData()

        if shouldUseEqualWidth() {
            if data.count > 3 && collectionView.isScrollEnabled {
                collectionView.collectionViewLayout.invalidateLayout()

                UIView.animate(withDuration: 0.3) {
                    self.collectionView.performBatchUpdates(nil) { _ in
                        self.scrollToCenter(at: indexPath)
                    }
                }
            }
        } else {
            collectionView.collectionViewLayout.invalidateLayout()

            UIView.animate(withDuration: 0.3) {
                self.collectionView.performBatchUpdates(nil) { _ in
                    if self.data.count > 3 {
                        self.scrollToCenter(at: indexPath)
                    }
                }
            }
        }

        delegate?.didSelectTabQuadRound(at: indexPath.item, withId: selectedData.id)
    }
}
