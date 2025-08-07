//
//  TabPromoCell.swift
//  KlikIDM-DS-UiKit
//
//  Created by Rizka Ghinna Auliya on 26/05/25.
//

import UIKit

class TabQuadRoundCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var vTab: UIView!
    @IBOutlet var vTabBackground: UIView!
    @IBOutlet var lblTab: UILabel!
    @IBOutlet var badgeTab: UIView!
    @IBOutlet var lblBadge: UILabel!
    @IBOutlet var vShadow: UIView!
    
    @IBOutlet var vWidthConstraint: NSLayoutConstraint!
    @IBOutlet var vHeightConstraint: NSLayoutConstraint!
    
    var shouldUseEqualWidth: Bool = false
    var customWidth: CGFloat = 86
    var totalTabCount: Int = 0

    var isSelectedState: Bool = false { didSet { updateAppearanceIfNeeded() } }
    var isBeforeSelectedState: Bool = false { didSet { updateAppearanceIfNeeded() } }
    var isAfterSelectedState: Bool = false { didSet { updateAppearanceIfNeeded() } }
    var isFirstItem: Bool = false { didSet { updateAppearanceIfNeeded() } }
    var isLastItem: Bool = false { didSet { updateAppearanceIfNeeded() } }

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
        loadNibIfNeeded()
        setupUI()
    }

    private func loadNibIfNeeded() {
        let bundle = Bundle(for: type(of: self))
        guard let nib = bundle.loadNibNamed("TabQuadRoundCell", owner: self, options: nil),
              let view = nib.first as? UIView else {
            print("Failed to load TabQuadRoundCell nib")
            return
        }
        
        containerView = view
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func setupUI() {
        vTabBackground.backgroundColor = UIColor.blue20
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
    }
    
    private func updateAppearanceIfNeeded() {
        setupBackground()
    }

    private func setupBackground() {
        clearPreviousEffects()
        self.layer.zPosition = isSelectedState ? 1 : 0

        if shouldUseEqualWidth {
            setupFixedTab()
        } else {
            setupScrollableTab()
        }
    }

    private func clearPreviousEffects() {
        vTab.layer.sublayers?.filter { $0.name == "innerBottomShadow" }.forEach { $0.removeFromSuperlayer() }
        vShadow.layer.shadowRadius = 0
    }

    private func setupFixedTab() {
        setBaseColors()
        
        if isSelectedState {
            selectedFixedTab()
        } else if isBeforeSelectedState {
            beforeSelectedFixedTab()
        } else if isAfterSelectedState {
            afterSelectedFixedTab()
        } else {
            unselectedFixedTab()
        }
        
        updateLayout()
        setupFirstLastCorner()
    }

    private func selectedFixedTab() {
        lblTab.textColor = UIColor.blue50
        lblTab.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        badgeTab.backgroundColor = UIColor.blue50
        vTab.backgroundColor = UIColor.white
        
        setupCornerMask(for: vTab, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        vHeightConstraint.constant = Constants.selectedHeight
        vTabBackground.backgroundColor = UIColor.blue20
        applyShadow()
    }

    private func beforeSelectedFixedTab() {
        vTab.backgroundColor = UIColor.blue20
        vTabBackground.backgroundColor = UIColor.white
        addInnerBottomShadow(with: .layerMaxXMaxYCorner)
        
        if totalTabCount == 2 {
            setupCornerMask(for: vTab, corners: [.layerMaxXMaxYCorner, .layerMinXMinYCorner])
            setupCornerMask(for: vShadow, corners: [.layerMaxXMaxYCorner, .layerMinXMinYCorner])
        } else {
            setupCornerMask(for: vTab, corners: [.layerMaxXMaxYCorner])
            setupCornerMask(for: vShadow, corners: [.layerMaxXMaxYCorner])
        }
    }

    private func afterSelectedFixedTab() {
        vTab.backgroundColor = UIColor.blue20
        vTabBackground.backgroundColor = UIColor.white
        addInnerBottomShadow(with: .layerMinXMaxYCorner)
        
        if totalTabCount == 2 {
            setupCornerMask(for: vTab, corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner])
            setupCornerMask(for: vShadow, corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner])
        } else {
            setupCornerMask(for: vTab, corners: [.layerMinXMaxYCorner])
            setupCornerMask(for: vShadow, corners: [.layerMinXMaxYCorner])
        }
    }

    private func unselectedFixedTab() {
        lblTab.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        vTab.backgroundColor = UIColor.blue20
        vTabBackground.backgroundColor = UIColor.blue20
        vHeightConstraint.constant = Constants.unselectedHeight
        setupCornerMask(for: vTab, corners: [])
        setupCornerMask(for: vShadow, corners: [])
        addInnerBottomShadow(with: [])
    }

    private func setupScrollableTab() {
        if isSelectedState {
            selectedScrollableTab()
        } else if isBeforeSelectedState {
            beforeSelectedScrollableTab()
        } else if isAfterSelectedState {
            afterSelectedScrollableTab()
        } else {
            unselectedScrollableTab()
        }
        
        setupFirstLastCorner()
    }

    private func selectedScrollableTab() {
        lblTab.textColor = UIColor.blue50
        lblTab.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        badgeTab.backgroundColor = UIColor.blue50
        vTab.backgroundColor = UIColor.white
        
        setupCornerMask(for: vTab, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        vTabBackground.backgroundColor = UIColor.blue20
        updateTabSize(Constants.selectedWidth, Constants.selectedHeight)
        applyShadow()
    }

    private func beforeSelectedScrollableTab() {
        setUnselectedColors()
        vTab.backgroundColor = UIColor.blue20
        setupCornerMask(for: vTab, corners: [.layerMaxXMaxYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMaxXMaxYCorner])
        vTabBackground.backgroundColor = UIColor.white
        updateTabSize(Constants.unselectedWidth, Constants.unselectedHeight)
        addInnerBottomShadow(with: .layerMaxXMaxYCorner)
    }

    private func afterSelectedScrollableTab() {
        setUnselectedColors()
        vTab.backgroundColor = UIColor.blue20
        setupCornerMask(for: vTab, corners: [.layerMinXMaxYCorner])
        setupCornerMask(for: vShadow, corners: [.layerMinXMaxYCorner])
        vTabBackground.backgroundColor = UIColor.white
        updateTabSize(Constants.unselectedWidth, Constants.unselectedHeight)
        addInnerBottomShadow(with: .layerMinXMaxYCorner)
    }

    private func unselectedScrollableTab() {
        setUnselectedColors()
        vTab.backgroundColor = UIColor.blue20
        setupCornerMask(for: vTab, corners: [])
        setupCornerMask(for: vShadow, corners: [])
        vShadow.backgroundColor = UIColor.blue20
        vTabBackground.backgroundColor = UIColor.blue20
        updateTabSize(Constants.unselectedWidth, Constants.unselectedHeight)
        addInnerBottomShadow(with: [])
    }

    private func setBaseColors() {
        lblTab.textColor = isSelectedState ? UIColor.blue50 : UIColor.grey50
        badgeTab.backgroundColor = isSelectedState ? UIColor.blue50 : UIColor.grey50
    }

    private func setUnselectedColors() {
        lblTab.textColor = UIColor.grey50
        lblTab.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        badgeTab.backgroundColor = UIColor.grey50
    }

    private func setupCornerMask(for view: UIView, corners: CACornerMask) {
        view.layer.cornerRadius = corners.isEmpty ? 0 : Constants.cornerRadius
        view.layer.maskedCorners = corners
    }

    private func applyShadow() {
        vShadow.layer.shadowColor = UIColor.black?.cgColor
        vShadow.layer.shadowOpacity = Constants.shadowOpacity
        vShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        vShadow.layer.shadowRadius = Constants.shadowRadius
        vShadow.layer.masksToBounds = false
        vTab.layer.masksToBounds = false
    }

    private func updateLayout() {
        vWidthConstraint.constant = customWidth
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    private func setupFirstLastCorner() {
        if totalTabCount == 2 {
            if isFirstItem {
                setupCornerMask(for: vTabBackground, corners: [.layerMinXMinYCorner])
            } else if isLastItem {
                setupCornerMask(for: vTabBackground, corners: [.layerMaxXMinYCorner])
            }
        } else {
            if isFirstItem && isLastItem {
                setupCornerMask(for: vTabBackground, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            } else if isFirstItem {
                setupCornerMask(for: vTabBackground, corners: [.layerMinXMinYCorner])
            } else if isLastItem {
                setupCornerMask(for: vTabBackground, corners: [.layerMaxXMinYCorner])
            } else {
                setupCornerMask(for: vTabBackground, corners: [])
            }
        }
    }

    private func addInnerBottomShadow(with corners: CACornerMask) {
        let shadowLayer = CAGradientLayer()
        shadowLayer.name = "innerBottomShadow"
        shadowLayer.frame = vTab.bounds
        
        let shadowColor = UIColor.black?.withAlphaComponent(CGFloat(Constants.innerShadowOpacity)).cgColor ?? UIColor.gray.cgColor
        let clearColor = UIColor.clear.cgColor
        
        shadowLayer.colors = [clearColor, shadowColor]
        shadowLayer.locations = [0.85, 1.0]
        shadowLayer.cornerRadius = Constants.cornerRadius
        shadowLayer.maskedCorners = corners
        shadowLayer.zPosition = -1
        
        vTab.layer.addSublayer(shadowLayer)
        vTab.layer.masksToBounds = true
    }

    func setEqualWidth(_ width: CGFloat) {
        customWidth = width
        vWidthConstraint.constant = width
        
        if shouldUseEqualWidth {
            layoutIfNeeded()
        }
    }

    func loadData(data: TabQuadRoundModel) {
        lblTab.text = data.title
        lblBadge.text = "\(data.badge)"
        badgeTab.isHidden = data.badge <= 0
        setupBackground()
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

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if shouldUseEqualWidth {
            attributes.size.width = customWidth
        }
        
        return attributes
    }
}
