//
//  Badge.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/12/25.
//

import UIKit

@IBDesignable
public class Badge: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerBackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBInspectable public var badgeTitle: String? {
        didSet {
            lblTitle.text = badgeTitle
        }
    }
    
    @IBInspectable public var badgeTitleColor: UIColor? {
        didSet {
            lblTitle.textColor = badgeTitleColor
        }
    }
    
    @IBInspectable public var badgeBackgroundColor: UIColor? {
        didSet {
            containerBackground.backgroundColor = badgeBackgroundColor
        }
    }
    
    @IBInspectable public var badgeCornerRadius: CGFloat = 0.0 {
        didSet {
            containerBackground.layer.cornerRadius = badgeCornerRadius
        }
    }
    
    @IBInspectable public var badgeBorderWidth: CGFloat = 0.0 {
        didSet {
            containerBackground.layer.borderWidth = badgeBorderWidth
        }
    }
    
    @IBInspectable public var badgeBorderColor: UIColor? {
        didSet {
            containerBackground.layer.borderColor = badgeBorderColor?.cgColor
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
        if let nib = bundle.loadNibNamed("Badge", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
}
