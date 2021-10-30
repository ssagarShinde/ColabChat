//
//  PreviousChatHistory.swift
//  ChatLib
//
//  Created by Sagar on 07/08/21.
//

import Foundation

import UIKit


protocol ChatHistoryClickedProtocol {
    func clicked(chatInteractionId : String)
}



class PreviousChatHistory: UIView {
    
     var data = [[String : Any]]()
     var vc : UIViewController?
     let backView = UIView()
     let iv = UIImageView()
    
    var options = [String]()
    var optionTitle = ""
    
    let btnBack = UIButton()
    let tblViewSlider = UITableView()
    var tblViewHeightConstraint : NSLayoutConstraint?
    
    var delegate : ChatHistoryClickedProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func layoutSubviews() {
        tblViewHeightConstraint?.constant = tblViewSlider.contentSize.height + 30
    }

    func createUI() {
        
        self.removeFromSuperview()

      
        btnBack.isUserInteractionEnabled = true
        btnBack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btnBack.addTarget(self, action: #selector(removeSelf), for: .touchUpInside)
        addSubview(btnBack)
        btnBack.enableAutolayout()
        btnBack.bottomMargin(0)
        btnBack.leadingMargin(0)
        btnBack.trailingMargin(0)
        btnBack.topMargin(0)
        
        tblViewSlider.layer.cornerRadius = 30
        tblViewSlider.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tblViewSlider.backgroundColor = .white
        tblViewSlider.delegate = self
        tblViewSlider.dataSource = self
        tblViewSlider.bounces = false
        tblViewSlider.separatorStyle = .none
        tblViewSlider.backgroundColor = UIColor.white
        tblViewSlider.showsVerticalScrollIndicator = false
        tblViewSlider.isScrollEnabled = true
        tblViewSlider.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(tblViewSlider)
        tblViewSlider.enableAutolayout()
        tblViewSlider.leadingMargin(0)
        tblViewSlider.trailingMargin(0)
        tblViewSlider.bottomMargin(0)
        
        tblViewHeightConstraint = tblViewSlider.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        tblViewHeightConstraint?.isActive = true
        self.perform(#selector(handleHeight), with: self, afterDelay: 0.2)
        
        tblViewSlider.frame.origin.y = screenHeight
        animate()
    }
    
    @objc func handleHeight() {
        tblViewHeightConstraint?.constant = tblViewSlider.contentSize.height
    }
    
    @objc func animate() {
        UIView.animate(withDuration: 0.3) {
            self.tblViewSlider.frame.origin.y = (screenHeight - (self.tblViewSlider.contentSize.height))
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

extension PreviousChatHistory : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = UIView()
        hView.clipsToBounds = true
        hView.backgroundColor = .white
        
        let lblSignature = UILabel()
        lblSignature.text = "Previous Chat history"
        lblSignature.textColor = .black
        lblSignature.textAlignment = .center
        lblSignature.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 20)
        hView.addSubview(lblSignature)
        lblSignature.enableAutolayout()
        lblSignature.topMargin(16)
        lblSignature.leadingMargin(20)
        lblSignature.trailingMargin(20)
        lblSignature.fixHeight(30)
        
        let separator = UIView()
        separator.clipsToBounds = true
        separator.backgroundColor = .lightGray
        hView.addSubview(separator)
        separator.enableAutolayout()
        separator.belowView(16, to: lblSignature)
        separator.trailingMargin(0)
        separator.leadingMargin(0)
        separator.fixHeight(1)
        separator.bottomMargin(8)
        
        return hView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let hView = UIView()
        hView.clipsToBounds = true
        hView.backgroundColor = .white
        return hView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (data.count == 0) {
            return 1
        }
        else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (data.count == 0) {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            let text = "No Previous Chat Found"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
            cell.textLabel?.textColor = .darkText
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = text
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            return cell
        }
        else {
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            let text = data[indexPath.row]["createdOn"] as? String ?? ""
            cell.textLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
            cell.textLabel?.textColor = .darkText
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = text
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = data[indexPath.row]["chatInteractionId"] as? String ?? ""
        removeSelf()
        delegate?.clicked(chatInteractionId: id)
    }
}



