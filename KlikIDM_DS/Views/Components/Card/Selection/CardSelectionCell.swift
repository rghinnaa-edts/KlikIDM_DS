//
//  CardSelectionCell.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/12/25.
//

import UIKit

public class CardSelectionCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var cardSelection: CardSelection!
    
    public var cardTitleColor: UIColor? {
        didSet {
            if !isSelectedState {
                cardSelection.lblTitle.textColor = cardTitleColor
            }
        }
    }
    
    public var cardTitleActiveColor: UIColor? {
        didSet {
            if isSelectedState {
                cardSelection.lblTitle.textColor = cardTitleActiveColor
            }
        }
    }
    
    public var cardDescColor: UIColor? {
        didSet {
            if !isSelectedState {
                cardSelection.lblDesc.textColor = cardDescColor
            }
        }
    }
    
    public var cardDescActiveColor: UIColor? {
        didSet {
            if isSelectedState {
                cardSelection.lblDesc.textColor = cardDescActiveColor
            }
        }
    }
    
    public var cardBackgroundColor: UIColor? {
        didSet {
            if !isSelectedState {
                cardSelection.containerView.backgroundColor = cardBackgroundColor
            }
        }
    }
    
    public var cardBackgroundActiveColor: UIColor? {
        didSet {
            if isSelectedState {
                cardSelection.containerView.backgroundColor = cardBackgroundActiveColor
            }
        }
    }
    
    public var cardBorderWidth: CGFloat = 0.0 {
        didSet {
            cardSelection.containerView.layer.borderWidth = cardBorderWidth
        }
    }
    
    public var cardBorderColor: UIColor? = UIColor.systemBlue {
        didSet {
            if !isSelectedState {
                cardSelection.containerView.layer.borderColor = cardBorderColor?.cgColor
            }
        }
    }
    
    public var cardBorderActiveColor: UIColor? = UIColor.systemBlue {
        didSet {
            if isSelectedState {
                cardSelection.containerView.layer.borderColor = cardBorderActiveColor?.cgColor
            }
        }
    }
    
    public var cardCornerRadius: CGFloat = 0.0 {
        didSet {
            cardSelection.containerView.layer.cornerRadius = cardCornerRadius
        }
    }
    
    public var cardShadowOpacity: Float = 0.0 {
        didSet {
            cardSelection.containerView.layer.shadowOpacity = cardShadowOpacity
        }
    }
    
    public var cardShadowOffset: CGSize = CGSize.zero {
        didSet {
            cardSelection.containerView.layer.shadowOffset = cardShadowOffset
        }
    }
    
    public var cardShadowRadius: CGFloat = 0.0 {
        didSet {
            cardSelection.containerView.layer.shadowRadius = cardShadowRadius
        }
    }
    
    private var previousSelectedState: Bool = false
    
    public var isSelectedState: Bool = false {
        didSet {
            let shouldAnimate = previousSelectedState != isSelectedState
            previousSelectedState = isSelectedState
            updateAppearance(animated: shouldAnimate)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    public func loadData(data: CardSelectionModel) {
        cardSelection.lblTitle.text = data.title
        cardSelection.lblDesc.text = data.description
    }
        
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("CardSelectionCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)
        }
    }
    
    private func updateAppearance(animated: Bool = true) {
        if isSelectedState {
            cardSelection.animateCardSelection(
                fromBorderColor: cardBorderColor,
                toBorderColor: cardBorderActiveColor,
                toBackgroundColor: cardBackgroundActiveColor,
                animated: animated
            )
        } else {
            cardSelection.animateCardSelection(
                fromBorderColor: cardBorderActiveColor,
                toBorderColor: cardBorderColor,
                toBackgroundColor: cardBackgroundColor,
                animated: animated
            )
        }
    }
}

public struct CardSelectionModel {
    var id: String
    var title: String
    var description: String
    
    public init(id: String, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
