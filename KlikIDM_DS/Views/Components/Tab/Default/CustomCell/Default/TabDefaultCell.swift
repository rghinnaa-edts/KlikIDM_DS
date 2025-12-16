//
//  TabDefaultCell.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 16/05/25.
//

import UIKit

public class TabDefaultCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTab: UILabel!
    @IBOutlet weak var vIndicator: UIView!
    
    public var isSelectedState: Bool = false {
        didSet {
            setupTextColor()
            setupIndicator()
        }
    }
    
    public var tabIndicatorColor: UIColor? = UIColor.blue50 {
        didSet {
            vIndicator.backgroundColor = tabIndicatorColor
        }
    }
    
    public var tabTextColor: UIColor? = UIColor.blue50 {
        didSet {
            setupTextColor()
        }
    }
    
    public var tabTextActiveColor: UIColor? = UIColor.blue50 {
        didSet {
            setupTextColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTab()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTab()
    }
    
    private func setupTab() {
        let bundle = Bundle(for: type(of: self))
        if let nib = bundle.loadNibNamed("TabDefaultCell", owner: self, options: nil),
           let view = nib.first as? UIView {
            containerView = view
            addSubview(containerView)
            containerView.frame = bounds
            containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        } else {
            print("Failed to load TabDefaultCell nib")
        }
        
        setupUI()
    }
    
    private func setupUI() {
        setupTextColor()
        setupIndicator()
    }
    
    private func setupTextColor() {
        if isSelectedState {
            lblTab.textColor = tabTextActiveColor
        } else {
            lblTab.textColor = tabTextColor
        }
    }
    
    private func setupIndicator() {
        vIndicator.layer.cornerRadius = 2
        vIndicator.isHidden = !isSelectedState
    }
    
    func loadData(_ data: TabDefaultModel) {
        lblTab.text = data.title
    }
}

extension TabDefaultCell: TabDefaultCellProtocol {
    public func loadData(item: TabDefaultModelProtocol) {
        if let data = item as? TabDefaultModel {
            loadData(data)
        } else {
            let data = TabDefaultModel(
                id: item.id,
                title: ""
            )
            loadData(data)
        }
    }
}
