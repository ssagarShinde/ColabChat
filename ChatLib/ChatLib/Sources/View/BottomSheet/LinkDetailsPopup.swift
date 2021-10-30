//
//  LinkDetailsPopup.swift
//  ChatLib
//
//  Created by Sagar on 08/10/21.
//

import UIKit

class LinkDetailsPopup: UIView, UITableViewDelegate, UITableViewDataSource {

    var delegate: SelectionDelegate?

    let backView = UIView()
    var options = [String]()
    var optionTitle = ""
    var tags = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI(arrData : History) {
        let btnBack = UIButton()
        btnBack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(btnBack)
        btnBack.enableAutolayout()
        btnBack.topMargin(0)
        btnBack.bottomMargin(0)
        btnBack.leadingMargin(0)
        btnBack.trailingMargin(0)
        backView.frame =  CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight * 0.6)
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 30
        btnBack.addSubview(backView)
        
        let ivLogo = UIImageView()
        ivLogo.clipsToBounds = true
        ivLogo.contentMode = .scaleAspectFill
        ivLogo.image = UIImage(named: "colabClipboard", in: Bundle(for: type(of: self)), compatibleWith:  nil)
        backView.addSubview(ivLogo)
        ivLogo.enableAutolayout()
        ivLogo.leadingMargin(40)
        ivLogo.topMargin(20)
        ivLogo.fixHeight(40)
        ivLogo.fixWidth(40)
        
        let lblTitle = UILabel()
        lblTitle.textColor = Colors.theme
        lblTitle.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 18)
        lblTitle.text = "Case Details"
        lblTitle.textAlignment = .left
        backView.addSubview(lblTitle)
        lblTitle.enableAutolayout()
        lblTitle.add(toRight: 20, of: ivLogo)
        lblTitle.topMargin(25)
        
        let btnCross = UIButton()
        btnCross.clipsToBounds = true
        btnCross.setImage(UIImage(named: "colabCross", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
        btnCross.addTarget(self, action: #selector(removeSelf), for: UIControl.Event.touchUpInside)
        backView.addSubview(btnCross)
        btnCross.enableAutolayout()
        btnCross.trailingMargin(20)
        btnCross.centerY(to: lblTitle)
        btnCross.fixHeight(50)
        btnCross.fixWidth(50)
        
        let separator = UIView()
        separator.clipsToBounds = true
        separator.backgroundColor = Colors.sendTime
        backView.addSubview(separator)
        separator.enableAutolayout()
        separator.leadingMargin(0)
        separator.belowView(20, to: ivLogo)
        separator.fixHeight(1)
        separator.trailingMargin(0)
        
        let scrollViewMain = CustomeScrollView()
        scrollViewMain.backgroundColor = .white
        scrollViewMain.bounces = false
        scrollViewMain.isScrollEnabled = true
        scrollViewMain.showsVerticalScrollIndicator = true
        backView.addSubview(scrollViewMain)
        scrollViewMain.enableAutolayout()
        scrollViewMain.leadingMargin(0)
        scrollViewMain.trailingMargin(0)
        scrollViewMain.belowView(0, to: separator)
        scrollViewMain.bottomMargin(Constraints.bottom)
        
        // Main View Under Scroll View
        let viewBack = UIView()
        viewBack.backgroundColor = .white
        scrollViewMain.addSubview(viewBack)
        viewBack.enableAutolayout()
        viewBack.centerX()
        viewBack.fixWidth(screenWidth)
        viewBack.topMargin(0)
        viewBack.bottomMargin(0)
        viewBack.flexibleHeightGreater(0)
        
        let lblTicketNumber = CustomLabel()
        lblTicketNumber.setupClass(textFirst: "Ticket Number", textSecond: arrData.caseid ?? "")
        viewBack.addSubview(lblTicketNumber)
        lblTicketNumber.enableAutolayout()
        lblTicketNumber.topMargin(20)
        lblTicketNumber.leadingMargin(0)
        lblTicketNumber.trailingMargin(0)
        lblTicketNumber.flexibleHeightGreater(20)
        
        let lblDateTime = CustomLabel()
        lblDateTime.setupClass(textFirst: "Date & Time", textSecond: arrData.createdDate ?? "")
        viewBack.addSubview(lblDateTime)
        lblDateTime.enableAutolayout()
        lblDateTime.belowView(25, to: lblTicketNumber)
        lblDateTime.leadingMargin(0)
        lblDateTime.trailingMargin(0)
        lblDateTime.flexibleHeightGreater(20)
        
        let lblSubject = CustomLabel()
        lblSubject.setupClass(textFirst: "Subject", textSecond: arrData.subject ?? "")
        viewBack.addSubview(lblSubject)
        lblSubject.enableAutolayout()
        lblSubject.belowView(25, to: lblDateTime)
        lblSubject.leadingMargin(0)
        lblSubject.trailingMargin(0)
        lblSubject.flexibleHeightGreater(20)
        
        let lblStatus = CustomLabel()
        lblStatus.setupClass(textFirst: "Status", textSecond: arrData.status ?? "")
        viewBack.addSubview(lblStatus)
        lblStatus.enableAutolayout()
        lblStatus.belowView(25, to: lblSubject)
        lblStatus.leadingMargin(0)
        lblStatus.trailingMargin(0)
        lblStatus.flexibleHeightGreater(20)
        
        let lblCategory = CustomLabel()
        lblCategory.setupClass(textFirst: "Category", textSecond: "")
        viewBack.addSubview(lblCategory)
        lblCategory.enableAutolayout()
        lblCategory.belowView(25, to: lblStatus)
        lblCategory.leadingMargin(0)
        lblCategory.trailingMargin(0)
        lblCategory.flexibleHeightGreater(20)
        
        let lblLocation = CustomLabel()
        lblLocation.setupClass(textFirst: "Location", textSecond:  "")
        viewBack.addSubview(lblLocation)
        lblLocation.enableAutolayout()
        lblLocation.belowView(25, to: lblCategory)
        lblLocation.leadingMargin(0)
        lblLocation.trailingMargin(0)
        lblLocation.flexibleHeightGreater(20)
        lblLocation.bottomMargin(20)
    
        animate()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellID")

        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size:16)
        cell.textLabel?.text = options[indexPath.row]

        let seperator = UIView(frame: CGRect(x: 0, y: 49, width: screenWidth, height: 1))
        seperator.backgroundColor = Colors.sendTime
        cell.addSubview(seperator)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewBooking = UIView()
        viewBooking.layer.cornerRadius = 12
        viewBooking.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewBooking.backgroundColor = Colors.theme

        let lblBooking = UILabel()
        lblBooking.textColor = UIColor.white
        lblBooking.textAlignment = .center
        lblBooking.backgroundColor = .clear
        lblBooking.text = optionTitle
        lblBooking.font = UIFont.init(name: Fonts.HelveticaNeueMedium, size: 18)
        viewBooking.addSubview(lblBooking)
        lblBooking.enableAutolayout()
        lblBooking.centerY()
        lblBooking.leadingMargin(20)
        lblBooking.fixHeight(40)
        lblBooking.trailingMargin(20)

        return viewBooking
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.SelectedText(tag: tags, text: options[indexPath.row], index: indexPath.row)
        animateDissmiss()
    }

    func animate() {
        UIView.animate(withDuration: 0.3) {
            self.backView.frame.origin.y = screenHeight - (screenHeight * 0.6)
        }
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
}
