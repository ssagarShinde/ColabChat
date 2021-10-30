//
//  ImageFunction.swift
//  ChatLib
//
//  Created by Sagar on 16/08/21.
//

import UIKit

class imageFucntion: NSObject {

    struct blank {
        static let blankBase : String = "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"
    }
    
    // MARK : Get Screen-Shot Code
    class func screenShot(userAllowed : String, showScreen : String) -> String?{
        var screenshotImage :UIImage?
        var newImage : UIImage?
        var resultNSString : String?
        if userAllowed == "T" {
            let layer = UIApplication.shared.keyWindow!.layer
            
            // For Masking
            
            let scale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
            guard let context = UIGraphicsGetCurrentContext() else {return nil}
            layer.render(in:context)
            screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
            
           
          /*  let ivNew = UIImageView(frame: UIApplication.shared.keyWindow!.frame)
            ivNew.image = screenshotImage
            ivNew.clipsToBounds = true
            ivNew.layer.masksToBounds = true
            ivNew.contentMode = .scaleToFill*/
            
            
            let views = MaskView.shared.view
            for idx in views {
                _ = idx.isHidden
                
                let visible = isVisible(idx)
                if visible {
                    guard let frame = idx.viewFrame else {
                        break
                    }
                    let image = drawRectangleOnImages(image: screenshotImage!, frame: frame)
                    screenshotImage = image
                }
            }
            
            let screenSize = layer.frame.size
            newImage = resizeImage(image: screenshotImage!, newWidth: screenSize.width)
            UIGraphicsEndImageContext()
            
            let img = newImage!.jpegData(compressionQuality: 0.2)
            let myBase64Data = img?.base64EncodedData(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
            resultNSString = String(data: myBase64Data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            
            if showScreen == "N" {
                resultNSString = imageFucntion.blank.blankBase
            }
        }
        else{
            resultNSString = "N"
        }
        return resultNSString
    }
    
    // MARK : Resize Image Code
  class  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / (image.size.width)
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

func drawRectangleOnImages(image: UIImage, frame : CGRect) -> UIImage? {
    let imageSize = image.size
    let scale: CGFloat = 0
    UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
    
    image.draw(at: CGPoint.zero)
    
    let rectangle = frame

    UIColor.black.setFill()
    UIRectFill(rectangle)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage ?? nil
}

func isVisible(_ view: UIView) -> Bool {
    
    let vc = UIApplication.shared.keyWindow!.rootViewController!
    let allSubviews = vc.view.allSubViewsOf(type: UIView.self)
    let value = allSubviews.contains(view)
    return value
}

extension UIView {
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

