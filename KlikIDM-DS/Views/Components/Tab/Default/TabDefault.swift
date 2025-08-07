//
//  TabDefault.swift
//  KlikIDM-DS-UiKit
//
//  Created by Rizka Ghinna Auliya on 04/03/25.
//

import UIKit

class TabDefault: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var collectionView: UICollectionView!

    weak var delegate: TabDefaultDelegate?
    
    private var cellIdentifier: String = ""
    private var cellType: AnyClass = TabDefaultCell.self
    
    var viewCell: UICollectionViewCell? = nil
    private var _data: [TabDefaultModelProtocol] = []
    var data: [TabDefaultModelProtocol] = [] {
        didSet {
            _data = data
            collectionView.reloadData()
        }
    }
    var currentlySelectedBucketId: String? = nil
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChip()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupChip()
    }
    
    override func awakeFromNib() {
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
    
    func registerCellType<T: UICollectionViewCell>(_ cellClass: T.Type, withIdentifier identifier: String) {
        cellType = cellClass
        cellIdentifier = identifier
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func setData<T: TabDefaultModelProtocol>(_ tabData: [T]) {
        self.data = tabData
    }
    
    func setSize(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    func setItemPadding(topPadding: CGFloat = 0, leadingPadding: CGFloat = 16, bottomPadding: CGFloat = 0, trailingPadding: CGFloat = 16, itemSpacing: CGFloat = 12) {
        self.itemSpacing = itemSpacing
        self.topPadding = topPadding
        self.leadingPadding = leadingPadding
        self.bottomPadding = bottomPadding
        self.trailingPadding = trailingPadding
        
        setupUI()
    }
    
    func setDynamicWidth(enabled: Bool, minWidth: CGFloat = 60, maxWidth: CGFloat = 200, horizontalPadding: CGFloat = 16) {
        self.useDynamicWidth = enabled
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.horizontalPadding = horizontalPadding
        
        setupUI()
    }
    
    func enableDynamicWidth() {
        setDynamicWidth(enabled: true)
    }
    
    func disableDynamicWidth() {
        setDynamicWidth(enabled: false)
    }
    
    private func calculateDynamicWidth(for text: String, font: UIFont = UIFont.systemFont(ofSize: 14)) -> CGFloat {
        let textSize = text.size(withAttributes: [.font: font])
        let calculatedWidth = textSize.width + horizontalPadding
        
        return max(minWidth, min(maxWidth, calculatedWidth))
    }
    
    func selectDefaultChip() {
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
protocol TabDefaultDelegate: AnyObject {
    func didSelectTabDefault(at index: Int, withId id: String)
}

protocol TabDefaultModelProtocol {
    var id: String { get }
    var title: String { get }
}

protocol TabDefaultCellProtocol: UICollectionViewCell {
    func loadData(item: TabDefaultModelProtocol)
    var isSelectedState: Bool { get set }
}

extension TabDefault: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let chipCell = cell as? TabDefaultCellProtocol {
            let chipData = data[indexPath.item]
            chipCell.loadData(item: chipData)
            chipCell.isSelectedState = (chipData.id == currentlySelectedBucketId)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if useDynamicWidth {
            let displayText = data[indexPath.item].title
            let dynamicWidth = calculateDynamicWidth(for: displayText)
            return CGSize(width: dynamicWidth, height: height)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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


