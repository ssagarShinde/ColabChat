//
//  UIlabel.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import Foundation
import UIKit

@IBDesignable
class PaddingLabel: UILabel {
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
}

//@IBDesignable class UITextViewFixed: UITextView {
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setup()
//    }
//    func setup() {
//        textContainerInset = UIEdgeInsets.zero
//        textContainer.lineFragmentPadding = 0
//    }
//}

//MARK: UIVIEW
@IBDesignable
class CurveView: UIView {
    
    // MARK: - Properties
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var topLeft: Bool {
           get { return layer.maskedCorners.contains(.layerMinXMinYCorner) }
           set {
               if newValue {
                   layer.maskedCorners.insert(.layerMinXMinYCorner)
               } else {
                   layer.maskedCorners.remove(.layerMinXMinYCorner)
               }
           }
       }

       @IBInspectable var topRight: Bool {
           get { return layer.maskedCorners.contains(.layerMaxXMinYCorner) }
           set {
               if newValue {
                   layer.maskedCorners.insert(.layerMaxXMinYCorner)
               } else {
                   layer.maskedCorners.remove(.layerMaxXMinYCorner)
               }
           }
       }

       @IBInspectable var bottomLeft: Bool {
           get { return layer.maskedCorners.contains(.layerMinXMaxYCorner) }
           set {
               if newValue {
                   layer.maskedCorners.insert(.layerMinXMaxYCorner)
               } else {
                   layer.maskedCorners.remove(.layerMinXMaxYCorner)
               }
           }
       }

       @IBInspectable var bottomRight: Bool {
           get { return layer.maskedCorners.contains(.layerMaxXMaxYCorner) }
           set {
               if newValue {
                   layer.maskedCorners.insert(.layerMaxXMaxYCorner)
               } else {
                   layer.maskedCorners.remove(.layerMaxXMaxYCorner)
               }
           }
       }
}


//MARK: UIbutton
@IBDesignable
class CurveBtn: UIButton {
    // MARK: - Properties
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}

