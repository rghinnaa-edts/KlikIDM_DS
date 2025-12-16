//
//  ProductCardCell.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 10/02/25.
//

import UIKit

public class ProductCardCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerBackgroundView: UIView!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var ivBadgeGift: UIImageView!
    @IBOutlet weak var lblBadgeGift: UILabel!
    @IBOutlet weak var badgeGift: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var vDiscount: UIView!
    @IBOutlet weak var badgeDiscount: Badge!
    @IBOutlet weak var lblRealPrice: UILabel!
    @IBOutlet weak var badgePromo2: Badge!
    @IBOutlet weak var badgePromo3: Badge!
    @IBOutlet weak var vPointStamp: UIView!
    @IBOutlet weak var ivPoint: UIImageView!
    @IBOutlet weak var lblPoint: UILabel!
    @IBOutlet weak var ivStamp: UIImageView!
    @IBOutlet weak var lblStamp: UILabel!
    @IBOutlet weak var btnStepper: ButtonStepper!
    
    public var badgeGiftColor: UIColor? {
        didSet {
            badgeGift.backgroundColor = badgeGiftColor
        }
    }
    
    public var currentQuantity: Int {
        return productQty
    }
    
    public weak var delegate: ProductCartCellDelegate?
    
    private var productQty = 0
    
    private var discountConstraint: NSLayoutConstraint!
    private var realPriceConstraint: NSLayoutConstraint!
    private var badgePromo2Constraint: NSLayoutConstraint!
    private var badgePromo3Constraint: NSLayoutConstraint!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNib()
    }
    
    public func loadData(data: ProductCardModel) {
        ivProduct.image = data.image
        ivBadgeGift.image = data.iconGiftBadge
        lblBadgeGift.text = data.nameGiftBadge
        badgeGift.backgroundColor = data.bgGiftBadge
        lblName.text = data.name
        lblPrice.text = data.price.formatRupiah()
        lblRealPrice.attributedText = data.realPrice.formatRupiah().strikethrough()

        discountConstraint = badgeDiscount.heightAnchor.constraint(equalToConstant: 14)
        discountConstraint.isActive = true
        discountConstraint.constant = (data.discount == 0) ? 0 : 14
        
        realPriceConstraint = lblRealPrice.heightAnchor.constraint(equalToConstant: 14)
        realPriceConstraint.isActive = true
        realPriceConstraint.constant = (data.discount == 0) ? 0 : 14
        
        badgeDiscount.badgeBackgroundColor = UIColor.red10
        badgeDiscount.badgeTitleColor = UIColor.red30
        badgeDiscount.badgeTitle = "\(data.discount)%"
        
        badgePromo2Constraint = badgePromo2.heightAnchor.constraint(equalToConstant: 14)
        badgePromo2Constraint.isActive = true
        badgePromo2Constraint.constant = !data.badgePromo2 ? 0 : 14
        
        badgePromo3Constraint = badgePromo3.heightAnchor.constraint(equalToConstant: 14)
        badgePromo3Constraint.isActive = true
        badgePromo3Constraint.constant = !data.badgePromo3 ? 0 : 14
        
        vPointStamp.isHidden = data.point == 0 || data.stamp == 0
        var point = "\(data.point)"
        if data.point >= 100 {
            point = "+99"
        }
        var stamp = "\(data.stamp)"
        if data.stamp >= 100 {
            stamp = "+99"
        }
        lblPoint.text = point
        lblStamp.text = stamp
    }
    
    public func calculateHeight(for width: CGFloat) -> CGFloat {
        let widthConstraint = containerView.widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true
        
        let size = containerView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        widthConstraint.isActive = false
        
        return size.height
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("ProductCardCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(containerView)
            
            setupUI()
        } else {
            print("Failed to load ProductCardCell XIB")
        }
    }
    
    private func setupUI() {
        setupCard()
        setupBadgePromo2()
        setupBadgePromo3()
        setupButtonStepper()
    }
    
    private func setupCard() {
        containerView.backgroundColor = UIColor.red
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.grey30?.cgColor
    }
    
    private func setupBadgePromo2() {
        badgePromo2.badgeBackgroundColor = UIColor.red10
        badgePromo2.badgeTitleColor = UIColor.red30
        badgePromo2.badgeTitle = "Banyak Lebih Hemat"
    }
    
    private func setupBadgePromo3() {
        badgePromo3.badgeBackgroundColor = UIColor.warningWeak
        badgePromo3.badgeTitleColor = UIColor.warningStrong
        badgePromo3.badgeTitle = "Paket Bundling"
    }
    
    private func setupButtonStepper() {
        btnStepper.delegate = self
        
        productQty = 1
        
        btnStepper.textQuantity = productQty
        btnStepper.textQuantityMultiple = 1
        btnStepper.textQuantityColor = UIColor.white
        btnStepper.bgColor = UIColor.blue50
        btnStepper.btnMinusColor = UIColor.white
        btnStepper.btnMinusBackgroundColor = UIColor.blue50
        btnStepper.btnPlusColor = UIColor.blue50
        btnStepper.btnPlusBackgroundColor = UIColor.white
        btnStepper.btnCollapseColor = UIColor.white
        btnStepper.btnCollapseBackgroundColor = UIColor.blue50
        btnStepper.borderWidth = 0
        btnStepper.isCollapsible = true
    }
    
}

@MainActor
public protocol ProductCartCellDelegate: AnyObject {
    func didSelectButtonCollapsible(show isShow: Bool)
}

public struct ProductCardModel {
    var id: String
    var image: UIImage?
    var iconGiftBadge: UIImage?
    var nameGiftBadge: String
    var bgGiftBadge: UIColor?
    var name: String
    var price: Int
    var discount: Int
    var realPrice: Int
    var badgePromo2: Bool
    var badgePromo3: Bool
    var point: Int
    var stamp: Int

    public init(
    id: String,
    image: UIImage?,
    iconGiftBadge: UIImage?,
    nameGiftBadge: String,
    bgGiftBadge: UIColor?,
    name: String,
    price: Int,
    discount: Int,
    realPrice: Int,
    badgePromo2: Bool,
    badgePromo3: Bool,
    point: Int,
    stamp: Int) {
        self.id = id
        self.image = image
        self.iconGiftBadge = iconGiftBadge
        self.nameGiftBadge = nameGiftBadge
        self.bgGiftBadge = bgGiftBadge
        self.name = name
        self.price = price
        self.badgePromo2 = badgePromo2
        self.badgePromo3 = badgePromo3
        self.discount = discount
        self.realPrice = realPrice
        self.point = point
        self.stamp = stamp
    }

}

extension ProductCardCell: ButtonStepperDelegate {
    public func didSelectButtonCollapsible(show isShow: Bool) {
        delegate?.didSelectButtonCollapsible(show: isShow)
    }
    
    public func didSelectButtonMinus(qty quantity: Int) {
        productQty = quantity
    }
    
    public func didSelectButtonPlus(qty quantity: Int) {
        productQty = quantity
    }
}
