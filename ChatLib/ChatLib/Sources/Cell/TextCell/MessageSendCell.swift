//
//  MessageSendCell.swift
//  ChatLib
//
//  Created by Sagar on 11/08/21.
//

import UIKit

class MessageSendCell: UITableViewCell {
    
    let lblMessage = PaddingLabelNew()
    let btnSeeMore = UIButton()
    let lblTime = UILabel()
    
    let dot1 = UIView()
    let dot2 = UIView()
    
    var delegate : ReloadTableHeightPr?
    var ivDone = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        self.contentView.clipsToBounds = true
        
        let vBack = UIView()
        vBack.layer.cornerRadius = 20
        vBack.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        vBack.backgroundColor = Colors.theme
        self.contentView.addSubview(vBack)
        vBack.enableAutolayout()
        vBack.trailingMargin(20)
        vBack.flexibleHeightGreater(10)
        vBack.flexibleWidthSmaller((screenWidth/2) + 50)
        vBack.topMargin(8)
        vBack.bottomMargin(4)
        
        lblMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblMessage.numberOfLines = 0
        lblMessage.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 18)
        lblMessage.textColor = .white
        vBack.addSubview(lblMessage)
        lblMessage.enableAutolayout()
        lblMessage.trailingMargin(20)
        lblMessage.flexibleWidthGreater(120)
        lblMessage.leadingMargin(0)
        lblMessage.topMargin(0)
        lblMessage.flexibleHeightGreater(20)
        
        ivDone.clipsToBounds = true
        ivDone.contentMode = .scaleToFill
        ivDone.image = UIImage(named: "colabDone", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        ivDone.tintColor = Colors.green
        vBack.addSubview(ivDone)
        ivDone.enableAutolayout()
        ivDone.fixWidth(16)
        ivDone.fixHeight(16)
        ivDone.trailingMargin(8)
        ivDone.belowView(4, to: lblMessage)
        ivDone.bottomMargin(10)
        
        lblTime.text = " "
        lblTime.textAlignment = .right
        lblTime.numberOfLines = 2
        lblTime.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 12)
        lblTime.textColor = Colors.sendTime
        vBack.addSubview(lblTime)
        lblTime.enableAutolayout()
        lblTime.centerY(to: ivDone)
        lblTime.add(toLeft: 8, of: ivDone)
        lblTime.fixHeight(16)
        lblTime.bottomMargin(10)
        
        btnSeeMore.setTitle("", for: .normal)
        btnSeeMore.setTitleColor(UIColor(red: 114/255, green: 154/255, blue: 207/255, alpha: 1), for: .normal)
        btnSeeMore.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnSeeMore.addTarget(self, action: #selector(HandleHeight(_:)), for: .touchUpInside)
        vBack.addSubview(btnSeeMore)
        btnSeeMore.enableAutolayout()
        btnSeeMore.leadingMargin(20)
        btnSeeMore.belowView(0, to: lblMessage)
        btnSeeMore.centerY(to: lblTime)
        btnSeeMore.flexibleHeightGreater(1)
    }
    
    func configureCell(message : String, font: Float, dateAgoLbl: String, isSent : Bool){
        self.lblMessage.font = UIFont.systemFont(ofSize: CGFloat(font))
        self.lblMessage.text = message
        self.lblTime.text = dateAgoLbl
        
        if isSent == true {
            ivDone.image = UIImage(named: "colabDone", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivDone.tintColor = Colors.green
        }
        else {
            ivDone.image = UIImage(named: "colabDoneSingle", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivDone.tintColor = Colors.green
        }
    }
    
    @objc func HandleHeight(_ sender : UIButton) {
        delegate?.HandleHeight(index: sender.tag)
    }
}
