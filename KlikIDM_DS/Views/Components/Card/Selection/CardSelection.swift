//
//  Untitled.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 04/12/25.
//

import UIKit

@IBDesignable
public class CardSelection: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBInspectable public var cardTitle: String? {
        didSet {
            lblTitle.text = cardTitle
        }
    }
    
    @IBInspectable public var cardDescription: String? {
        didSet {
            lblDesc.text = cardDescription
        }
    }
    
    @IBInspectable public var cardTitleColor: UIColor? {
        didSet {
            lblTitle.textColor = cardTitleColor
        }
    }
    
    @IBInspectable public var cardDescColor: UIColor? {
        didSet {
            lblDesc.textColor = cardDescColor
        }
    }
    
    @IBInspectable public var cardBackgroundColor: UIColor? {
        didSet {
            containerView.backgroundColor = cardBackgroundColor
        }
    }
    
    @IBInspectable public var cardBorderWidth: CGFloat = 0.0 {
        didSet {
            containerView.layer.borderWidth = cardBorderWidth
        }
    }
    
    @IBInspectable public var cardBorderColor: UIColor? = UIColor.blueDefault {
        didSet {
            containerView.layer.borderColor = cardBorderColor?.cgColor
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
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupNib()
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("CardSelection", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        } else {
            print("Failed to load Card Selection XIB")
        }
    }
    
    public func animateCardSelection(
        fromBorderColor: UIColor?,
        toBorderColor: UIColor?,
        toBackgroundColor: UIColor?,
        animated: Bool = true
    ) {
        let animationDuration: TimeInterval = 0.3
        
        let borderAnimation = CABasicAnimation(keyPath: "borderColor")
        borderAnimation.fromValue = fromBorderColor?.cgColor
        borderAnimation.toValue = toBorderColor?.cgColor
        borderAnimation.duration = animationDuration
        borderAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        containerView.layer.add(borderAnimation, forKey: "borderAnimation")
        containerView.layer.borderColor = toBorderColor?.cgColor
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
            self.containerView.backgroundColor = toBackgroundColor
        }
    }
}
