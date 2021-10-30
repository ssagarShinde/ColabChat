//
//  ExtensionConstraint.swift
//  ChatLib
//
//  Created by Sagar on 06/08/21.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

extension UIView {
    func enableAutolayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func topMargin(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func bottomMargin(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: -pixels)
        superview?.addConstraint(contraint)
    }
    
    func bottomMarginSmaller(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: superview, attribute: .bottom, multiplier: 1, constant: -pixels)
        superview?.addConstraint(contraint)
    }
    
    func bottomMarginGreater(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: superview, attribute: .bottom, multiplier: 1, constant: -pixels)
        superview?.addConstraint(contraint)
    }
    
    func belowView(_ pixels: CGFloat, to toView: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: toView, attribute: .bottom, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func aboveView(_ pixels: CGFloat, to toView: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func leadingMargin(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func trailingMargin(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: -pixels)
        superview?.addConstraint(contraint)
    }

    func add(toRight pixels: CGFloat, of view: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func add(toLeft pixels: CGFloat, of view: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: -pixels)
        superview?.addConstraint(contraint)
    }
    
    func fixWidth(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func flexibleWidthGreater(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func flexibleWidthSmaller(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func fixHeight(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func flexibleHeightGreater(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }

    func flexibleHeightSmaller(_ pixels: CGFloat) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: pixels)
        superview?.addConstraint(contraint)
    }
    
    func centerX() {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }
    
    func centerY() {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }
    
    func centerX(to mainView: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }
    
    func centerY(to mainView: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }

    func equalWidth(to secondView: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: secondView, attribute: .width, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }
    
    func equalHeight(to secondView: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: secondView, attribute: .height, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }
    
    func flexibleWidthSame(as view: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }
    
    func flexibleHeightSame(as view: UIView?) {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        superview?.addConstraint(contraint)
    }
    
    func heightConstraint(_ pixels: CGFloat) -> NSLayoutConstraint? {
        assert(translatesAutoresizingMaskIntoConstraints == false, "Please enable your view for autolayout using enableAutolayout")
        let contraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: pixels)
        return contraint
    }
}

struct Fonts {
    static let HelveticaNeueRegular = "Helvetica"
    static let HelveticaNeueMedium = "HelveticaNeue-Medium"
}

public class ColorManager {
    public static let shared = ColorManager()
    public var theme = UIColor(red: 5/255, green: 60/255, blue: 109/255, alpha: 1)
}

internal class Colors {
    static var theme = ColorManager.shared.theme
    static var green = UIColor(red: 83/255, green: 204/255, blue: 124/255, alpha: 1)
    static var sendTime = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1)
    static var msgReceiveBackground = UIColor(red: 235/255, green: 240/255, blue: 245/255, alpha: 1)
    static var lightBackground = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    static var red = UIColor(red: 255/255, green: 78/255, blue: 86/255, alpha: 1)
    static let separator = UIColor(named: "#EAEAEA")!
}


func isIphoneX() -> Bool {
    if( UIDevice.current.userInterfaceIdiom == .phone) {
        if(UIScreen.main.bounds.size.height >= 812) {
            return true
        }
    }
    return false
}

public class Device {
    public class var isIpad:Bool {
        if #available(iOS 8.0, * ) {
            return UIScreen.main.traitCollection.userInterfaceIdiom == .pad
        } else {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    public class var isIphone:Bool {
        if #available(iOS 8.0, *) {
            return UIScreen.main.traitCollection.userInterfaceIdiom == .phone
        } else {
            return UIDevice.current.userInterfaceIdiom == .phone
        }
    }
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var isShort: Bool {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue || UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhone4_4S.rawValue {
            return true
        }
        return false
    }
    
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}
