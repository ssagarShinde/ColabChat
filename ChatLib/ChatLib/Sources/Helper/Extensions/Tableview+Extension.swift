//
//  Tableview+Extension.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import Foundation
import UIKit

extension UITableView {
    
    static func emptyCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollToBottom(animated: Bool = true) {

        guard let dataSource = dataSource else { return }

         var lastSectionWithAtLeasOneElements = (dataSource.numberOfSections?(in: self) ?? 1) - 1

         while dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) < 1 {
             lastSectionWithAtLeasOneElements -= 1
         }
         let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) - 1
         guard lastSectionWithAtLeasOneElements > -1 && lastRow > -1 else { return }
         let bottomIndex = IndexPath(item: lastRow, section: lastSectionWithAtLeasOneElements)
         scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
    }
}

extension UIView {
    
    func setEmptyMessageImage(_ message: String, img:String) {
        
        let viewMessage = UIView()
        viewMessage.accessibilityHint = "NoData"
        addSubview(viewMessage)
        viewMessage.enableAutolayout()
        viewMessage.leadingMargin(0)
        viewMessage.fixWidth(screenWidth)
        viewMessage.fixHeight(250)
        viewMessage.centerY()
        
        let ivEmpty = UIImageView()
        ivEmpty.clipsToBounds = true
        ivEmpty.accessibilityHint = "NoData"
        ivEmpty.image = UIImage.init(named: img, in: Bundle(for: type(of: self)), compatibleWith: nil)
        viewMessage.addSubview(ivEmpty)
        ivEmpty.enableAutolayout()
        ivEmpty.centerX()
        ivEmpty.fixWidth(120)
        ivEmpty.fixHeight(200)
        ivEmpty.topMargin(0)
        
        let messageLabel = UILabel()
        messageLabel.accessibilityHint = "NoData"
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.sizeToFit()
        viewMessage.addSubview(messageLabel)
        messageLabel.enableAutolayout()
        messageLabel.fixWidth(screenWidth - 50)
        messageLabel.centerX()
        messageLabel.belowView(10, to: ivEmpty)
        messageLabel.flexibleWidthGreater(20)
        messageLabel.bottomMargin(0)
    }
    
    func restore() {
        for v in self.subviews {
            if v.accessibilityHint ?? "" == "NoData"  {
                v.removeFromSuperview()
            }
        }
    }
    
    func toastView(msg : String) {
        if msg == "" {
            return
        }
        
        let labelToast = PaddingLabel()
        labelToast.textAlignment = .center
        labelToast.text = msg
        labelToast.textColor = .white
        labelToast.numberOfLines = 0
        labelToast.font = UIFont.systemFont(ofSize: Device.isIpad ? 20 : 16)
        labelToast.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        UIApplication.shared.keyWindow?.addSubview(labelToast)
        labelToast.enableAutolayout()
        labelToast.fixWidth(screenWidth)
        labelToast.centerX()
        labelToast.flexibleHeightGreater(40)
        labelToast.topMargin(Constraints.top + base.topbarHeight)
        
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [], animations: {() -> Void in
            labelToast.alpha = 0
        }, completion: {(_) in
            labelToast.removeFromSuperview()
        })
    }
}

extension UITextField {
    @objc func setProperties() {
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .next
        keyboardType = .default
        textColor = .black
        font = UIFont(name: Fonts.HelveticaNeueRegular,size: 15)
        setLeftPaddingPoints(15)
        setRightPaddingPoints(15)
        backgroundColor = .white
    }

    func setLeftPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 5, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: bounds.width - (amount + 5), y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension UITextView {
    @objc func setProperties() {
        self.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = Colors.sendTime.cgColor
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .next
        keyboardType = .default
        textColor = .black
        font = UIFont(name: Fonts.HelveticaNeueRegular,size: 16)
        backgroundColor = .white
    }
}

extension UIToolbar {
    open func ToolbarPiker(mySelect : Selector, title:String) -> UIToolbar {
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

class CustomLabel : UILabel {
    let lblFirst = UILabel()
    let lblSecond = UILabel()
    func setupClass(textFirst : String, textSecond : String) {
    
        lblFirst.textColor = Colors.theme
        lblFirst.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        lblFirst.textColor = Colors.sendTime
        lblFirst.text = textFirst
        lblFirst.textAlignment = .left
        self.addSubview(lblFirst)
        lblFirst.enableAutolayout()
        lblFirst.topMargin(0)
        lblFirst.fixHeight(25)
        lblFirst.leadingMargin(20)
        lblFirst.trailingMargin(20)
        
        lblSecond.numberOfLines = 0
        lblSecond.textColor = Colors.theme
        lblSecond.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 18)
        lblSecond.textColor = UIColor.darkGray
        lblSecond.text = textSecond
        lblSecond.textAlignment = .left
        self.addSubview(lblSecond)
        lblSecond.enableAutolayout()
        lblSecond.belowView(0, to: lblFirst)
        lblSecond.flexibleHeightGreater(20)
        lblSecond.leadingMargin(20)
        lblSecond.trailingMargin(20)
        lblSecond.bottomMargin(0)
    }
}

