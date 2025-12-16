//
//  TabDefault.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 04/03/25.
//

import UIKit

public class TabDefault: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    public weak var delegate: TabDefaultDelegate?

    public var cellConfiguration: ((UICollectionViewCell, TabDefaultModelProtocol, Bool, Int) -> Void)?
    
    public var data: [TabDefaultModelProtocol] = [] {
        didSet {
            reloadData()
        }
    }
    
    private var cellIdentifier: String = ""
    private var cellType: AnyClass = TabDefaultCell.self
    private var currentlySelectedId: String?
    
    private var layoutConfig = LayoutConfig()
    private var sizingConfig = SizingConfig()
    
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
        guard let views = bundle.loadNibNamed("TabDefault", owner: self, options: nil),
              let tab = views.first as? UIView else {
            assertionFailure("Failed to load TabDefault XIB from bundle: \(bundle)")
            return
        }
        
        containerView = tab
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(containerView)
        
        DispatchQueue.main.async { [weak self] in
            self?.setupUI()
        }
    }
    
    private func setupUI() {
        configureCollectionView()
        selectDefaultTab()
    }
    
    private func configureCollectionView() {
        let flowLayout = createFlowLayout()
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.decelerationRate = .normal
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = layoutConfig.itemSpacing
        layout.sectionInset = layoutConfig.edgeInsets
        
        if sizingConfig.useDynamicWidth {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        return layout
    }
    
    public func registerCellType<T: UICollectionViewCell>(_ cellClass: T.Type, withIdentifier identifier: String) {
        cellType = cellClass
        cellIdentifier = identifier
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func setSize(width: CGFloat, height: CGFloat, horizontalPadding: CGFloat = 0) {
        sizingConfig.width = width
        sizingConfig.height = height
        sizingConfig.horizontalPadding = horizontalPadding
    }
    
    public func setItemPadding(
        topPadding: CGFloat = 0,
        leadingPadding: CGFloat = 16,
        bottomPadding: CGFloat = 0,
        trailingPadding: CGFloat = 16,
        itemSpacing: CGFloat = 12
    ) {
        layoutConfig.update(
            top: topPadding,
            leading: leadingPadding,
            bottom: bottomPadding,
            trailing: trailingPadding,
            spacing: itemSpacing
        )
        setupUI()
    }
    
    public func setDynamicWidth(
        enabled: Bool,
        minWidth: CGFloat = 60,
        maxWidth: CGFloat = 200,
        horizontalPadding: CGFloat = 16
    ) {
        sizingConfig.useDynamicWidth = enabled
        sizingConfig.minWidth = minWidth
        sizingConfig.maxWidth = maxWidth
        sizingConfig.horizontalPadding = horizontalPadding
        setupUI()
    }
    
    public func enableDynamicWidth() {
        setDynamicWidth(enabled: true)
    }
    
    public func disableDynamicWidth() {
        setDynamicWidth(enabled: false)
    }
    
    public func selectDefaultTab() {
        guard !data.isEmpty else { return }
        
        let firstIndexPath = IndexPath(item: 0, section: 0)
        currentlySelectedId = data[0].id
        
        deselectAllCells()
        selectCell(at: firstIndexPath)
        scrollToItem(at: firstIndexPath, animated: false)
    }
    
    private func reloadData() {
        UIView.performWithoutAnimation { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func calculateDynamicWidth(
        for text: String,
        font: UIFont = .systemFont(ofSize: 14)
    ) -> CGFloat {
        let textSize = text.size(withAttributes: [.font: font])
        let calculatedWidth = textSize.width + sizingConfig.horizontalPadding
        
        return sizingConfig.setWidth(calculatedWidth)
    }
    
    private func deselectAllCells() {
        for index in data.indices {
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? TabDefaultCellProtocol {
                cell.isSelectedState = false
            }
        }
    }
    
    private func selectCell(at indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? TabDefaultCellProtocol {
            cell.isSelectedState = true
        }
    }
    
    private func scrollToItem(at indexPath: IndexPath, animated: Bool) {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let cellFrame = flowLayout.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
        let contentOffsetX = calculateCenteredOffset(for: cellFrame)
        
        collectionView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: animated)
    }
    
    private func calculateCenteredOffset(for cellFrame: CGRect) -> CGFloat {
        let targetOffset = cellFrame.midX - (collectionView.bounds.width / 2)
        let maxOffset = collectionView.contentSize.width - collectionView.bounds.width
        return max(0, min(targetOffset, maxOffset))
    }
}

extension TabDefault: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return data.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        )
        
        if let tabCell = cell as? TabDefaultCellProtocol {
            let tabData = data[indexPath.item]
            let isSelected = (tabData.id == currentlySelectedId)
            
            tabCell.loadData(item: tabData)
            tabCell.isSelectedState = isSelected
            
            cellConfiguration?(cell, tabData, isSelected, indexPath.row)
        }
        
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        deselectAllCells()
        selectCell(at: indexPath)
        
        let selectedData = data[indexPath.item]
        currentlySelectedId = selectedData.id
        
        scrollToItem(at: indexPath, animated: true)
        delegate?.didSelectTabDefault(at: indexPath.item, withId: selectedData.id)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat
        
        if sizingConfig.useDynamicWidth {
            let displayText = data[indexPath.item].title
            width = calculateDynamicWidth(for: displayText)
        } else {
            width = sizingConfig.width
        }
        
        return CGSize(width: width, height: sizingConfig.height)
    }
}

private struct LayoutConfig {
    var itemSpacing: CGFloat = 12
    var topPadding: CGFloat = 0
    var leadingPadding: CGFloat = 16
    var bottomPadding: CGFloat = 0
    var trailingPadding: CGFloat = 16
    
    var edgeInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: topPadding,
            left: leadingPadding,
            bottom: bottomPadding,
            right: trailingPadding
        )
    }
    
    mutating func update(
        top: CGFloat,
        leading: CGFloat,
        bottom: CGFloat,
        trailing: CGFloat,
        spacing: CGFloat
    ) {
        self.topPadding = top
        self.leadingPadding = leading
        self.bottomPadding = bottom
        self.trailingPadding = trailing
        self.itemSpacing = spacing
    }
}

private struct SizingConfig {
    var width: CGFloat = 0
    var height: CGFloat = 0
    var useDynamicWidth: Bool = false
    var minWidth: CGFloat = 20
    var maxWidth: CGFloat = 200
    var horizontalPadding: CGFloat = 16
    
    func setWidth(_ width: CGFloat) -> CGFloat {
        max(minWidth, min(maxWidth, width))
    }
}

@MainActor
public protocol TabDefaultDelegate: AnyObject {
    func didSelectTabDefault(at index: Int, withId id: String)
}

public protocol TabDefaultModelProtocol {
    var id: String { get }
    var title: String { get }
}

public protocol TabDefaultCellProtocol: UICollectionViewCell {
    func loadData(item: TabDefaultModelProtocol)
    var isSelectedState: Bool { get set }
}


