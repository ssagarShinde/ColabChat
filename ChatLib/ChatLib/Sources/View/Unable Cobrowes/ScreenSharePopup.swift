//
//  ScreenSharePopup.swift
//  ChatLib
//
//  Created by Sagar on 06/08/21.
//

import UIKit


public protocol ShareScreenPr {
    func value(tag : Int)
}

public class ScreenSharePopup: UIView {
    
     let backView = UIView()
     let iv = UIImageView()
    
    var options = [String]()
    var optionTitle = ""
    
    let btnStart = UIButton()
    public var delegate : ShareScreenPr?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func createUI(btnTag : Int) {
        
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
        
        var height = 0.0
        if (UIScreen.main.bounds.size.height >= 926) {
            height = 0.5
        }
        else {
            height = (isIphoneX() ? 0.6 : 0.7)
        }
        backView.frame =  CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight * CGFloat(height) )
        backView.backgroundColor = .white
        btnBack.addSubview(backView)
        
        let ivShare = UIImageView()
        ivShare.clipsToBounds = true
        ivShare.image = UIImage(named: "colabScreenshareIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
        backView.addSubview(ivShare)
        ivShare.enableAutolayout()
        ivShare.topMargin(20)
        ivShare.centerX()
        ivShare.fixWidth(120)
        ivShare.fixHeight(50)
        
        let lblSupportShare = UILabel()
        lblSupportShare.textAlignment = .center
        lblSupportShare.text = "Support With Screen Sharing"
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
        lblFeature.textAlignment = .left
        lblFeature.text = "This feature would require you to share you screen."
        lblFeature.textColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
        lblFeature.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 15)
        backView.addSubview(lblFeature)
        lblFeature.enableAutolayout()
        lblFeature.belowView(16, to: lblSupportShare)
        lblFeature.leadingMargin(30)
        lblFeature.trailingMargin(30)
        lblFeature.flexibleHeightGreater(20)
        
        let lblNote = UILabel()
        lblNote.numberOfLines = 0
        lblNote.textAlignment = .left
        lblNote.text = "Note:"
        lblNote.textColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
        lblNote.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 15)
        backView.addSubview(lblNote)
        lblNote.enableAutolayout()
        lblNote.belowView(16, to: lblFeature)
        lblNote.leadingMargin(30)
        lblNote.trailingMargin(30)
        lblNote.flexibleHeightGreater(16)
        
        let lblNote1 = UILabel()
        lblNote1.numberOfLines = 0
        lblNote1.textAlignment = .left
        lblNote1.text = "⦿ Agent would be able to only see screens related to this aap only. Once you move out of the application screen-sharing would be enabled but screen would not be shared with agent\n\n⦿ All the sensetive information like password,balance etc would be masked before sharing with agent."
        lblNote1.textColor = UIColor(red: 139/255, green: 139/255, blue: 139/255, alpha: 1)
        lblNote1.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 15)
        backView.addSubview(lblNote1)
        lblNote1.enableAutolayout()
        lblNote1.belowView(4, to: lblNote)
        lblNote1.leadingMargin(30)
        lblNote1.trailingMargin(30)
        lblNote1.flexibleHeightGreater(20)
        
        let lblPrivacy = UILabel()
        lblPrivacy.textAlignment = .center
        lblPrivacy.text = "We care for your Privacy"
        lblPrivacy.textColor = UIColor.black.withAlphaComponent(0.6)
        lblPrivacy.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 15)
        backView.addSubview(lblPrivacy)
        lblPrivacy.enableAutolayout()
        lblPrivacy.belowView(8, to: lblNote1)
        lblPrivacy.leadingMargin(20)
        lblPrivacy.trailingMargin(20)
        lblPrivacy.fixHeight(24)
        
        let width = (screenWidth - 60) / 2
        let btnCancel = UIButton()
        btnCancel.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        btnCancel.setTitleColor(UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1), for: .normal)
        btnCancel.addTarget(self, action: #selector(removeSelf), for: .touchUpInside)
        btnCancel.layer.cornerRadius = 22
        backView.addSubview(btnCancel)
        btnCancel.enableAutolayout()
        btnCancel.belowView(16, to: lblPrivacy)
        btnCancel.leadingMargin(20)
        btnCancel.fixWidth(width)
        btnCancel.fixHeight(45)
        
        btnStart.tag = btnTag
        btnStart.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        btnStart.setTitle(btnTag == 0 ? "Start" : "Close", for: .normal)
        btnStart.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        btnStart.setTitleColor(.white, for: .normal)
        btnStart.addTarget(self, action: #selector(HandleStart(_:)), for: .touchUpInside)
        btnStart.layer.cornerRadius = 22
        backView.addSubview(btnStart)
        btnStart.enableAutolayout()
        btnStart.belowView(16, to: lblPrivacy)
        btnStart.trailingMargin(20)
        btnStart.fixWidth(width)
        btnStart.fixHeight(45)
        
        animate()
    }

    func animate() {
        
        var height = 0.0
        if (UIScreen.main.bounds.size.height >= 926) {
            height = 0.5
        }
        else {
            height = (isIphoneX() ? 0.6 : 0.7)
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.backView.frame.origin.y = screenHeight - (screenHeight * CGFloat(height))
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
        if (sender.tag == 0) {
            
            if (CobrowseSocketIndividual.shareds.standalone) {
                CobrowseSocketIndividual.shareds.establishConnections(type: "")
            }
            else {
                CobrowseSocketHelper.shared.cobrowseSocketEstablishConnection(type: "")
            }
            
            removeSelf()
            delegate?.value(tag: 0)
        }
        else if (sender.tag == 1) {
            removeSelf()
            delegate?.value(tag: 1)
        }
    }
}
