//
//  PermissionPopup.swift
//  ChatLib
//
//  Created by Sagar on 19/08/21.
//

import UIKit

protocol  PermissionPopupPr {
    func handleStartBtn(permissionFor : String)
    func handleCancelBtn(permissionFor : String)
}



public class PermissionPopup: UIView {

     let backView = UIView()
     let iv = UIImageView()
    
    var options = [String]()
    var optionTitle = ""
    
    let btnStart = UIButton()
    
    var title = ""
    var msg = ""
    var permissionFor = ""
    
    var delegate : PermissionPopupPr?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func createUI(title : String, msg : String,  permissionFor : String) {
        
        self.title = title
        self.permissionFor = permissionFor
        self.msg = msg
        
        let btnBack = UIButton()
        btnBack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        btnBack.addTarget(self, action: #selector(removeSelf), for: .touchUpInside)
        addSubview(btnBack)
        btnBack.enableAutolayout()
        btnBack.topMargin(0)
        btnBack.bottomMargin(0)
        btnBack.leadingMargin(0)
        btnBack.trailingMargin(0)
        
        backView.layer.cornerRadius = 25
        backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        backView.clipsToBounds = true
        backView.frame =  CGRect(x: 0, y: screenHeight, width: screenWidth, height: 300 )
        backView.backgroundColor = .white
        btnBack.addSubview(backView)
        
        let ivShare = UIImageView()
        ivShare.clipsToBounds = true
        ivShare.image = UIImage(named: "colabEndchat", in: Bundle(for: type(of: self)), compatibleWith: nil)
        backView.addSubview(ivShare)
        ivShare.enableAutolayout()
        ivShare.topMargin(20)
        ivShare.centerX()
        ivShare.fixWidth(50)
        ivShare.fixHeight(50)
        
        let lblSupportShare = UILabel()
        lblSupportShare.textAlignment = .center
        lblSupportShare.text = title
        lblSupportShare.textColor = .black
        lblSupportShare.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 20)
        backView.addSubview(lblSupportShare)
        lblSupportShare.enableAutolayout()
        lblSupportShare.belowView(16, to: ivShare)
        lblSupportShare.leadingMargin(20)
        lblSupportShare.trailingMargin(20)
        lblSupportShare.fixHeight(24)
        
        let lblFeature = UILabel()
        lblFeature.numberOfLines = 0
        lblFeature.textAlignment = .center
        lblFeature.text = msg
        lblFeature.textColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
        lblFeature.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        backView.addSubview(lblFeature)
        lblFeature.enableAutolayout()
        lblFeature.belowView(16, to: lblSupportShare)
        lblFeature.leadingMargin(30)
        lblFeature.trailingMargin(30)
        lblFeature.flexibleHeightGreater(20)
        
        
        let width = (screenWidth - 60) / 2
        let btnCancel = UIButton()
        btnCancel.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        btnCancel.setTitleColor(UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1), for: .normal)
        btnCancel.addTarget(self, action: #selector(HandleCancel(_:)), for: .touchUpInside)
        btnCancel.layer.cornerRadius = 22
        backView.addSubview(btnCancel)
        btnCancel.enableAutolayout()
        btnCancel.belowView(16, to: lblFeature)
        btnCancel.leadingMargin(20)
        btnCancel.fixWidth(width)
        btnCancel.fixHeight(45)
        
        btnStart.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        btnStart.setTitle("Start", for: .normal)
        btnStart.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        btnStart.setTitleColor(.white, for: .normal)
        btnStart.addTarget(self, action: #selector(HandleStart(_:)), for: .touchUpInside)
        btnStart.layer.cornerRadius = 22
        backView.addSubview(btnStart)
        btnStart.enableAutolayout()
        btnStart.belowView(16, to: lblFeature)
        btnStart.trailingMargin(20)
        btnStart.fixWidth(width)
        btnStart.fixHeight(45)
        animate()
    }

    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.backView.frame.origin.y = screenHeight - 300
        })
    }
    
    func animateDissmiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.frame.origin.y = screenHeight
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @objc func removeSelf() {
        animateDissmiss()
    }
    
    @objc func HandleStart(_ sender : UIButton) {
        removeSelf()
        delegate?.handleStartBtn(permissionFor: self.permissionFor)
    }
    
    @objc func HandleCancel(_ sender : UIButton) {
        removeSelf()
        delegate?.handleCancelBtn(permissionFor: self.permissionFor)
    }
}
