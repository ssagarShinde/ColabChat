//
//  UIColor.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 10/05/21.
//

import Foundation
import UIKit

@objc
public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
          assert(red >= 0 && red <= 255, "Invalid red component")
          assert(green >= 0 && green <= 255, "Invalid green component")
          assert(blue >= 0 && blue <= 255, "Invalid blue component")

          self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
      }

      convenience init(rgb: Int) {
          self.init(
              red: (rgb >> 16) & 0xFF,
              green: (rgb >> 8) & 0xFF,
              blue: rgb & 0xFF
          )
      }
}

@objc
public extension UIColor {
    
    // MARK: Status Colors
    @objc(msgDeliveredColor)
    class var msgDeliveredColor: UIColor {
        return UIColor(rgb: 0x006AFF)
    }
    
    @objc(msgUndeliveredColor)
    class var msgUndeliveredColor: UIColor {
        return UIColor(rgb: 0xC4C4C4)
    }
}
