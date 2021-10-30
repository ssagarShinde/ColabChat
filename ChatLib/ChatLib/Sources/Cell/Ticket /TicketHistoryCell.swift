//
//  TicketHistoryCell.swift
//  ChatLib
//
//  Created by Sagar on 22/09/21.
//

import UIKit

class TicketHistoryCell: UITableViewCell {
    
    let lblTicketNumber = UILabel()
    let lblReason = UILabel()
    let lblDate = UILabel()
    let lblStatus = UILabel()
    
    
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
        vBack.layer.cornerRadius = 16
        vBack.backgroundColor = Colors.lightBackground
        vBack.layer.masksToBounds = false
        vBack.layer.shadowColor = UIColor.black.cgColor
        vBack.layer.shadowOpacity = 0.2
        vBack.layer.shadowOffset = CGSize.zero
        vBack.layer.shadowRadius = 2
        self.contentView.addSubview(vBack)
        vBack.enableAutolayout()
        vBack.leadingMargin(25)
        vBack.trailingMargin(25)
        vBack.topMargin(16)
        vBack.bottomMargin(8)
        
        lblTicketNumber.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblTicketNumber.numberOfLines = 0
        lblTicketNumber.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 15)
        lblTicketNumber.textColor = Colors.theme
        vBack.addSubview(lblTicketNumber)
        lblTicketNumber.enableAutolayout()
        lblTicketNumber.trailingMargin(50)
        lblTicketNumber.leadingMargin(25)
        lblTicketNumber.fixHeight(20)
        lblTicketNumber.topMargin(20)
        
        lblReason.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblReason.numberOfLines = 0
        lblReason.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 17)
        lblReason.textColor = UIColor.black
        vBack.addSubview(lblReason)
        lblReason.enableAutolayout()
        lblReason.trailingMargin(50)
        lblReason.leadingMargin(25)
        lblReason.flexibleHeightGreater(20)
        lblReason.belowView(4, to: lblTicketNumber)
        
        lblDate.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblDate.numberOfLines = 0
        lblDate.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 15)
        lblDate.textColor = Colors.sendTime
        vBack.addSubview(lblDate)
        lblDate.enableAutolayout()
        lblDate.trailingMargin(50)
        lblDate.leadingMargin(25)
        lblDate.fixHeight(20)
        lblDate.belowView(4, to: lblReason)
        lblDate.bottomMargin(20)
        
        lblStatus.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblStatus.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 15)
        lblStatus.textAlignment = .left
        lblStatus.numberOfLines = 0
        vBack.addSubview(lblStatus)
        lblStatus.enableAutolayout()
        lblStatus.trailingMargin(20)
        lblStatus.fixHeight(20)
        lblStatus.centerY(to: lblDate)
    }
    
    
    func setupData(ticketNumber : String, reason : String, date : String, status : String) {
        
        self.lblTicketNumber.text = ticketNumber
        self.lblReason.text = reason
        self.lblDate.text = date
        
        if (status == "CLOSE") {
            lblStatus.text = "CLOSE"
            lblStatus.textColor = Colors.green
        }
        else {
            lblStatus.text = "OPEN"
            lblStatus.textColor = Colors.red
        }
    }
}
