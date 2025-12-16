//
//  ButtonStepper.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 09/12/25.
//

import UIKit

@IBDesignable
public class ButtonStepper: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var containerBackground: UIView!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var ivShow: UIImageView!
    @IBOutlet weak var btnShow: UIView!
    @IBOutlet weak var vStepper: UIView!
    
    @IBInspectable public var textQuantity: Int = 0 {
        didSet {
            lblQty.text = "\(textQuantity)"
        }
    }
    
    @IBInspectable public var textQuantityMultiple: Int = 1 {
        didSet {
            qtyMultipe = textQuantityMultiple
        }
    }
    
    @IBInspectable public var textQuantityColor: UIColor? {
        didSet {
            lblQty.textColor = textQuantityColor
        }
    }
    
    @IBInspectable public var bgColor: UIColor? {
        didSet {
            containerBackground.backgroundColor = bgColor
        }
    }
    
    @IBInspectable public var btnMinusColor: UIColor? {
        didSet {
            setupButtonMinus()
        }
    }
    
    @IBInspectable public var btnMinusBackgroundColor: UIColor? {
        didSet {
            btnMinus.backgroundColor = btnMinusBackgroundColor
        }
    }
    
    @IBInspectable public var btnPlusColor: UIColor? {
        didSet {
            setupButtonPlus()
        }
    }
    
    @IBInspectable public var btnPlusBackgroundColor: UIColor? {
        didSet {
            btnPlus.backgroundColor = btnPlusBackgroundColor
        }
    }
    
    @IBInspectable public var btnCollapseColor: UIColor? {
        didSet {
            ivShow.image?.withRenderingMode(.alwaysTemplate)
            ivShow.tintColor = btnCollapseColor
        }
    }
    
    @IBInspectable public var btnCollapseBackgroundColor: UIColor? {
        didSet {
            btnShow.backgroundColor = btnCollapseBackgroundColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            containerBackground.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            containerBackground.layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable public var cardCornerRadius: CGFloat = 0.0 {
        didSet {
            containerBackground.layer.cornerRadius = cardCornerRadius
        }
    }
    
    @IBInspectable public var isCollapsible: Bool = false {
        didSet {
            setupStepperVisibility()
        }
    }
  
    public weak var delegate: ButtonStepperDelegate?
        
    private var qtyMultipe: Int = 1
    private var isExpanded: Bool = false
    private var collapsedWidth: CGFloat = 0
    private var expandedWidth: CGFloat = 0
    
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
        if let nib = bundle.loadNibNamed("ButtonStepper", owner: self, options: nil),
           let view = nib.first as? UIView {
            
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            setupUI()
        }
    }
    
    private func setupUI() {
        setupButtonShow()
        
        containerBackground.layer.cornerRadius = containerView.frame.height / 2
        
        btnPlus.layer.cornerRadius = btnPlus.frame.height / 2
        btnMinus.layer.cornerRadius = btnMinus.frame.height / 2
        
        btnPlus.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
        btnPlus.contentVerticalAlignment = .center
        btnPlus.contentHorizontalAlignment = .center
    }
    
    private func setupButtonShow() {
        btnShow.layer.cornerRadius = (btnShow.frame.height - 32) / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(btnShowTapped))
        btnShow.addGestureRecognizer(tapGesture)
        btnShow.isUserInteractionEnabled = true
    }
    
    private func setupButtonMinus() {
        btnMinus.titleEdgeInsets = .zero
        btnMinus.setTitleColor(btnMinusColor, for: .normal)
        btnMinus.setTitleColor(.lightGray, for: .highlighted)
        btnMinus.setTitleColor(.gray, for: .disabled)
    }
    
    private func setupButtonPlus() {
        btnPlus.titleEdgeInsets = .zero
        btnPlus.setTitleColor(btnPlusColor, for: .normal)
        btnPlus.setTitleColor(.lightGray, for: .highlighted)
        btnPlus.setTitleColor(.gray, for: .disabled)
    }
    
    private func setupStepperVisibility() {
        if isCollapsible {
            btnShow.isHidden = false
            btnMinus.isHidden = true
            lblQty.isHidden = true
            btnPlus.isHidden = true
            containerBackground.isHidden = true
            isExpanded = false
            
            DispatchQueue.main.async {
                self.collapsedWidth = self.btnShow.frame.width
                self.expandedWidth = self.containerBackground.frame.width
                
                self.containerBackground.transform = CGAffineTransform(scaleX: self.collapsedWidth / self.expandedWidth, y: 1.0)
            }
        } else {
            btnShow.isHidden = true
            btnMinus.isHidden = false
            lblQty.isHidden = false
            btnPlus.isHidden = false
            containerBackground.isHidden = false
            isExpanded = true
        }
    }
    
    private func showStepperWithAnimation() {
        guard isCollapsible else { return }
        
        btnMinus.isHidden = false
        lblQty.isHidden = false
        btnPlus.isHidden = false
        containerBackground.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.containerBackground.transform = .identity
            
            self.btnShow.isHidden = true
            self.btnShow.alpha = 0
            
            self.btnMinus.alpha = 1
            self.lblQty.alpha = 1
            self.btnPlus.alpha = 1
            self.containerBackground.alpha = 1
            
            self.layoutIfNeeded()
        } completion: { _ in
            self.isExpanded = true
        }
    }
    
    private func hideStepperWithAnimation() {
        guard isCollapsible else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.containerBackground.transform = CGAffineTransform(scaleX: self.collapsedWidth / self.expandedWidth, y: 1.0)
            
            self.btnMinus.alpha = 0
            self.lblQty.alpha = 0
            self.btnPlus.alpha = 0
            self.containerBackground.alpha = 0
            
            self.btnShow.isHidden = false
            self.btnShow.alpha = 1
            
            self.layoutIfNeeded()
        } completion: { _ in
            self.btnMinus.isHidden = true
            self.lblQty.isHidden = true
            self.btnPlus.isHidden = true
            self.containerBackground.isHidden = true
            
            self.isExpanded = false
        }
    }
    
    @objc private func btnShowTapped() {
        if !isExpanded {
            showStepperWithAnimation()
            textQuantity = 1
            lblQty.text = "\(textQuantity)"
            delegate?.didSelectButtonCollapsible(show: true)
        } else {
            hideStepperWithAnimation()
            delegate?.didSelectButtonCollapsible(show: false)
        }
    }
    
    @IBAction func btnMinus(_ sender: Any) {
        let qty = Int(lblQty.text ?? "") ?? 0
        if qty > 0 {
            textQuantity = qty - qtyMultipe
            lblQty.text = "\(textQuantity)"
            
            delegate?.didSelectButtonMinus(qty: textQuantity)
        }
        
        if isCollapsible {
            if qty <= 1 {
                hideStepperWithAnimation()
            }
        }
    }
    
    @IBAction func btnPlus(_ sender: Any) {
        let qty = Int(lblQty.text ?? "") ?? 0
        textQuantity = qty + qtyMultipe
        lblQty.text = "\(textQuantity)"
        
        delegate?.didSelectButtonPlus(qty: textQuantity)
    }
}

@MainActor
public protocol ButtonStepperDelegate: AnyObject {
    func didSelectButtonCollapsible(show isShow: Bool)
    func didSelectButtonMinus(qty quantity: Int)
    func didSelectButtonPlus(qty quantity: Int)
}
