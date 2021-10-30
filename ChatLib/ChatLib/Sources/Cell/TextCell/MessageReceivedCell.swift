//
//  MessageReceivedCell.swift
//  ChatLib
//
//  Created by Sagar on 11/08/21.
//

import UIKit

class PaddingLabelNew: UILabel {
    
    var topInset: CGFloat = 10
    var bottomInset: CGFloat = 2
    var leftInset: CGFloat = 20
    var rightInset: CGFloat = 20
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}


protocol ReloadTableHeightPr {
    func HandleHeight(index : Int)
}

class MessageReceivedCell: UITableViewCell {
    
    let lblMessage = PaddingLabelNew()
    let btnSeeMore = UIButton()
    let lblTime = UILabel()
    
    var delegate : ReloadTableHeightPr?
    
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
        vBack.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        vBack.backgroundColor = Colors.msgReceiveBackground
        self.contentView.addSubview(vBack)
        vBack.enableAutolayout()
        vBack.leadingMargin(20)
        vBack.flexibleHeightGreater(10)
        vBack.flexibleWidthSmaller((screenWidth/2) + 50)
        vBack.topMargin(8)
        vBack.bottomMargin(4)
        
        lblMessage.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblMessage.numberOfLines = 0
        lblMessage.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 18)
        lblMessage.textColor = .black
        vBack.addSubview(lblMessage)
        lblMessage.enableAutolayout()
        lblMessage.flexibleWidthGreater(120)
        lblMessage.trailingMargin(0)
        lblMessage.leadingMargin(0)
        lblMessage.flexibleHeightGreater(20)
        lblMessage.topMargin(0)
    
        lblTime.text = "5 hours ago"
        lblTime.textAlignment = .right
        lblTime.numberOfLines = 1
        lblTime.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 12)
        lblTime.textColor = Colors.sendTime
        vBack.addSubview(lblTime)
        lblTime.enableAutolayout()
        lblTime.leadingMargin(20)
        lblTime.belowView(0, to: lblMessage)
        lblTime.fixHeight(16)
        lblTime.bottomMargin(10)
        
        btnSeeMore.setTitle("See More", for: .normal)
        btnSeeMore.setTitleColor(UIColor(red: 114/255, green: 154/255, blue: 207/255, alpha: 1), for: .normal)
        btnSeeMore.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnSeeMore.addTarget(self, action: #selector(HandleHeight(_:)), for: .touchUpInside)
        vBack.addSubview(btnSeeMore)
        btnSeeMore.enableAutolayout()
        btnSeeMore.trailingMargin(20)
        btnSeeMore.flexibleHeightGreater(1)
        btnSeeMore.centerY(to: lblTime)
    }
    
    @objc func HandleHeight(_ sender : UIButton) {
        delegate?.HandleHeight(index: sender.tag)
    }
    
    func configureCell(message : String, font: Float, dateAgoLbl: String){
        self.lblMessage.font = UIFont(name: Fonts.HelveticaNeueRegular, size: CGFloat(font))
        self.lblMessage.text = message
        self.lblTime.text = dateAgoLbl
    }
}

extension UILabel {
    func calculateMaxLines() -> Int {
        guard let text = text, let font = font else {
            return 0
        }
        let charSize = font.lineHeight
        let textSize = (text as NSString).boundingRect(
            with: CGSize(width: UIScreen.main.bounds.width - 20, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
