//
//  ExtensionUIColor.swift
//  KlikIDM_DS
//
//  Created by Rizka Ghinna Auliya on 29/07/25.
//

import UIKit

extension UIColor {
    
    // Neutral
    
    static var white: UIColor? {
        return UIColor(named: "White")
    }
    
    static var black: UIColor? {
        return UIColor(named: "Black")
    }
    
    
    // Grey
    
    static var grey10: UIColor? {
        return UIColor(named: "10Grey")
    }
    
    static var grey20: UIColor? {
        return UIColor(named: "20Grey")
    }
    
    static var grey30: UIColor? {
        return UIColor(named: "30Grey")
    }
    
    static var grey40: UIColor? {
        return UIColor(named: "40Grey")
    }
    
    static var grey50: UIColor? {
        return UIColor(named: "50Grey")
    }
    
    static var grey60: UIColor? {
        return UIColor(named: "60Grey")
    }
    
    static var grey70: UIColor? {
        return UIColor(named: "70Grey")
    }
    
    
    // Blue
    
    static var blue10: UIColor? {
        return UIColor(named: "10Blue")
    }
    
    static var blue20: UIColor? {
        return UIColor(named: "20Blue")
    }
    
    static var blue30: UIColor? {
        return UIColor(named: "30Blue")
    }
    
    static var blue40: UIColor? {
        return UIColor(named: "40Blue")
    }
    
    static var blue50: UIColor? {
        return UIColor(named: "50Blue")
    }
    
    static var blue60: UIColor? {
        return UIColor(named: "60Blue")
    }
    
    static var blue70: UIColor? {
        return UIColor(named: "70Blue")
    }
    
    
    // Yellow
    
    static var yellow10: UIColor? {
        return UIColor(named: "10Yellow")
    }
    
    static var yellow20: UIColor? {
        return UIColor(named: "20Yellow")
    }
    
    static var yellow30: UIColor? {
        return UIColor(named: "30Yellow")
    }
    
    static var yellow40: UIColor? {
        return UIColor(named: "40Yellow")
    }
    
    static var yellow50: UIColor? {
        return UIColor(named: "50Yellow")
    }
    
    
    // Red
    
    static var red10: UIColor? {
        return UIColor(named: "10Red")
    }
    
    static var red20: UIColor? {
        return UIColor(named: "20Red")
    }
    
    static var red30: UIColor? {
        return UIColor(named: "30Red")
    }
    
    static var red40: UIColor? {
        return UIColor(named: "40Red")
    }
    
    static var red50: UIColor? {
        return UIColor(named: "50Red")
    }
    
    
    // Green
    
    static var green10: UIColor? {
        return UIColor(named: "10Green")
    }
    
    static var green20: UIColor? {
        return UIColor(named: "20Green")
    }
    
    static var green30: UIColor? {
        return UIColor(named: "30Green")
    }
    
    static var green40: UIColor? {
        return UIColor(named: "40Green")
    }
    
    static var green50: UIColor? {
        return UIColor(named: "50Green")
    }
    
    
    // Orange
    
    static var orange10: UIColor? {
        return UIColor(named: "10Orange")
    }
    
    static var orange20: UIColor? {
        return UIColor(named: "20Orange")
    }
    
    static var orange30: UIColor? {
        return UIColor(named: "30Orange")
    }
    
    static var orange40: UIColor? {
        return UIColor(named: "40Orange")
    }
    
    static var orange50: UIColor? {
        return UIColor(named: "50Orange")
    }
    
    
    // Button
    
    static var blueDefault: UIColor? {
        return UIColor(named: "DefaultBlue")
    }
    
    static var bluePressed: UIColor? {
        return UIColor(named: "PressedBlue")
    }
    
    static var greyDefault: UIColor? {
        return UIColor(named: "DefaultGrey")
    }
    
    static var greyPressed: UIColor? {
        return UIColor(named: "PressedGrey")
    }
    
    static var greyText: UIColor? {
        return UIColor(named: "TextGrey")
    }
    
    static var cartDefault: UIColor? {
        return UIColor(named: "DefaultCart")
    }
    
    static var cartPressed: UIColor? {
        return UIColor(named: "PressedCart")
    }
    
    static var disabled: UIColor? {
        return UIColor(named: "Disable")
    }
    
    struct Support {
        static let errorStrong = UIColor(named: "Error-Strong")
        static let errorWeak = UIColor(named: "Error-Weak")
        static let successStrong = UIColor(named: "Success-Strong")
        static let successWeak = UIColor(named: "Success-Weak")
        static let warningStrong = UIColor(named: "Warning-Strong")
        static let warningWeak = UIColor(named: "Warning-Weak")
    }
    
    struct Brand {
        static let xtra = UIColor(named: "Xtra")
        static let xpress = UIColor(named: "Xpress")
    }
    
    struct Gradient {
        static let sunset = UIKitGradient(
            colors: [
                UIColor(named: "Sunset-Leading") ?? .systemOrange,
                UIColor(named: "Sunset-Trailing") ?? .systemRed
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let skyblue = UIKitGradient(
            colors: [
                UIColor(named: "Skyblue-Leading") ?? .systemBlue,
                UIColor(named: "Skyblue-Trailing") ?? .systemTeal
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let greenforest = UIKitGradient(
            colors: [
                UIColor(named: "Greenforest-Leading") ?? .systemGreen,
                UIColor(named: "Greenforest-Trailing") ?? .systemGreen
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let sunflower = UIKitGradient(
            colors: [
                UIColor(named: "Sunflower-Leading") ?? .systemYellow,
                UIColor(named: "Sunflower-Trailing") ?? .systemOrange
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    struct UIKitGradient {
        let colors: [UIColor]
        let startPoint: GradientPoint
        let endPoint: GradientPoint
        
        enum GradientPoint {
            case leading, trailing, top, bottom
            case topLeading, topTrailing, bottomLeading, bottomTrailing
            case center
            case custom(x: CGFloat, y: CGFloat)
            
            var cgPoint: CGPoint {
                switch self {
                case .leading:
                    return CGPoint(x: 0, y: 0.5)
                case .trailing:
                    return CGPoint(x: 1, y: 0.5)
                case .top:
                    return CGPoint(x: 0.5, y: 0)
                case .bottom:
                    return CGPoint(x: 0.5, y: 1)
                case .topLeading:
                    return CGPoint(x: 0, y: 0)
                case .topTrailing:
                    return CGPoint(x: 1, y: 0)
                case .bottomLeading:
                    return CGPoint(x: 0, y: 1)
                case .bottomTrailing:
                    return CGPoint(x: 1, y: 1)
                case .center:
                    return CGPoint(x: 0.5, y: 0.5)
                case .custom(let x, let y):
                    return CGPoint(x: x, y: y)
                }
            }
        }
    }
}
