//
//  HoverColor.swift
//  Hover
//
//  Created by Pedro Carrasco on 14/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverColor
public enum HoverColor {
    case color(UIColor)
    case gradient(top: UIColor, bottom: UIColor)
}

extension UIColor {
    
    func add (controller : UIViewController) -> UIImage {
        return UIImage(named: "", in: Bundle(for: type(of: controller)), compatibleWith: nil)!
    }
    
    func cancel (controller : UIViewController) -> UIImage {
        return UIImage(named: "", in: Bundle(for: type(of: controller)), compatibleWith: nil)!
    }
    
    func disconnect (controller : UIViewController) -> UIImage {
        return UIImage(named: "", in: Bundle(for: type(of: controller)), compatibleWith: nil)!
    }
    
    func copyURL (controller : UIViewController) -> UIImage {
        return UIImage(named: "", in: Bundle(for: type(of: controller)), compatibleWith: nil)!
    }
    
}

