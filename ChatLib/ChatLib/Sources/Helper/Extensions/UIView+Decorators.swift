//
//  UIView+Decorators.swift
//  Hover
//
//  Created by Pedro Carrasco on 13/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - Gradient
extension UIView {
    
    // MARK: Constant
    private enum GradientConstant {
        static let startPoint = CGPoint(x: 0.5, y: 1.0)
        static let endPoint = CGPoint(x: 0.5, y: 0.0)
        static let locations: [NSNumber] = [0, 1]
    }
    
    // MARK: Functions
    func makeGradientLayer(_ gradientLayer: CAGradientLayer = .init()) -> CAGradientLayer {
        gradientLayer.startPoint = GradientConstant.startPoint
        gradientLayer.endPoint = GradientConstant.endPoint
        gradientLayer.locations = GradientConstant.locations
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}

// MARK: - Shadow
extension UIView {
    
    // MARK: Constant
    private enum ShadowConstant {
        static let heightOffset = 0
        static let opacity: Float = 0.55
        static let radius: CGFloat = 10
    }
    
    // MARK: Functions
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
}
