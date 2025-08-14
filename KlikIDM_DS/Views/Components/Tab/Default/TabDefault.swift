//
//  TabDefault.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 04/03/25.
//

import UIKit

public class TabDefault: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var collectionView: UICollectionView!

    public weak var delegate: TabDefaultDelegate?
    
    public var viewCell: UICollectionViewCell? = nil
    public var data: [TabDefaultModelProtocol] = [] {
        didSet {
            _data = data
            collectionView.reloadData()
        }
    }
    public var currentlySelectedBucketId: String? = nil
    
    private var _data: [TabDefaultModelProtocol] = []
    private var cellIdentifier: String = ""
    private var cellType: AnyClass = TabDefaultCell.self
    
    private var width: CGFloat = 0
    private var height: CGFloat = 0
    
    private var itemSpacing: CGFloat = 12
    private var leadingPadding: CGFloat = 16
    private var trailingPadding: CGFloat = 16
    private var topPadding: CGFloat = 0
    private var bottomPadding: CGFloat = 0
    
    private var useDynamicWidth: Bool = false
    
    private var minWidth: CGFloat = 20
    private var maxWidth: CGFloat = 200
    private var horizontalPadding: CGFloat = 16
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupChip()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChip()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.setupUI()
        }
    }

    private func setupChip() {
        if let nib = Bundle.main.loadNibNamed("TabDefault", owner: self, options: nil),
           let card = nib.first as? UIView {
            containerView = card
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(containerView)
            
            setupUI()
        } else {
            print("Failed to load TabDefault XIB")
        }
    }
    
    private func setupUI() {
        setupChipView()
        
        DispatchQueue.main.async {
            self.selectDefaultChip()
        }
    }
    
    private func setupChipView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: topPadding, left: leadingPadding, bottom: bottomPadding, right: trailingPadding)
        
        if useDynamicWidth {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.decelerationRate = .normal
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func calculateDynamicWidth(for text: String, font: UIFont = UIFont.systemFont(ofSize: 14)) -> CGFloat {
        let textSize = text.size(withAttributes: [.font: font])
        let calculatedWidth = textSize.width + horizontalPadding
        
        return max(minWidth, min(maxWidth, calculatedWidth))
    }
    
    public func registerCellType<T: UICollectionViewCell>(_ cellClass: T.Type, withIdentifier identifier: String) {
        cellType = cellClass
        cellIdentifier = identifier
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func setData<T: TabDefaultModelProtocol>(_ tabData: [T]) {
        self.data = tabData
    }
    
    public func setSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    public func setItemPadding(topPadding: CGFloat = 0, leadingPadding: CGFloat = 16, bottomPadding: CGFloat = 0, trailingPadding: CGFloat = 16, itemSpacing: CGFloat = 12) {
        self.itemSpacing = itemSpacing
        self.topPadding = topPadding
        self.leadingPadding = leadingPadding
        self.bottomPadding = bottomPadding
        self.trailingPadding = trailingPadding
        
        setupUI()
    }
    
    public func setDynamicWidth(enabled: Bool, minWidth: CGFloat = 60, maxWidth: CGFloat = 200, horizontalPadding: CGFloat = 16) {
        self.useDynamicWidth = enabled
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.horizontalPadding = horizontalPadding
        
        setupUI()
    }
    
    public func enableDynamicWidth() {
        setDynamicWidth(enabled: true)
    }
    
    public func disableDynamicWidth() {
        setDynamicWidth(enabled: false)
    }
    
    public func selectDefaultChip() {
        guard !data.isEmpty else { return }
                
        let defaultSelectedIndexPath = IndexPath(item: 0, section: 0)
        currentlySelectedBucketId = data[0].id
        
        if let cell = collectionView.cellForItem(at: defaultSelectedIndexPath) as? TabDefaultCellProtocol {
            for index in 0..<data.count {
                let indexPath = IndexPath(item: index, section: 0)
                if let otherCell = collectionView.cellForItem(at: indexPath) as? TabDefaultCellProtocol {
                    otherCell.isSelectedState = false
                }
            }
            
            cell.isSelectedState = true
        }
        
        if useDynamicWidth {
            DispatchQueue.main.async {
                self.collectionView.performBatchUpdates(nil, completion: nil)
            }
        }
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

extension TabDefault: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let chipCell = cell as? TabDefaultCellProtocol {
            let chipData = data[indexPath.item]
            chipCell.loadData(item: chipData)
            chipCell.isSelectedState = (chipData.id == currentlySelectedBucketId)
        }
        
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if useDynamicWidth {
            let displayText = data[indexPath.item].title
            let dynamicWidth = calculateDynamicWidth(for: displayText)
            return CGSize(width: dynamicWidth, height: height)
        }
        
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for index in 0..<data.count {
            let deselectIndexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: deselectIndexPath) as? TabDefaultCellProtocol {
                cell.isSelectedState = false
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TabDefaultCellProtocol {
            cell.isSelectedState = true
        }
        
        let selectedData = data[indexPath.item].id
        currentlySelectedBucketId = selectedData
        
        if useDynamicWidth {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.performBatchUpdates(nil, completion: nil)
            }
        }
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellFrame = flowLayout.layoutAttributesForItem(at: indexPath)?.frame ?? .zero
            
            let contentOffsetX = cellFrame.midX - (collectionView.bounds.width / 2)
            
            let adjustedOffsetX = max(0, min(contentOffsetX,
                                             collectionView.contentSize.width - collectionView.bounds.width))
            
            collectionView.setContentOffset(CGPoint(x: adjustedOffsetX, y: 0), animated: true)
        }
        
        delegate?.didSelectTabDefault(at: indexPath.item, withId: selectedData)
    }
}


