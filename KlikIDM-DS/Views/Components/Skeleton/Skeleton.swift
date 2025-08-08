//
//  Skeleton.swift
//  KlikIDM-DS-UiKit
//
//  Created by Rizka Ghinna Auliya on 17/02/25.
//

import UIKit

public class Skeleton: UIView {
    private let gradientLayer = CAGradientLayer()
    private let shimmerAnimation: CABasicAnimation
    
    @IBInspectable var cornerRadius: CGFloat = 8.0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    override init(frame: CGRect) {
        shimmerAnimation = CABasicAnimation(keyPath: "locations")
        shimmerAnimation.fromValue = [-1.0, -0.5, 0.0]
        shimmerAnimation.toValue = [1.0, 1.5, 2.0]
        shimmerAnimation.repeatCount = .infinity
        shimmerAnimation.duration = 1.5
        
        super.init(frame: frame)
        setupGradient()
        updateCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        shimmerAnimation = CABasicAnimation(keyPath: "locations")
        shimmerAnimation.fromValue = [-1.0, -0.5, 0.0]
        shimmerAnimation.toValue = [1.0, 1.5, 2.0]
        shimmerAnimation.repeatCount = .infinity
        shimmerAnimation.duration = 1.5
        
        super.init(coder: coder)
        setupGradient()
        updateCornerRadius()
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.grey20?.cgColor ?? UIColor.gray.cgColor,
            UIColor.grey30?.cgColor ?? UIColor.gray.cgColor,
            UIColor.grey20?.cgColor ?? UIColor.gray.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
        
        gradientLayer.add(shimmerAnimation, forKey: "shimmerAnimation")
    }
    
    private func updateCornerRadius() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        gradientLayer.cornerRadius = cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        updateCornerRadius()
    }
    
    func startShimmer() {
        gradientLayer.add(shimmerAnimation, forKey: "shimmerAnimation")
    }
    
    func stopShimmer() {
        gradientLayer.removeAnimation(forKey: "shimmerAnimation")
    }
}
