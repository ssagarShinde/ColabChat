//
//  MenuCell.swift
//  ChatLib
//
//  Created by Sagar on 15/09/21.
//

import UIKit

class MenuCell: UITableViewCell {
    
    let ivIcon = UIImageView()
    let lblName = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        self.contentView.clipsToBounds = true
        
        let vBack = UIView()
        vBack.layer.cornerRadius = 20
        vBack.backgroundColor = UIColor.white
        self.contentView.addSubview(vBack)
        vBack.enableAutolayout()
        vBack.leadingMargin(0)
        vBack.trailingMargin(0)
        vBack.topMargin(0)
        vBack.bottomMargin(0)
        
        ivIcon.clipsToBounds = true
        vBack.addSubview(ivIcon)
        ivIcon.enableAutolayout()
        ivIcon.leadingMargin(25)
        ivIcon.topMargin(12)
        ivIcon.fixWidth(20)
        ivIcon.fixHeight(20)
        ivIcon.bottomMargin(12)
        
        lblName.text = "Home"
        lblName.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 14)
        lblName.textColor = UIColor.darkText
        lblName.textAlignment = .left
        vBack.addSubview(lblName)
        lblName.enableAutolayout()
        lblName.add(toRight: 16, of: ivIcon)
        lblName.trailingMargin(8)
        lblName.centerY(to: ivIcon)
    }

}
