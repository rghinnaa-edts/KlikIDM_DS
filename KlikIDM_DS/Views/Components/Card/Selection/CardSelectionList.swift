//
//  CardSelectionList.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/12/25.
//

import UIKit

public class CardSelectionList: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public weak var delegate: CardSelectionDelegate?
    
    public var data: [CardSelectionModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var titleColor: UIColor? {
        didSet {
            cardTitleColor = titleColor
        }
    }
    
    public var titleActiveColor: UIColor? {
        didSet {
            cardTitleActiveColor = titleActiveColor
        }
    }
    
    public var descColor: UIColor? {
        didSet {
            cardDescColor = descColor
        }
    }
    
    public var descActiveColor: UIColor? {
        didSet {
            cardDescActiveColor = descActiveColor
        }
    }
    
    public var bgColor: UIColor? {
        didSet {
            cardBackgroundColor = bgColor
        }
    }
    
    public var bgActiveColor: UIColor? {
        didSet {
            cardBackgroundActiveColor = bgActiveColor
        }
    }
    
    public var borderColor: UIColor? {
        didSet {
            cardBorderColor = borderColor
        }
    }
    
    public var borderActiveColor: UIColor? {
        didSet {
            cardBorderActiveColor = borderActiveColor
        }
    }
    
    public var borderWidth: CGFloat? {
        didSet {
            cardBorderWidth = borderWidth
        }
    }
    
    public var cornerRadius: CGFloat? {
        didSet {
            cardCornerRadius = cornerRadius
        }
    }
    
    public var shadowOpacity: CGFloat? {
        didSet {
            cardShadowOpacity = shadowOpacity
        }
    }
    
    public var shadowOffset: CGSize? {
        didSet {
            cardShadowOffset = shadowOffset
        }
    }
    
    public var shadowRadius: CGFloat? {
        didSet {
            cardShadowRadius = shadowRadius
        }
    }
    
    private var selectedIndex: Int? = 0
    private var cardTitleColor = UIColor.grey70
    private var cardTitleActiveColor = UIColor.blueDefault
    private var cardDescColor = UIColor.grey50
    private var cardDescActiveColor = UIColor.grey50
    private var cardBackgroundColor = UIColor.white
    private var cardBackgroundActiveColor = UIColor.white
    private var cardBorderColor = UIColor.grey20
    private var cardBorderActiveColor = UIColor.blueDefault
    private var cardBorderWidth: CGFloat? = 0.0
    private var cardCornerRadius: CGFloat? = 0.0
    private var cardShadowOpacity: CGFloat? = 0.0
    private var cardShadowOffset: CGSize? = CGSize(width: 0, height: 0)
    private var cardShadowRadius: CGFloat? = 0.0
    
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
        if let nib = bundle.loadNibNamed("CardSelectionList", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(containerView)
            
            setupCollectionView()
        }
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)

        collectionView.collectionViewLayout = flowLayout
        collectionView.register(CardSelectionCell.self, forCellWithReuseIdentifier: "CardSelectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
    }
    
    private func configureCell(_ cell: CardSelectionCell) {
        cell.cardTitleColor = cardTitleColor
        cell.cardTitleActiveColor = cardTitleActiveColor
        cell.cardDescColor = cardDescColor
        cell.cardDescActiveColor = cardDescActiveColor
        cell.cardBackgroundColor = cardBackgroundColor
        cell.cardBackgroundActiveColor = cardBackgroundActiveColor
        cell.cardBorderColor = cardBorderColor
        cell.cardBorderActiveColor = cardBorderActiveColor
        cell.cardBorderWidth = cardBorderWidth ?? 0.0
        cell.cardCornerRadius = cardCornerRadius ?? 0.0
    }
    
    private func selectDefaultCell() {
        guard !data.isEmpty else { return }

        selectedIndex = 0
        
        updateCell(selectedIndex: 0)
        collectionView.reloadData()
    }
    
    private func updateCell(selectedIndex: Int) {
        for i in 0..<data.count {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? CardSelectionCell else { continue }
            
            cell.isSelectedState = (i == selectedIndex)
        }
    }
    
}

@MainActor
public protocol CardSelectionDelegate: AnyObject {
    func didSelectCardSelection(at index: Int)
}

extension CardSelectionList: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardSelectionCell", for: indexPath) as! CardSelectionCell
        
        let item = data[indexPath.row]
        
        cell.loadData(data: item)
        cell.isSelectedState = (indexPath.row == selectedIndex)
        
        configureCell(cell)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
        
        selectedIndex = indexPath.item
        delegate?.didSelectCardSelection(at: selectedIndex ?? 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((collectionView.frame.width - 40) / 2), height: 50)
    }
}
