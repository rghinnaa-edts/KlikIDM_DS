//
//  ExtensionView.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 06/08/25.
//

import UIKit

extension UIView {
    public func setGradientBackground(_ gradient: UIColor.UIKitGradient, cornerRadius: CGFloat = 0, corners: UIRectCorner) {
        layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        layoutIfNeeded()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradient.colors.map { $0.cgColor }
        gradientLayer.startPoint = gradient.startPoint.cgPoint
        gradientLayer.endPoint = gradient.endPoint.cgPoint
        gradientLayer.frame = bounds
        
        if cornerRadius > 0 {
            let maskLayer = CAShapeLayer()
            
            let maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            maskLayer.path = maskPath.cgPath
            gradientLayer.mask = maskLayer
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
