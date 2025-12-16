//
//  TabPromoCell.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 26/05/25.
//

import UIKit

public class TabQuadRoundCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var vTab: UIView!
    @IBOutlet weak var vTabBackground: UIView!
    @IBOutlet weak var lblTab: UILabel!
    @IBOutlet weak var badgeTab: UIView!
    @IBOutlet weak var lblBadge: UILabel!
    @IBOutlet weak var vShadow: UIView!
    
    @IBOutlet weak var vWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var vHeightConstraint: NSLayoutConstraint!
    
    public var tabBackgroundColor: UIColor? {
        didSet { updateBackgroundColor() }
    }
    
    public var tabBackgroundActiveColor: UIColor? {
        didSet { updateBackgroundColor() }
    }
    
    public var tabTextColor: UIColor? {
        didSet { updateTextColor() }
    }
    
    public var tabTextActiveColor: UIColor? {
        didSet { updateTextColor() }
    }
    
    public var tabBadgeColor: UIColor? {
        didSet { updateTextColor() }
    }
    
    public var tabBadgeActiveColor: UIColor? {
        didSet { updateTextColor() }
    }
    
    public var tabBadgeTextColor: UIColor? {
        didSet { updateBadgeColor() }
    }
    
    public var tabBadgeTextActiveColor: UIColor? {
        didSet { updateBadgeTextColor() }
    }
    
    public var isSelectedState: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var isBeforeSelectedState: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var isAfterSelectedState: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var isFirstItem: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var isLastItem: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var shouldUseEqualWidth: Bool = false
    public var customWidth: CGFloat = 86
    public var totalTabCount: Int = 0
    
    private var isEnable: Bool = true
    private let animationDuration: TimeInterval = 0.2
    private let shadowAnimationDuration: TimeInterval = 0.3
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let selectedHeight: CGFloat = 32
        static let unselectedHeight: CGFloat = 28
        static let selectedWidth: CGFloat = 150
        static let unselectedWidth: CGFloat = 86
        static let shadowOpacity: Float = 0.15
        static let shadowRadius: CGFloat = 2
        static let innerShadowOpacity: Float = 0.05
        static let selectedFontSize: CGFloat = 12
        static let unselectedFontSize: CGFloat = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabQuadRound()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabQuadRound()
    }
    
    private func setupTabQuadRound() {
        setupNib()
    }
    
    private func setupNib() {
        let bundle = Bundle(for: type(of: self))
        guard let nib = bundle.loadNibNamed("TabQuadRoundCell", owner: self, options: nil),
              let view = nib.first as? UIView else {
            print("Failed to load TabQuadRoundCell nib")
            return
        }
        
        containerView = view
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(containerView)
        
        setupUI()
    }
    
    private func setupUI() {
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
    }
    
    public func loadData(data: TabQuadRoundModel) {
        lblTab.text = data.title
        lblBadge.text = "\(data.badge)"
        badgeTab.isHidden = data.badge <= 0
        setupBackground()
    }
    
    public func setEqualWidth(_ width: CGFloat) {
        customWidth = width
        vWidthConstraint.constant = width
        
        if shouldUseEqualWidth {
            layoutIfNeeded()
        }
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if shouldUseEqualWidth {
            attributes.size.width = customWidth
        }
        
        return attributes
    }
    
    private func updateAppearance() {
        setupBackground()
    }
    
    private func updateBackgroundColor() {
        if isSelectedState {
            vTabBackground.backgroundColor = tabBackgroundActiveColor
        } else {
            vTabBackground.backgroundColor = tabBackgroundColor
        }
    }
    
    private func updateTextColor() {
        lblTab.textColor = isSelectedState ? tabTextActiveColor : tabTextColor
    }
    
    private func updateBadgeColor() {
        badgeTab.backgroundColor = isSelectedState ? tabBadgeActiveColor : tabBadgeColor
    }
    
    private func updateBadgeTextColor() {
        lblBadge.textColor = isSelectedState ? tabBadgeTextActiveColor : tabBadgeTextColor
    }
    
    private func setupBackground() {
        clearEffects()
        layer.zPosition = isSelectedState ? 1 : 0
        
        if shouldUseEqualWidth {
            setupFixedTab()
        } else {
            setupScrollableTab()
        }
    }
    
    private func clearEffects() {
        vTab.layer.sublayers?.filter { $0.name == "innerBottomShadow" }.forEach { $0.removeFromSuperlayer() }
        vShadow.layer.shadowRadius = 0
    }
    
    private func setupFixedTab() {
        setBaseColors()
        
        switch (isSelectedState, isBeforeSelectedState, isAfterSelectedState) {
        case (true, _, _):
            configureSelectedFixedTab()
        case (_, true, _):
            configureBeforeSelectedFixedTab()
        case (_, _, true):
            configureAfterSelectedFixedTab()
        default:
            configureUnselectedFixedTab()
        }
        
        updateLayout()
        setupFirstLastCorner()
    }
    
    private func configureSelectedFixedTab() {
        lblTab.font = UIFont.systemFont(ofSize: Constants.selectedFontSize, weight: .semibold)
        lblTab.textColor = tabTextActiveColor
        badgeTab.backgroundColor = tabBadgeActiveColor
        lblBadge.textColor = tabBadgeTextActiveColor
        vTab.backgroundColor = tabBackgroundActiveColor
        vTabBackground.backgroundColor = tabBackgroundColor
        vHeightConstraint.constant = Constants.selectedHeight
        
        setupCornerMask(for: vTab, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        applyShadow()
    }
    
    private func configureBeforeSelectedFixedTab() {
        vTab.backgroundColor = tabBackgroundColor
        vTabBackground.backgroundColor = tabBackgroundActiveColor
        
        let corners: CACornerMask = totalTabCount == 2
            ? [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
            : [.layerMaxXMaxYCorner]
        
        setupCornerMask(for: vTab, corners: corners)
        setupCornerMask(for: vShadow, corners: corners)
        addInnerBottomShadow(with: .layerMaxXMaxYCorner)
    }
    
    private func configureAfterSelectedFixedTab() {
        vTab.backgroundColor = tabBackgroundColor
        vTabBackground.backgroundColor = tabBackgroundActiveColor
        
        let corners: CACornerMask = totalTabCount == 2
            ? [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
            : [.layerMinXMaxYCorner]
        
        setupCornerMask(for: vTab, corners: corners)
        setupCornerMask(for: vShadow, corners: corners)
        addInnerBottomShadow(with: .layerMinXMaxYCorner)
    }
    
    private func configureUnselectedFixedTab() {
        lblTab.font = UIFont.systemFont(ofSize: Constants.unselectedFontSize, weight: .medium)
        lblTab.textColor = tabTextActiveColor
        vTab.backgroundColor = tabBackgroundColor
        vTabBackground.backgroundColor = tabBackgroundColor
        vHeightConstraint.constant = Constants.unselectedHeight
        
        setupCornerMask(for: vTab, corners: [])
        setupCornerMask(for: vShadow, corners: [])
        addInnerBottomShadow(with: [])
    }
    
    private func setupScrollableTab() {
        switch (isSelectedState, isBeforeSelectedState, isAfterSelectedState) {
        case (true, _, _):
            configureSelectedScrollableTab()
        case (_, true, _):
            configureBeforeSelectedScrollableTab()
        case (_, _, true):
            configureAfterSelectedScrollableTab()
        default:
            configureUnselectedScrollableTab()
        }
        
        setupFirstLastCorner()
    }
    
    private func configureSelectedScrollableTab() {
        lblTab.font = UIFont.systemFont(ofSize: Constants.selectedFontSize, weight: .semibold)
        lblTab.textColor = tabTextActiveColor
        badgeTab.backgroundColor = tabBadgeActiveColor
        lblBadge.textColor = tabBadgeTextActiveColor
        vTab.backgroundColor = tabBackgroundActiveColor
        vTabBackground.backgroundColor = tabBackgroundColor
        
        setupCornerMask(for: vTab, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        updateTabSize(Constants.selectedWidth, Constants.selectedHeight)
        applyShadow()
    }
    
    private func configureBeforeSelectedScrollableTab() {
        setUnselectedColors()
        vTab.backgroundColor = tabBackgroundColor
        vTabBackground.backgroundColor = tabBackgroundActiveColor
        
        setupCornerMask(for: vTab, corners: [.layerMaxXMaxYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMaxXMaxYCorner])
        updateTabSize(Constants.unselectedWidth, Constants.unselectedHeight)
        addInnerBottomShadow(with: .layerMaxXMaxYCorner)
    }
    
    private func configureAfterSelectedScrollableTab() {
        setUnselectedColors()
        vTab.backgroundColor = tabBackgroundColor
        vTabBackground.backgroundColor = tabBackgroundActiveColor
        
        setupCornerMask(for: vTab, corners: [.layerMinXMaxYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMinXMaxYCorner])
        updateTabSize(Constants.unselectedWidth, Constants.unselectedHeight)
        addInnerBottomShadow(with: .layerMinXMaxYCorner)
    }
    
    private func configureUnselectedScrollableTab() {
        setUnselectedColors()
        vTab.backgroundColor = tabBackgroundColor
        vTabBackground.backgroundColor = tabBackgroundColor
        vShadow.backgroundColor = .blue20
        
        setupCornerMask(for: vTab, corners: [])
        setupCornerMask(for: vShadow, corners: [])
        updateTabSize(Constants.unselectedWidth, Constants.unselectedHeight)
        addInnerBottomShadow(with: [])
    }
    
    private func setBaseColors() {
        lblTab.textColor = isSelectedState ? tabTextActiveColor : tabTextColor
        badgeTab.backgroundColor = isSelectedState ? tabBadgeActiveColor : tabBadgeColor
        lblBadge.textColor = isSelectedState ? tabBadgeTextActiveColor : tabBadgeTextColor
    }
    
    private func setUnselectedColors() {
        lblTab.font = UIFont.systemFont(ofSize: Constants.unselectedFontSize, weight: .medium)
        lblTab.textColor = tabTextColor
        badgeTab.backgroundColor = tabBadgeColor
        lblBadge.textColor = tabBadgeTextColor
    }
    
    private func setupCornerMask(for view: UIView, corners: CACornerMask) {
        view.layer.cornerRadius = corners.isEmpty ? 0 : Constants.cornerRadius
        view.layer.maskedCorners = corners
    }
    
    private func applyShadow() {
        vShadow.layer.shadowColor = UIColor.black?.cgColor
        vShadow.layer.shadowOpacity = Constants.shadowOpacity
        vShadow.layer.shadowOffset = .zero
        vShadow.layer.shadowRadius = Constants.shadowRadius
        vShadow.layer.masksToBounds = false
        vTab.layer.masksToBounds = false
    }
    
    private func addInnerBottomShadow(with corners: CACornerMask) {
        let shadowLayer = CAGradientLayer()
        shadowLayer.name = "innerBottomShadow"
        shadowLayer.frame = vTab.bounds
        shadowLayer.cornerRadius = Constants.cornerRadius
        shadowLayer.maskedCorners = corners
        shadowLayer.zPosition = -1
        
        let shadowColor = UIColor.black?.withAlphaComponent(CGFloat(Constants.innerShadowOpacity)).cgColor
        shadowLayer.colors = [UIColor.clear.cgColor, shadowColor ?? UIColor.systemBlue]
        shadowLayer.locations = [0.85, 1.0]
        
        vTab.layer.addSublayer(shadowLayer)
        vTab.layer.masksToBounds = true
    }
    
    private func updateLayout() {
        vWidthConstraint.constant = customWidth
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    private func updateTabSize(_ width: CGFloat, _ height: CGFloat) {
        vWidthConstraint.constant = width
        vHeightConstraint.constant = height
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
            
            if self.isSelectedState {
                let cornerRadii = CGSize(width: Constants.cornerRadius, height: Constants.cornerRadius)
                let corners: UIRectCorner = [.topLeft, .topRight]
                self.vTab.layer.shadowPath = UIBezierPath(
                    roundedRect: self.vTab.bounds,
                    byRoundingCorners: corners,
                    cornerRadii: cornerRadii
                ).cgPath
            }
        }
    }
    
    private func setupFirstLastCorner() {
        var corners: CACornerMask = []
        
        if totalTabCount == 2 {
            if isFirstItem {
                corners = [.layerMinXMinYCorner]
            } else if isLastItem {
                corners = [.layerMaxXMinYCorner]
            }
        } else {
            if isFirstItem && isLastItem {
                corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if isFirstItem {
                corners = [.layerMinXMinYCorner]
            } else if isLastItem {
                corners = [.layerMaxXMinYCorner]
            }
        }
        
        setupCornerMask(for: vTabBackground, corners: corners)
    }
}
