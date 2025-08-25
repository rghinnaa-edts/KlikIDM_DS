//
//  ExtensionView.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 06/08/25.
//

import UIKit

extension UIView {
    func setGradientBackground(_ gradient: UIColor.UIKitGradient) {
        layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradient.colors.map { $0.cgColor }
        gradientLayer.startPoint = gradient.startPoint.cgPoint
        gradientLayer.endPoint = gradient.endPoint.cgPoint
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
