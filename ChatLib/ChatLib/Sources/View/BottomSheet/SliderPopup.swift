//
//  Slider.swift
//  ChatLib
//
//  Created by Sagar on 23/09/21.
//

import UIKit

protocol SelectionDelegate {
    func SelectedText(tag: Int, text: String, index: Int)
}

class SliderPopup: UIView, UITableViewDelegate, UITableViewDataSource {

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

    func createUI(title: String, arrOption: [String],tag : Int) {

        options = arrOption
        optionTitle = title
        self.tags = tag

        let btnBack = UIButton()
        btnBack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        btnBack.addTarget(self, action: #selector(removeSelf), for: UIControl.Event.touchUpInside)
        addSubview(btnBack)
        btnBack.enableAutolayout()
        btnBack.topMargin(0)
        btnBack.bottomMargin(0)
        btnBack.leadingMargin(0)
        btnBack.trailingMargin(0)

        tblViewSlider.frame =  CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight * 0.5)
        tblViewSlider.layer.cornerRadius = 12
        tblViewSlider.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tblViewSlider.backgroundColor = .white
        tblViewSlider.delegate = self
        tblViewSlider.dataSource = self
        tblViewSlider.bounces = false
        tblViewSlider.separatorStyle = .none
        tblViewSlider.backgroundColor = UIColor.white
        tblViewSlider.rowHeight = 50
        tblViewSlider.sectionHeaderHeight = 50
        if #available(iOS 15.0, *) {
            tblViewSlider.sectionHeaderTopPadding = 0
        }
        tblViewSlider.sectionFooterHeight = .leastNonzeroMagnitude
        tblViewSlider.showsVerticalScrollIndicator = false
        btnBack.addSubview(tblViewSlider)

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
            self.tblViewSlider.frame.origin.y = screenHeight - (screenHeight * 0.5)
        }
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
