//
//  ExtensionView.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 06/08/25.
//

import UIKit

extension UIView {
    public func setGradientBackground(_ gradient: [UIColor], cornerRadius: CGFloat = 0, corners: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        layer.sublayers?.removeAll { $0 is CAGradientLayer }
        
        layer.borderWidth = 0
        layer.cornerRadius = 0
        layer.masksToBounds = false
        
        layoutIfNeeded()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradient.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        
        if cornerRadius > 0 {
            let maskPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            gradientLayer.mask = maskLayer
            
            if borderWidth > 0, let borderColor = borderColor {
                let borderLayer = CAShapeLayer()
                borderLayer.path = maskPath.cgPath
                borderLayer.fillColor = UIColor.clear.cgColor
                borderLayer.strokeColor = borderColor.cgColor
                borderLayer.lineWidth = borderWidth
                borderLayer.frame = bounds
                
                layer.addSublayer(borderLayer)
            }
        } else {
            if borderWidth > 0 {
                layer.borderWidth = borderWidth
                layer.borderColor = borderColor?.cgColor
            }
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
