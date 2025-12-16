//
//  Untitled.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 04/12/25.
//

import UIKit

@IBDesignable
class SelectionCard: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBInspectable public var cardTitle: String = "Title" {
        didSet {
            lblTitle.text = cardTitle
        }
    }
    
    @IBInspectable public var cardDescription: String = "Description" {
        didSet {
            lblDesc.text = cardDescription
        }
    }
    
    @IBInspectable public var cardBackgroundColor: UIColor? = .white {
        didSet {
            containerView.backgroundColor = cardBackgroundColor
        }
    }
    
    @IBInspectable public var cardBorderWidth: CGFloat = 0.0 {
        didSet {
            containerView.layer.borderWidth = cardBorderWidth
        }
    }
    
    @IBInspectable public var cardBorderColor: UIColor = UIColor.blueDefault ?? .blue {
        didSet {
            containerView.layer.borderColor = cardBorderColor.cgColor
        }
    }
    
    @IBInspectable public var cardCornerRadius: CGFloat = 0.0 {
        didSet {
            containerView.layer.cornerRadius = cardCornerRadius
        }
    }
    
    @IBInspectable public var cardShadowOpacity: Float = 0.0 {
        didSet {
            containerView.layer.shadowOpacity = cardShadowOpacity
        }
    }
    
    @IBInspectable public var cardShadowOffset: CGSize = CGSize.zero {
        didSet {
            containerView.layer.shadowOffset = cardShadowOffset
        }
    }
    
    @IBInspectable public var cardShadowRadius: CGFloat = 0.0 {
        didSet {
            containerView.layer.shadowRadius = cardShadowRadius
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
        
//        containerStickPromoGift.layer.shadowOpacity = 0.15
//        containerStickPromoGift.layer.shadowOffset = CGSize(width: 0, height: 5)
//        containerStickPromoGift.layer.shadowRadius = 3
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("SelectionCard", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
        } else {
            print("Failed to load Chip XIB")
        }
    }
    
}
