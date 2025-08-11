//
//  Untitled.swift
//  KlikIDM-DS-UiKit
//
//  Created by Rizka Ghinna Auliya on 15/05/25.
//

import UIKit

class PromoContentCell: UICollectionViewCell {
    
    static let identifier = String(describing: PromoContentCell.self)
    
    @IBOutlet var imgBanner: UIImageView!
    @IBOutlet var lblTitleBanner: UILabel!
    @IBOutlet var lblSeeFair: UILabel!
    
    func setup(_ data: PromoContentModel) {
        if let image = data.banner {
            imgBanner.image = image
            imgBanner.contentMode = .scaleAspectFill
        }
        lblTitleBanner.text = data.title
        
        lblSeeFair.isHidden = !data.isEnable
    }
    
}
