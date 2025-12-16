//
//  Search.swift
//  Poinku-DS
//
//  Created by Rizka Ghinna Auliya on 18/03/25.
//

import UIKit

public class SearchBar: UISearchBar {
    
    private var searchText: String?
    private var animationTimer: Timer?
    private var animationType: PlaceholderAnimationType = .append
    private var animationSpeed: TimeInterval = 0.1
    private var currentPlaceholderIndex: Int = 0
    private var cursorSymbol: String = "|"
    private var isAnimating: Bool = false
    
    public var placeholderText: String = "Search" {
        didSet {
            super.placeholder = placeholderText
        }
    }
    
    public var fieldBackgroundColor: UIColor = .white {
        didSet {
            if let textField = getSearchTextField() {
                textField.backgroundColor = fieldBackgroundColor
            }
        }
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    deinit {
        stopPlaceholderAnimation()
    }
    
    private func setupUI() {
        self.barTintColor = .white
        
        self.delegate = self
        self.backgroundImage = UIImage()
        self.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.setSearchFieldBackgroundImage(UIImage(), for: .normal)
            
        self.searchBarStyle = .minimal
        self.searchTextPositionAdjustment = UIOffset.zero
            
        if let textField = getSearchTextField() {
            textField.leftView = nil
            
            let searchIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            searchIconView.contentMode = .scaleAspectFit
            searchIconView.tintColor = UIColor.grey60
            searchIconView.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)

            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: textField.frame.height))
            searchIconView.center.y = containerView.bounds.height / 2
            containerView.addSubview(searchIconView)

            let clearButton = textField.value(forKey: "_clearButton") as? UIButton
                
            if let originalImage = clearButton?.imageView?.image {
                let templateImage = originalImage.withRenderingMode(.alwaysTemplate)
                
                let size = CGSize(width: 20, height: 20)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                templateImage.draw(in: CGRect(origin: .zero, size: size))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                clearButton?.setImage(resizedImage, for: .normal)
                
                clearButton?.tintColor = UIColor.grey60
            }
            
            textField.leftView = containerView
            textField.leftViewMode = .always
            
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 8
            textField.layer.borderColor = UIColor.grey30.cgColor
            
            textField.clipsToBounds = true
            textField.backgroundColor = fieldBackgroundColor
            
            textField.font = Font.B3.Small.font
        }
    
    }
    
    public func getSearchTextField() -> UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            if let textField = self.value(forKey: "searchField") as? UITextField {
                return textField
            }
            
            for subview in self.subviews {
                for innerSubview in subview.subviews {
                    if let textField = innerSubview as? UITextField {
                        return textField
                    }
                }
            }
            return nil
        }
    }
    
    public func startPlaceholderAnimation(type: PlaceholderAnimationType, speed: TimeInterval = 0.1, cursorSymbol: String = "|") {
        stopPlaceholderAnimation()
        
        self.animationType = type
        self.animationSpeed = speed
        self.cursorSymbol = cursorSymbol
        self.currentPlaceholderIndex = 0
        self.isAnimating = true
        
        if let textField = getSearchTextField() {
            if type == .slideTopBottom {
                setupSlideAnimation(textField: textField)
            } else {
                super.placeholder = ""
            }
        }
        
        animationTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(updatePlaceholder), userInfo: nil, repeats: true)
    }
    
    public func stopPlaceholderAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        isAnimating = false
        
        super.placeholder = placeholderText
        
        if let textField = getSearchTextField() {
            textField.attributedPlaceholder = nil
        }
    }
    
    @objc private func updatePlaceholder() {
        guard isAnimating else { return }
            
        if currentPlaceholderIndex > placeholderText.count {
            animationTimer?.invalidate()
            animationTimer = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self, self.isAnimating else { return }
                
                self.currentPlaceholderIndex = 0
                
                if self.animationType != .append {
                    self.placeholder = ""
                }
                
                self.animationTimer = Timer.scheduledTimer(
                    timeInterval: self.animationSpeed,
                    target: self,
                    selector: #selector(self.updatePlaceholder),
                    userInfo: nil,
                    repeats: true
                )
            }
            return
        }
        
        let textField = getSearchTextField()
        
        switch animationType {
        case .append:
            let endIndex = placeholderText.index(placeholderText.startIndex, offsetBy: currentPlaceholderIndex)
            let currentText = String(placeholderText[..<endIndex])
            super.placeholder = currentText
            
        case .appendPrefix:
            let endIndex = placeholderText.index(placeholderText.startIndex, offsetBy: currentPlaceholderIndex)
            let currentText = String(placeholderText[..<endIndex])
            super.placeholder = currentText + cursorSymbol
            
        case .slideTopBottom:
            if let textField = textField {
                updateSlideAnimation(textField: textField)
            }
        }
        
        currentPlaceholderIndex += 1
    }
    
    private func setupSlideAnimation(textField: UITextField) {
        let attributedString = NSMutableAttributedString(string: placeholderText)
        let range = NSRange(location: 0, length: placeholderText.count)
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.clear,
            range: range
        )
        
        textField.attributedPlaceholder = attributedString
    }
    
    private func updateSlideAnimation(textField: UITextField) {
        let attributedString = NSMutableAttributedString(string: placeholderText)
        
        for i in 0..<placeholderText.count {
            let charRange = NSRange(location: i, length: 1)
            var offset: CGFloat = 0
            
            if i < currentPlaceholderIndex {
                offset = 0
            } else {
                offset = -15
            }
            
            attributedString.addAttribute(
                .baselineOffset,
                value: offset,
                range: charRange
            )
            
            let color = i < currentPlaceholderIndex ? UIColor.lightGray : UIColor.clear
            attributedString.addAttribute(
                .foregroundColor,
                value: color,
                range: charRange
            )
        }
        
        textField.attributedPlaceholder = attributedString
    }
    
}

extension SearchBar: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let textField = getSearchTextField() {
            textField.layer.borderColor = UIColor.blue10.cgColor
        }
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let textField = getSearchTextField() {
            textField.layer.borderColor = UIColor.grey30.cgColor
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty && isAnimating {
            stopPlaceholderAnimation()
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        if let textField = getSearchTextField() {
            textField.layer.borderColor = UIColor.grey30.cgColor
        }
    }
}

public enum PlaceholderAnimationType {
    case append
    case appendPrefix
    case slideTopBottom
}
