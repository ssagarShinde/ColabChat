//
//  VideoLinkCell.swift
//  ChatLib
//
//  Created by Sagar on 03/09/21.
//

import UIKit

class VideoLinkCell: UITableViewCell {

    let txtLink = UITextView()
    let btnSeeMore = UIButton()
    
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
        vBack.backgroundColor = UIColor(red: 242/255, green: 249/255, blue: 255/255, alpha: 1)
        self.contentView.addSubview(vBack)
        vBack.enableAutolayout()
        vBack.leadingMargin(20)
        vBack.flexibleWidthSmaller((screenWidth/2) + 50)
        vBack.topMargin(16)
        
        txtLink.isUserInteractionEnabled = true
        txtLink.isScrollEnabled = false
        txtLink.backgroundColor = .clear
        txtLink.dataDetectorTypes = .all
        vBack.addSubview(txtLink)
        txtLink.enableAutolayout()
        txtLink.leadingMargin(20)
        txtLink.fixHeight(100)
        txtLink.trailingMargin(20)
        txtLink.topMargin(10)
        
        btnSeeMore.setTitle("See More", for: .normal)
        btnSeeMore.setTitleColor(UIColor(red: 114/255, green: 154/255, blue: 207/255, alpha: 1), for: .normal)
        btnSeeMore.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnSeeMore.addTarget(self, action: #selector(HandleHeight(_:)), for: .touchUpInside)
        vBack.addSubview(btnSeeMore)
        btnSeeMore.enableAutolayout()
        btnSeeMore.leadingMargin(20)
        btnSeeMore.belowView(8, to: txtLink)
        btnSeeMore.flexibleHeightGreater(1)
        btnSeeMore.bottomMargin(0)
    }
    
    @objc func HandleHeight(_ sender : UIButton) {
        delegate?.HandleHeight(index: sender.tag)
    }
}
