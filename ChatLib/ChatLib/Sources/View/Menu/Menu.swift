//
//  Menu.swift
//  ChatLib
//
//  Created by Sagar on 15/09/21.
//

import UIKit

protocol MenuPr {
    func value(text : String)
}

public class Menu: UIView {
    
    var options = [String]()
    var optionTitle = ""
    var windows = UIApplication.shared.keyWindow!
    
    let tblView = UITableView()
    var tblViewHeightConstraint : NSLayoutConstraint?
    var delegates : MenuPr?
    var nameArr = ["Home", "Video Call", "Feedback", "End Conversation", "Co-Browsing"]
    var imgArr = ["colabHome", "videoConference", "colabFeedback", "chat1", "user-experience"]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        tblViewHeightConstraint?.constant = tblView.contentSize.height
    }

    func createUI(y : CGFloat) {
        
        self.isUserInteractionEnabled = true
        let btnBack = UIButton()
        btnBack.backgroundColor = UIColor.clear
        btnBack.isUserInteractionEnabled = true
        btnBack.addTarget(self, action: #selector(handleBack(_:)), for: .touchUpInside)
        self.addSubview(btnBack)
        btnBack.enableAutolayout()
        btnBack.topMargin(0)
        btnBack.bottomMargin(0)
        btnBack.leadingMargin(0)
        btnBack.trailingMargin(0)
        
        tblView.tag = 100
        tblView.tableFooterView = UIView()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.estimatedRowHeight = UITableView.automaticDimension
        tblView.separatorStyle = .none
        tblView.backgroundColor = .white
        tblView.showsVerticalScrollIndicator = false
        tblView.isScrollEnabled = false
        tblView.bounces = true
        tblView.register(MenuCell.self, forCellReuseIdentifier: "cell")
        tblView.clipsToBounds = true
        tblView.addShadow()
        tblView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tblView.layer.cornerRadius = 20
        btnBack.addSubview(tblView)
        tblView.enableAutolayout()
        tblView.trailingMargin(20)
        tblView.topMargin(y)
        tblViewHeightConstraint = tblView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        tblViewHeightConstraint?.isActive = true
        tblView.fixWidth((screenWidth/2))
    }
    
    @objc func handleBack(_ sender : UIButton) {
        self.removeFromSuperview()
    }
}


extension Menu : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fView = UIView()
        fView.backgroundColor = .white
        
        let separator = UIView()
        separator.backgroundColor = Colors.sendTime
        fView.addSubview(separator)
        separator.enableAutolayout()
        separator.leadingMargin(0)
        separator.topMargin(8)
        separator.trailingMargin(0)
        separator.fixHeight(1)
        
        let text = UILabel()
        text.text = "© 2021 UNFYD® COMPASS"
        text.textColor = Colors.red
        text.textAlignment = .center
        text.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 13)
        fView.addSubview(text)
        text.enableAutolayout()
        text.leadingMargin(0)
        text.belowView(0, to: separator)
        text.trailingMargin(0)
        text.fixHeight(40)
        text.bottomMargin(0)
        
        return fView
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MenuCell
        cell.lblName.text = nameArr[indexPath.row]
        cell.ivIcon.image = UIImage(named: imgArr[indexPath.row], in: Bundle(for: type(of: self)), compatibleWith: nil)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegates?.value(text: nameArr[indexPath.row])
        self.removeFromSuperview()
    }
}
