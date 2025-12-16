//
//  StraggeredLayout.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 14/12/25.
//

import UIKit

public protocol StaggeredLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
}

public class StaggeredLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    public weak var delegate: StaggeredLayoutDelegate?
    
    private var numberOfColumns: Int = 2
    private var cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // MARK: - Configuration
    public func configure(numberOfColumns: Int = 2, cellPadding: CGFloat = 6) {
        self.numberOfColumns = numberOfColumns
        self.cellPadding = cellPadding
    }
    
    // MARK: - Layout Calculation
    public override func prepare() {
        guard let collectionView = collectionView else { return }
        
        // Reset cache
        cache.removeAll()
        contentHeight = 0
        
        // Calculate column width
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var column = 0
        
        // Calculate frames for all items
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let itemWidth = columnWidth - (cellPadding * 2)
            
            // Ask delegate for height
            let itemHeight = delegate?.collectionView(
                collectionView,
                heightForItemAt: indexPath,
                width: itemWidth
            ) ?? 300
            
            let height = cellPadding + itemHeight + cellPadding
            
            let frame = CGRect(
                x: xOffset[column],
                y: yOffset[column],
                width: columnWidth,
                height: height
            )
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // Create layout attributes
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // Update content height
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            // Move to next column (use the shortest column)
            column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return newBounds.width != collectionView.bounds.width
    }
}
