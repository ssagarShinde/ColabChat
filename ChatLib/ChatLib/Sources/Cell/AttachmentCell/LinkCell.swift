//
//  LinkCell.swift
//  ChatLib
//
//  Created by Sagar on 09/08/21.
//

import UIKit

class LinkCell: UITableViewCell {
    
    var size = 14.0
    let btnOpenLink = UIButton()
    let lblTime = UILabel()
    let lblAgent = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let vBack = UIView()
        vBack.layer.cornerRadius = 20
        vBack.backgroundColor = UIColor(red: 237/255, green: 236/255, blue: 232/255, alpha: 1)
        self.contentView.addSubview(vBack)
        vBack.enableAutolayout()
        vBack.topMargin(8)
        vBack.leadingMargin(20)
        vBack.flexibleWidthGreater(230)
       
        
        
        lblAgent.text = "Agent has shared a link"
        lblAgent.textColor = .black
        lblAgent.numberOfLines = 2
        lblAgent.font = UIFont.systemFont(ofSize: CGFloat(size))
        vBack.addSubview(lblAgent)
        lblAgent.enableAutolayout()
        lblAgent.topMargin(8)
        lblAgent.flexibleHeightGreater(30)
        lblAgent.trailingMargin(40)
        lblAgent.leadingMargin(40)
        
        
        btnOpenLink.layer.cornerRadius = 20
        btnOpenLink.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        btnOpenLink.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        btnOpenLink.setTitle("Open Link", for: .normal)
        btnOpenLink.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(size))
        btnOpenLink.setTitleColor(.black, for: .normal)
        vBack.addSubview(btnOpenLink)
        btnOpenLink.enableAutolayout()
        btnOpenLink.belowView(8, to: lblAgent)
        btnOpenLink.fixHeight(30)
        btnOpenLink.leadingMargin(0)
        btnOpenLink.trailingMargin(0)
        btnOpenLink.bottomMargin(0)
        
        lblTime.text = "5 hours"
        lblTime.textColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        lblTime.numberOfLines = 0
        lblTime.font = UIFont.systemFont(ofSize: CGFloat(size - 2))
        self.contentView.addSubview(lblTime)
        lblTime.enableAutolayout()
        lblTime.belowView(0, to: vBack)
        lblTime.flexibleHeightGreater(18)
        lblTime.leadingMargin(25)
        lblTime.bottomMargin(4)
    }
}
