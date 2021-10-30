//
//  LinkSuccessPopup.swift
//  ChatLib
//
//  Created by Sagar on 07/10/21.
//

import UIKit

class LinkSuccessPopup: UIView {

    var delegate: SelectionDelegate?

    let tblViewSlider = UITableView()
    var options = [String]()
    var optionTitle = ""
    var tags = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI(msg : String, ticketId : String) {
        
        self.tags = tag
        let btnBack = UIButton()
        btnBack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(btnBack)
        btnBack.enableAutolayout()
        btnBack.topMargin(0)
        btnBack.bottomMargin(0)
        btnBack.leadingMargin(0)
        btnBack.trailingMargin(0)
        
        let backView = UIView()
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 8
        backView.clipsToBounds = true
        btnBack.addSubview(backView)
        backView.enableAutolayout()
        backView.centerX()
        backView.fixWidth(screenWidth - 40)
        backView.centerY()
        backView.flexibleHeightGreater(20)
        
        let headerView = UIView()
        headerView.backgroundColor = Colors.theme
        headerView.clipsToBounds = true
        backView.addSubview(headerView)
        headerView.enableAutolayout()
        headerView.topMargin(0)
        headerView.leadingMargin(0)
        headerView.trailingMargin(0)
        headerView.fixHeight(80)
        
        let ivSuccess = UIImageView()
        ivSuccess.clipsToBounds = true
        ivSuccess.contentMode = .scaleAspectFill
        ivSuccess.image = UIImage(named: "colabSuccess", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        ivSuccess.tintColor = .white
        headerView.addSubview(ivSuccess)
        ivSuccess.enableAutolayout()
        ivSuccess.centerY()
        ivSuccess.centerX()
        ivSuccess.fixWidth(50)
        ivSuccess.fixHeight(50)
        
        let lblSuccess = UILabel()
        lblSuccess.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 22)
        lblSuccess.textColor = UIColor.darkGray
        lblSuccess.text = "Success"
        backView.addSubview(lblSuccess)
        lblSuccess.enableAutolayout()
        lblSuccess.belowView(20, to: headerView)
        lblSuccess.centerX()
        
        let lblMsg = UILabel()
        lblMsg.numberOfLines = 0
        lblMsg.textAlignment = .center
        lblMsg.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 19)
        lblMsg.textColor = UIColor.gray
        lblMsg.text = "We have received your complaint successfully. Your ticket ID is \(ticketId)"
        backView.addSubview(lblMsg)
        lblMsg.enableAutolayout()
        lblMsg.belowView(20, to: lblSuccess)
        lblMsg.leadingMargin(30)
        lblMsg.trailingMargin(30)
        lblMsg.flexibleHeightGreater(40)
        lblMsg.centerX()
        
        let lblAgent = UILabel()
        lblAgent.numberOfLines = 0
        lblAgent.textAlignment = .center
        lblAgent.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 18)
        lblAgent.textColor = UIColor.gray
        lblAgent.text = "You will be connected to the next available agent as soon as possible"
        backView.addSubview(lblAgent)
        lblAgent.enableAutolayout()
        lblAgent.belowView(20, to: lblMsg)
        lblAgent.leadingMargin(16)
        lblAgent.trailingMargin(16)
        lblAgent.flexibleHeightGreater(40)
        lblAgent.centerX()
        
        let btnOk = UIButton()
        btnOk.backgroundColor = .white
        btnOk.setTitle("OK", for: .normal)
        btnOk.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 16)
        btnOk.setTitleColor(Colors.theme, for: .normal)
        btnOk.layer.cornerRadius = 10
        btnOk.layer.borderWidth = 2
        btnOk.layer.borderColor = Colors.theme.cgColor
        btnOk.addTarget(self, action: #selector(removeSelf), for: UIControl.Event.touchUpInside)
        backView.addSubview(btnOk)
        btnOk.enableAutolayout()
        btnOk.belowView(20, to: lblAgent)
        btnOk.centerX()
        btnOk.fixWidth(200)
        btnOk.fixHeight(50)
        btnOk.bottomMargin(20)
        
    }
    
    func animate() {
        
    }

    func animateDissmiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tblViewSlider.frame.origin.y = screenHeight
        }) { (_) in
            self.removeFromSuperview()
        }
    }

    @objc func removeSelf() {
        animateDissmiss()
    }
}
