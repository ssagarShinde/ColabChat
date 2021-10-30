//
//  TicketHistoryVC.swift
//  ChatLib
//
//  Created by Sagar on 21/09/21.
//

import UIKit

public class TicketHistoryVC: BaseController {
    
    let scrollViewMain = UIScrollView()
    let viewBack = UIView()
    
    let tblView = UITableView()
    var selectedIndex = [Int]()
    
    var filterValues = ""
    let btnFilter = UIButton()
    let tblBackView = UIView()
    
    var db = DBHelper()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(self.caseListSuccess(_:)), name: NSNotification.Name(rawValue: "CaseListSuccess"), object: nil)
        setupUI()
        if ((SocketHelper.shared.socket?.status ?? .notConnected) == .connected)  {
            DispatchQueue.main.async {
                self.fetchList(status: ["'Open'","'Closed'"])
            }
        }
        else {
            SocketHelper.shared.establishConnection { status in
                DispatchQueue.main.async {
                    self.fetchList(status: ["'Open'","'Closed'"])
                }
            }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        createNavigationBar("Ticket History")
        btnNavBack.isHidden = true
        tblView.reloadData()
    }
    
    fileprivate func setupUI() {
        
        let btnCreateTicket = UIButton()
        btnCreateTicket.setTitle("Raise", for: .normal)
        btnCreateTicket.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 15)
        btnCreateTicket.setImage(UIImage(named: "colabAdd", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnCreateTicket.imageView?.tintColor = .white
        btnCreateTicket.alignTextBelow(spacing: 0)
        btnCreateTicket.addTarget(self, action: #selector(handleCreateTicket(_:)), for: .touchUpInside)
        viewNavigationBarBase.addSubview(btnCreateTicket)
        btnCreateTicket.enableAutolayout()
        btnCreateTicket.fixWidth(60)
        btnCreateTicket.bottomMargin(0)
        btnCreateTicket.fixHeight(60)
        btnCreateTicket.trailingMargin(20)
        
        btnFilter.clipsToBounds = true
        btnFilter.semanticContentAttribute = .forceRightToLeft
        btnFilter.setTitle("Filter ", for: .normal)
        btnFilter.setImage(UIImage(named: "colabArrowDownFill", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnFilter.imageView?.tintColor = .darkGray
        btnFilter.setTitleColor(UIColor.darkGray, for: .normal)
        btnFilter.layer.cornerRadius = 20
        btnFilter.backgroundColor = .white
        btnFilter.layer.borderColor = UIColor.darkGray.cgColor
        btnFilter.layer.borderWidth = 1
        btnFilter.addTarget(self, action: #selector(HandleBtnFilter(_:)), for: .touchUpInside)
        view.addSubview(btnFilter)
        btnFilter.enableAutolayout()
        btnFilter.trailingMargin(20)
        btnFilter.fixHeight(40)
        btnFilter.fixWidth(100)
        btnFilter.topMargin((BaseController.getStatusBarHeight + (self.navigationController?.navigationBar.frame.size.height ?? 0.0) + 30))
        
        
        tblBackView.backgroundColor = .white
        tblBackView.layer.cornerRadius = 20
        tblBackView.addShadow()
        tblBackView.layer.isHidden = false
        view.addSubview(tblBackView)
        tblBackView.enableAutolayout()
        tblBackView.belowView(20, to: btnFilter)
        tblBackView.leadingMargin(20)
        tblBackView.trailingMargin(20)
        tblBackView.bottomMargin((tabBarController?.tabBar.frame.size.height ?? 0) + 10)
        
        tblView.backgroundColor = .white
        tblView.delegate = self
        tblView.dataSource = self
        tblView.bounces = false
        tblView.separatorStyle = .none
        tblView.backgroundColor = UIColor.white
        tblView.estimatedRowHeight = UITableView.automaticDimension
        tblView.rowHeight = UITableView.automaticDimension
        tblView.showsVerticalScrollIndicator = true
        tblView.isScrollEnabled = true
        tblView.layer.cornerRadius = 20
        tblView.register(TicketHistoryCell.self, forCellReuseIdentifier: "cell")
        tblBackView.addSubview(tblView)
        tblView.enableAutolayout()
        tblView.topMargin(8)
        tblView.bottomMargin(8)
        tblView.trailingMargin(0)
        tblView.leadingMargin(0)
    }
    
    func fetchList(status : [String]) {
        if ((LinkSocket.shared.linkSocket?.status ?? .connected) == .connected) {
            let mainDict  = ["status": ["'Open'","'Closed'"]]
            let eventNameDict : [String:Any] = ["eventName":"caseList","data":mainDict]
            LinkSocket.shared.linkSocketEmit(eventName: "req", arg: eventNameDict)
        }
        else {
            LinkSocket.shared.fetchHistory(status: status)
        }
    }
    
    
    @objc func handleCreateTicket(_ sender : UIButton) {
        let vc = CreateTicketVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func HandleBtnFilter(_ sender : UIButton) {
        let popup = LinkFilterPopup()
        popup.isMultiSelect = true
        popup.delegateMulti = self
        popup.frame = view.bounds
        popup.createUI(title: "Select Option", arrOption: ["Open", "Closed"], isMulti: true, text: filterValues, selectedArr: self.selectedIndex, tags: sender.tag)
        UIApplication.shared.keyWindow?.addSubview(popup)
    }
    
    func numberOfUsers()->Int {
        let data = db.read()
        return data.count
    }
    
    func getUser(forIndex index :Int )-> History {
        let data = db.read()
        return data[index]
    }
}

extension TicketHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfUsers()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TicketHistoryCell
        let data =  getUser(forIndex: indexPath.row)
        
        let ticketNumber = data.caseid ?? ""
        let subject = data.subject ?? ""
        let date =  data.createdDate ?? ""
        let status  = (data.status ?? "").uppercased()
        cell.setupData(ticketNumber: ticketNumber, reason: subject, date: "Created on \(date)", status: status)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data =  getUser(forIndex: indexPath.row)
        let popup = LinkDetailsPopup()
        popup.frame = view.bounds
        popup.createUI(arrData: data)
        UIApplication.shared.keyWindow?.addSubview(popup)
    }
}

extension TicketHistoryVC  {
    @objc func caseListSuccess (_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            print(dict)
            let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            do {
                let data = try JSONDecoder().decode(LinkHistoryModel.self, from: jsonData!)
                LinkHistory.shared.obj = data.data?.datas ?? []
                
                for val in (data.data?.datas ?? []) {
                    self.db.insert(assignedToAgent: (val.assignedToAgent ?? ""), assignedToTeam: (val.assignedToTeam ?? ""), caseSource: (val.caseSource ?? ""), createdDate: (val.createdDate ?? ""), emailCC: (val.emailCC ?? ""), fullName: String(val.fullName ?? ""), lastIxnBy: (val.lastIxnBy ?? ""), lastIxnDate: (val.lastIxnDate ?? ""), primaryEmail: (val.primaryEmail ?? ""), primaryPhone: (val.primaryPhone ?? ""), requestedBy: (val.requestedBy ?? ""), requestorRemark: (val.requestorRemark ?? ""), status: (val.status ?? ""), subject: (val.subject ?? ""), uCreatedDate: (val.uCreatedDate ?? ""), uLastIxnDate: (val.uLastIxnDate ?? ""), caseid: (val.caseid ?? ""))
                }
                DispatchQueue.main.async {
                    self.tblBackView.layer.isHidden = false
                    self.tblView.reloadData()
                    self.view.layoutSubviews()
                }
            }
            catch let err {
                print(err)
            }
        }
    }
}

extension TicketHistoryVC : MultiSelectionDelegate {
    func multipleSelectedOption(_ selectedIndexes: [Int], _ multiText: String, _ tag: Int) {
        filterValues = multiText
        var str = [String]()
        
        if (multiText == "") {
            str = ["'Open'","'Closed'"]
            btnFilter.backgroundColor = .white
            btnFilter.layer.borderColor = UIColor.darkGray.cgColor
            btnFilter.layer.borderWidth = 1
        }
        else {
            let arr = multiText.components(separatedBy: ",")
            arr.forEach { element in
                str.append("'\(element)'")
            }
            btnFilter.backgroundColor = Colors.green.withAlphaComponent(0.2)
            btnFilter.layer.borderColor = Colors.green.cgColor
            btnFilter.layer.borderWidth = 2
         }
        
        let dic  = [ "status" : str ]
        let eventNameDict : [String:Any] = ["eventName":"caseList","data":dic]
        LinkSocket.shared.linkSocketEmit(eventName: "req", arg: eventNameDict)
        
        LinkHistory.shared.obj.removeAll()
        tblBackView.layer.isHidden = true
        self.tblView.reloadData()
        self.view.layoutSubviews()
    }
}

public extension UIButton {
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image
        {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
}
