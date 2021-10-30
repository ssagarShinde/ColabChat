//
//  TempViewController.swift
//  ChatLib
//
//  Created by Sagar on 11/08/21.
//

import UIKit

public class TempViewController: UIViewController {

    let tblView = UITableView()
    let sizeBackView = UIView()
    let lblSize = UILabel()
    
    let viewNavigationBarBase = UIView()
    let lblNavTitle = UILabel()
    let lblNavTitleMiddle = UILabel()
    let btnNavBack = UIButton()
    var chatSdk : ChatSocketHelper?
    var chatInteractionId = ""
    
    let viewMessage = UIView()
    
    let arrData = [[String:Any]]()
    var arrIndex = [4,4,4,4,4,4,4,4,4,4]
    
    
    private var messageViewModel: MessageVM = MessageVM()
    
    var tappedImageView : ImageView = .fromNib()
    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var lableHeight : Float = 14
    
    var isOpen = "F"
    var isZoomViewOpen = "T"
    var isSent : Bool = false
    
    var expandedCells = Set<Int>()

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupUI() {
        
        viewNavigationBarBase.backgroundColor = UIColor(red: 21/255, green: 60/255, blue: 105/255, alpha: 1)
        self.view.addSubview(viewNavigationBarBase)
        viewNavigationBarBase.enableAutolayout()
        viewNavigationBarBase.leadingMargin(0)
        viewNavigationBarBase.trailingMargin(0)
        viewNavigationBarBase.topMargin(0)
        viewNavigationBarBase.fixHeight(BaseController.getStatusBarHeight + 53)
        
        
        // Back Button
        btnNavBack.tintColor = .white
        btnNavBack.setImage( UIImage(named: "colabBack", in: Bundle(for: type(of: self
        )), compatibleWith: nil), for: .normal)
        btnNavBack.addTarget(self, action: #selector(handleBack(_:)), for: .touchUpInside)
        viewNavigationBarBase.addSubview(btnNavBack)
        btnNavBack.enableAutolayout()
        btnNavBack.leadingMargin(10)
        btnNavBack.bottomMargin(15)
        btnNavBack.fixWidth(27)
        btnNavBack.fixHeight(22)
        
        lblNavTitleMiddle.text = "Chat History"
        lblNavTitleMiddle.textAlignment = .left
        lblNavTitleMiddle.textColor = .white
        lblNavTitleMiddle.numberOfLines = 2
        lblNavTitleMiddle.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 18)
        viewNavigationBarBase.addSubview(lblNavTitleMiddle)
        lblNavTitleMiddle.enableAutolayout()
        lblNavTitleMiddle.add(toRight: 16, of: btnNavBack)
        lblNavTitleMiddle.centerY(to: btnNavBack)
        
        let btnZoom = UIButton()
        btnZoom.tag = 0
        btnZoom.tintColor = .white
        btnZoom.setImage( UIImage(named: "colabZoomInOut", in: Bundle(for: type(of: self
        )), compatibleWith: nil), for: .normal)
        btnZoom.addTarget(self, action: #selector(HandleZoomBtn(_:)), for: .touchUpInside)
        viewNavigationBarBase.addSubview(btnZoom)
        btnZoom.enableAutolayout()
        btnZoom.trailingMargin(20)
        btnZoom.bottomMargin(8)
        btnZoom.fixWidth(35)
        btnZoom.fixHeight(40)
        
        let stackView = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = .fill
        stackView.spacing   = 0
        stackView.alignment = .center
        self.view.addSubview(stackView)
        stackView.enableAutolayout()
        stackView.leadingMargin(0)
        stackView.trailingMargin(0)
        stackView.belowView(0, to: viewNavigationBarBase)
        stackView.bottomMargin(0)
        
        stackView.addArrangedSubview(sizeBackView)
        stackView.addArrangedSubview(tblView)
        
        sizeBackView.isHidden = true
        sizeBackView.backgroundColor = UIColor(red: 20/255, green: 59/255, blue: 97/255, alpha: 1)
        stackView.addSubview(sizeBackView)
        sizeBackView.enableAutolayout()
        sizeBackView.leadingMargin(0)
        sizeBackView.trailingMargin(0)
        sizeBackView.topMargin(0)
        sizeBackView.fixHeight(40)
        
        let btnSizeIncrease = UIButton()
        if #available(iOS 13.0, *) {
            btnSizeIncrease.setImage(UIImage(systemName: "plus.magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            btnSizeIncrease.setImage(UIImage(named: "plus.magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        btnSizeIncrease.tintColor = .white
        btnSizeIncrease.addTarget(self, action: #selector(HandleIncreaseBtn(_:)), for: .touchUpInside)
        sizeBackView.addSubview(btnSizeIncrease)
        btnSizeIncrease.enableAutolayout()
        btnSizeIncrease.trailingMargin(20)
        btnSizeIncrease.centerY()
        btnSizeIncrease.fixWidth(40)
        btnSizeIncrease.fixHeight(40)
        
        lblSize.text = "100%"
        lblSize.textAlignment = .center
        lblSize.textColor = .white
        lblSize.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 18)
        sizeBackView.addSubview(lblSize)
        lblSize.enableAutolayout()
        lblSize.add(toLeft : 20, of: btnSizeIncrease)
        lblSize.centerY()
        lblSize.flexibleWidthGreater(20)
        

        let btnSizeDecrease = UIButton()
        
        if #available(iOS 13.0, *) {
            btnSizeDecrease.setImage(UIImage(systemName: "minus.magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            btnSizeDecrease.setImage(UIImage(named: "minus.magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        btnSizeDecrease.tintColor = .white
        btnSizeDecrease.addTarget(self, action: #selector(HandleDecreaseBtn(_:)), for: .touchUpInside)
        sizeBackView.addSubview(btnSizeDecrease)
        btnSizeDecrease.enableAutolayout()
        btnSizeDecrease.add(toLeft: 20, of: lblSize)
        btnSizeDecrease.centerY()
        btnSizeDecrease.fixWidth(40)
        btnSizeDecrease.fixHeight(40)
        
        tblView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tblView.backgroundColor = .white
        tblView.delegate = self
        tblView.dataSource = self
        tblView.bounces = false
        tblView.separatorStyle = .none
        tblView.backgroundColor = UIColor.white
        tblView.estimatedRowHeight = UITableView.automaticDimension
        tblView.rowHeight = UITableView.automaticDimension
        tblView.showsVerticalScrollIndicator = false
        tblView.isScrollEnabled = true
        stackView.addSubview(tblView)
        tblView.enableAutolayout()
        tblView.belowView(0, to: sizeBackView)
        tblView.leadingMargin(0)
        tblView.trailingMargin(0)
        tblView.bottomMargin(Constraints.bottom)
        
        viewMessage.isHidden = true
        viewMessage.accessibilityHint = "NoData"
        tblView.addSubview(viewMessage)
        viewMessage.enableAutolayout()
        viewMessage.leadingMargin(0)
        viewMessage.fixWidth(screenWidth)
        viewMessage.fixHeight(420)
        viewMessage.centerX()
        viewMessage.centerY()
        
        let ivEmpty = UIImageView()
        ivEmpty.clipsToBounds = true
        ivEmpty.contentMode = .scaleAspectFit
        ivEmpty.accessibilityHint = "NoData"
        ivEmpty.image = UIImage.init(named: "colabNoMessage", in: Bundle(for: type(of: self)), compatibleWith: nil)
        viewMessage.addSubview(ivEmpty)
        ivEmpty.enableAutolayout()
        ivEmpty.centerX()
        ivEmpty.fixWidth(250)
        ivEmpty.fixHeight(300)
        ivEmpty.topMargin(0)
        
        let messageLabel = UILabel()
        messageLabel.accessibilityHint = "NoData"
        messageLabel.text = "No Conversation Found!"
        messageLabel.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 18)
        messageLabel.sizeToFit()
        viewMessage.addSubview(messageLabel)
        messageLabel.enableAutolayout()
        messageLabel.fixWidth(screenWidth - 50)
        messageLabel.centerX()
        messageLabel.belowView(20, to: ivEmpty)
        messageLabel.flexibleWidthGreater(20)
    }
    
    //MARK:- Open Sent Image
    @objc func openSentImageFunc(gesture: UITapGestureRecognizer){
        
    }
    
    
    @objc func handleBack(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func HandleZoomBtn(_ sender : UIButton) {
        
    }
    
    @objc func HandleIncreaseBtn(_ sender : UIButton) {
        
    }
    
    @objc func HandleDecreaseBtn(_ sender : UIButton) {
        
    }
    
    func setupTableview() {
        tblView.separatorStyle = .none
        tblView.register(UINib(nibName: "SystemMessageCell", bundle: Bundle(for: SystemMessageCell.self)), forCellReuseIdentifier: "SystemMessageCell")
        
        tblView.register(UINib(nibName: "MessageAttachementSendTVC", bundle: Bundle(for: MessageAttachementSendTVC.self)), forCellReuseIdentifier: "MessageAttachementSendTVC")
        tblView.register(UINib(nibName: "MessageAttachementReceiveTVC", bundle: Bundle(for: MessageAttachementReceiveTVC.self)), forCellReuseIdentifier: "MessageAttachementReceiveTVC")
        tblView.register(UINib(nibName: "MessageSend", bundle: Bundle(for: MessageSend.self)), forCellReuseIdentifier: "MessageSend")
        tblView.register(UINib(nibName: "MessageReceive", bundle: Bundle(for: MessageReceive.self)), forCellReuseIdentifier: "MessageReceive")
        tblView.register(LinkCell.self, forCellReuseIdentifier: "LinkCell")
        tblView.register(VideoLinkCell.self, forCellReuseIdentifier: "VideoLinkCell")
    }
}

extension TempViewController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       /* if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8) {
            let cell = MessageSendCell()
            cell.selectionStyle = .none
            cell.lblMessage.text = "tableView: UITableView)"
            
            if (arrIndex[indexPath.row] == 0) {
                cell.lblMessage.numberOfLines = 0
                cell.btnSeeMore.setTitle("See Less", for: .normal)
            }
            else {
                cell.lblMessage.numberOfLines = 4
                cell.btnSeeMore.setTitle("See More", for: .normal)
            }
            
            let numOfLines = cell.lblMessage.numberOfLines
            if (numOfLines > 5) {
                cell.btnSeeMore.isHidden = false
            }
            else {
                cell.btnSeeMore.setTitle("", for: .normal)
                cell.btnSeeMore.isHidden = true
            }
        
            cell.delegate = self
            cell.btnSeeMore.tag = indexPath.row
            
            return cell
        }
        else {
            let cell = MessageReceivedCell()
            cell.selectionStyle = .none
            cell.lblMessage.text = "tableView: UITableView, cellForRowAt indexPath: IndexPath) tableView: UITableView, cellForRowAt indexPath: IndexPath) tableView: UITableView, cellForRowAt indexPath: IndexPath) tableView: UITableView, cellForRowAt indexPath: IndexPath) tableView: UITableView, cellForRowAt indexPath: IndexPath) tableView: UITableView, cellForRowAt indexPath: IndexPath) tableView: UITableView, cellForRowAt indexPath: IndexPath)"
            if (arrIndex[indexPath.row] == 0) {
               // cell.lblMessage.numberOfLines = 0
                cell.btnSeeMore.setTitle("See Less", for: .normal)
            }
            else {
                //cell.lblMessage.numberOfLines = 4
                cell.btnSeeMore.setTitle("See More", for: .normal)
            }
            cell.delegate = self
            cell.btnSeeMore.tag = indexPath.row
            
            return cell
        }*/
        
        let cell = MessageReceivedCell()
        cell.selectionStyle = .none
        cell.configureCell(message: "Tcd chbd  gc c  nbc   bdv  d c dhnc  hd c bcdn bcnd bcd bn cb bcd cd cd cd", font: lableHeight, dateAgoLbl: "5 hours ago")
        cell.lblMessage.numberOfLines = 0
        return cell
        
    }
}

extension TempViewController : ReloadTableHeightPr {
    func HandleHeight(index: Int) {
        if (arrIndex[index] == 0) {
            arrIndex[index] = 4
        }
        else {
            arrIndex[index] = 0
        }
        self.tblView.reloadData()
    }
}
