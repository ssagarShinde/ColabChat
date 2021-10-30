//
//  LinkFilterPopup.swift
//  ChatLib
//
//  Created by Sagar on 07/10/21.
//

import UIKit

class LinkFilterPopup: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let backView = UIView()
    var delegate: SelectionDelegate?
    var delegateMulti: MultiSelectionDelegate?

    let tblViewSlider = UITableView()
    var isMultiSelect:Bool = false
    var options = [String]()
    var arrChecked = [String]()
    var optionTitle = ""
    var ID = 0
    var tags = 0
    
    var heightConstraint : NSLayoutConstraint?

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
     //   btnBack.addTarget(self, action: #selector(removeSelf), for: UIControl.Event.touchUpInside)
        addSubview(btnBack)
        btnBack.enableAutolayout()
        btnBack.topMargin(0)
        btnBack.bottomMargin(0)
        btnBack.leadingMargin(0)
        btnBack.trailingMargin(0)
        
        backView.frame =  CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight * 0.35)
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 30
        btnBack.addSubview(backView)
        
        
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setImage(UIImage(named: "colabCross", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(removeSelf), for: .touchUpInside)
        backView.addSubview(btn)
        btn.enableAutolayout()
        btn.fixHeight(40)
        btn.fixWidth(40)
        btn.topMargin(20)
        btn.leadingMargin(16)

        let lblBooking = UILabel()
        lblBooking.textColor = UIColor.darkGray
        lblBooking.textAlignment = .left
        lblBooking.backgroundColor = .clear
        lblBooking.text = "Filters"
        lblBooking.font = UIFont.init(name: Fonts.HelveticaNeueMedium, size: 20)
        backView.addSubview(lblBooking)
        lblBooking.enableAutolayout()
        lblBooking.centerY(to: btn)
        lblBooking.add(toRight: 10, of: btn)
        lblBooking.fixHeight(40)
        
        let seperator = UIView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: 1))
        seperator.backgroundColor = UIColor.gray
        backView.addSubview(seperator)
        seperator.enableAutolayout()
        seperator.belowView(8, to: btn)
        seperator.leadingMargin(20)
        seperator.fixHeight(1)
        seperator.trailingMargin(20)
        
        let btnClear = UIButton()
        btnClear.backgroundColor = .white
        btnClear.setTitle("CLEAR", for: .normal)
        btnClear.setTitleColor(Colors.theme, for: .normal)
        btnClear.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 15)
        btnClear.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        backView.addSubview(btnClear)
        btnClear.enableAutolayout()
        btnClear.trailingMargin(20)
        btnClear.fixHeight(50)
        btnClear.fixWidth(70)
        btnClear.centerY(to: btn)
        
        tblViewSlider.backgroundColor = UIColor.white
        tblViewSlider.delegate = self
        tblViewSlider.allowsMultipleSelection = true
        tblViewSlider.dataSource = self
        tblViewSlider.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tblViewSlider.bounces = false
        tblViewSlider.separatorStyle = .none
        tblViewSlider.backgroundColor = UIColor.white
        tblViewSlider.rowHeight = 50
        tblViewSlider.sectionHeaderHeight = UITableView.automaticDimension
        tblViewSlider.sectionFooterHeight = UITableView.automaticDimension
        if #available(iOS 15.0, *) {
            tblViewSlider.sectionHeaderTopPadding = 0
        }
        tblViewSlider.showsVerticalScrollIndicator = false
        backView.addSubview(tblViewSlider)
        tblViewSlider.enableAutolayout()
        tblViewSlider.belowView(0, to: seperator)
        tblViewSlider.leadingMargin(20)
        tblViewSlider.trailingMargin(20)
        tblViewSlider.bottomMargin(0)

        animate()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewBooking = UIView()
        viewBooking.layer.cornerRadius = 12
        viewBooking.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewBooking.backgroundColor = UIColor.white
        
        let btn = UIButton()
        if arrChecked.contains("TRUE") {
            btn.backgroundColor = Colors.theme
            btn.isEnabled = true
        }
        else {
            btn.backgroundColor = UIColor.gray
            btn.isEnabled = false
        }
        
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.imageView?.tintColor = UIColor.white
        
        btn.setTitle("APPLY", for: .normal)
        btn.addTarget(self, action: #selector(removeMulti), for: .touchUpInside)
        viewBooking.addSubview(btn)
        btn.enableAutolayout()
        btn.leadingMargin(20)
        btn.topMargin(16)
        btn.trailingMargin(20)
        btn.bottomMargin(8)
        btn.fixHeight(40)
        
        return viewBooking
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
        
        let ivCheck = UIImageView()
        ivCheck.clipsToBounds = true
        ivCheck.contentMode = .scaleToFill
        ivCheck.image = UIImage(named: "colabCheckBoxFill", in: Bundle(for: type(of: self)), compatibleWith: nil)
        cell.contentView.addSubview(ivCheck)
        ivCheck.enableAutolayout()
        ivCheck.fixWidth(30)
        ivCheck.fixHeight(30)
        ivCheck.centerY()
        ivCheck.trailingMargin(16)
        
        if isMultiSelect {
            if (arrChecked.count > 0) {
                if arrChecked[indexPath.row] == "TRUE" {
                    ivCheck.image = UIImage(named: "colabCheckBoxBlank", in: Bundle(for: type(of: self)), compatibleWith: nil)
                }
            }
        }
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = UIView()
        hView.backgroundColor = Colors.sendTime.withAlphaComponent(0.8)
        
        let lblBooking = UILabel()
        lblBooking.textColor = UIColor.darkGray
        lblBooking.textAlignment = .left
        lblBooking.backgroundColor = .clear
        lblBooking.text = "CASE STATUS"
        lblBooking.font = UIFont.init(name: Fonts.HelveticaNeueRegular, size: 14)
        hView.addSubview(lblBooking)
        lblBooking.enableAutolayout()
        lblBooking.topMargin(0)
        lblBooking.fixHeight(30)
        lblBooking.leadingMargin(16)
        lblBooking.bottomMargin(0)
        
        return hView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMultiSelect {
            
            if (arrChecked.count > 1) {
                if arrChecked[indexPath.row] == "TRUE" {
                    arrChecked.remove(at: indexPath.row)
                    arrChecked.insert("FALSE", at: indexPath.row)
                } else {
                    arrChecked.remove(at: indexPath.row)
                    arrChecked.insert("TRUE", at: indexPath.row)
                }
            }
            self.tblViewSlider.reloadData()
        }
        
        else {
            delegate?.SelectedText(tag:self.tags, text: options[indexPath.row], index: indexPath.row)
            self.removeFromSuperview()
        }
    }

    /*func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
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
    }*/

    func animate() {
        UIView.animate(withDuration: 0.3) {
            self.backView.frame.origin.y = screenHeight - (screenHeight * 0.35)
        }
    }

    func animateDissmiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.frame.origin.y = screenHeight
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
    
    @objc func handleClear() {
        arrChecked.removeAll()
        arrChecked = options
        self.tblViewSlider.reloadData()
        removeMulti()
    }

    @objc func removeSelf() {
        animateDissmiss()
    }
}
