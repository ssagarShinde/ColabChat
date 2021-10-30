//
//  MultipleSlider.swift
//  ChatLib
//
//  Created by Sagar on 23/09/21.
//

import UIKit

protocol MultiSelectionDelegate {
    func multipleSelectedOption(_ selectedIndexes: [Int], _ multiText: String, _ tag: Int)
}

class MultiSliderPopup: UIView, UITableViewDelegate, UITableViewDataSource {

    var delegate: SelectionDelegate?
    var delegateMulti: MultiSelectionDelegate?

    let tblViewSlider = UITableView()
    var isMultiSelect:Bool = false
    var options = [String]()
    var arrChecked = [String]()
    var optionTitle = ""
    var ID = 0
    var tags = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI(title: String, arrOption: [String],isMulti:Bool,text:String, selectedArr : [Int], tags : Int) {

        options = arrOption
        arrChecked = arrOption
        optionTitle = title
        isMultiSelect = isMulti
        self.tags = tags

        if isMultiSelect == true {
            if text != "" {
                let arr = text.replacingOccurrences(of: ", ", with: ",").split(separator: ",")
                for idx in 0..<arr.count {
                    if self.options.firstIndex(of:String(arr[idx])) != nil {
                        let index = self.options.firstIndex(of:String(arr[idx]))
                        self.arrChecked.remove(at: index!)
                        self.arrChecked.insert("TRUE", at: index!)
                    }
                }
            }
        }

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
        tblViewSlider.backgroundColor = UIColor.white
        tblViewSlider.delegate = self
        tblViewSlider.allowsMultipleSelection = true
        tblViewSlider.dataSource = self
        tblViewSlider.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
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
        cell.selectionStyle = .none
        cell.accessoryType = .none

        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.text = options[indexPath.row]

        let seperator = UIView(frame: CGRect(x: 0, y: 49, width: screenWidth, height: 1))
        seperator.backgroundColor = Colors.sendTime
        cell.addSubview(seperator)

        if isMultiSelect {
            if arrChecked[indexPath.row] == "TRUE" {
                cell.accessoryType = .checkmark
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewBooking = UIView()
        viewBooking.layer.cornerRadius = 12
        viewBooking.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewBooking.backgroundColor = Colors.theme

        let lblBooking = UILabel()
        lblBooking.textColor = .white
        lblBooking.textAlignment = .left
        lblBooking.backgroundColor = .clear
        lblBooking.text = optionTitle
        lblBooking.font = UIFont.init(name: Fonts.HelveticaNeueMedium, size: 18)
        viewBooking.addSubview(lblBooking)
        lblBooking.enableAutolayout()
        lblBooking.centerY()
        lblBooking.leadingMargin(20)
        lblBooking.fixHeight(40)
        lblBooking.trailingMargin(20)

        if isMultiSelect {
            let btn = UIButton()
            btn.backgroundColor = Colors.theme
            btn.setTitle("Done", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
            btn.addTarget(self, action: #selector(removeMulti), for: .touchUpInside)
            viewBooking.addSubview(btn)
            btn.enableAutolayout()
            btn.trailingMargin(0)
            btn.fixHeight(50)
            btn.fixWidth(70)
            btn.centerY(to: lblBooking)
        }
        return viewBooking
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMultiSelect {
            let cell = tableView.cellForRow(at: indexPath)
            if arrChecked[indexPath.row] == "TRUE" {
                cell?.accessoryType = .none
                arrChecked.remove(at: indexPath.row)
                arrChecked.insert("FALSE", at: indexPath.row)
            } else {
                cell?.accessoryType = .checkmark
                arrChecked.remove(at: indexPath.row)
                arrChecked.insert("TRUE", at: indexPath.row)
            }
        }
        
        else {
            delegate?.SelectedText(tag:self.tags, text: options[indexPath.row], index: indexPath.row)
            self.removeFromSuperview()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isMultiSelect {
            let cell = tableView.cellForRow(at: indexPath)

            if arrChecked[indexPath.row] == "TRUE" {
                cell?.accessoryType = .none
                arrChecked.remove(at: indexPath.row)
                arrChecked.insert("FALSE", at: indexPath.row)
            } else {
                cell?.accessoryType = .checkmark
                arrChecked.remove(at: indexPath.row)
                arrChecked.insert("TRUE", at: indexPath.row)
            }
        }
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

    @objc func removeMulti() {
        var selectedIndex = [Int]()
        var selectedString = [String]()

        for idx in 0..<arrChecked.count {
            if arrChecked[idx] == "TRUE" {
                selectedIndex.append(idx)
                selectedString.append(options[idx])
            }
        }

        let text = selectedString.joined(separator: ", ")
        delegateMulti?.multipleSelectedOption(selectedIndex, text, self.tags)
        self.removeFromSuperview()
    }

    @objc func removeSelf() {
        animateDissmiss()
    }
}
