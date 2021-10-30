//
//  ChatHistoryDetailsView.swift
//  ChatLib
//
//  Created by Sagar on 08/08/21.
//

import UIKit


public class ChatHistoryDetailsView: UIView {

    let tblView = UITableView()
    let sizeBackView = UIView()
    let lblSize = UILabel()
    
    let viewNavigationBarBase = UIView()
    let lblNavTitle = UILabel()
    let lblNavTitleMiddle = UILabel()
    let btnNavBack = UIButton()
    var chatInteractionId = ""
    
    let viewMessage = UIView()
    
    let arrData = [[String:Any]]()
    private var messageViewModel: MessageVM = MessageVM()
    
    var arrIndex = [Int]()
    
    var tappedImageView : ImageView = .fromNib()
    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var lableHeight : Float = 14
    
    var isOpen = "F"
    var isZoomViewOpen = "T"
    var isSent : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableview()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView(notification:)), name: NSNotification.Name(rawValue: "PreviousChatHistory"), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        viewNavigationBarBase.backgroundColor = Colors.theme
        self.addSubview(viewNavigationBarBase)
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
        self.addSubview(stackView)
        stackView.enableAutolayout()
        stackView.leadingMargin(0)
        stackView.trailingMargin(0)
        stackView.belowView(0, to: viewNavigationBarBase)
        stackView.bottomMargin(0)
        
        stackView.addArrangedSubview(sizeBackView)
        stackView.addArrangedSubview(tblView)
        
        sizeBackView.isHidden = true
        sizeBackView.backgroundColor = Colors.theme
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
        tblView.rowHeight = 50
        tblView.sectionHeaderHeight = 50
        tblView.sectionFooterHeight = 20
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
    
    @objc func updateTableView(notification : Notification) {
        
        var chatHistoryArray = [[String: Any]]()
        let dict = notification.userInfo! as NSDictionary
        let data = dict.value(forKey: "data")  as! NSDictionary
        chatHistoryArray = data.value(forKey: "chatHistory") as! [[String : Any]]
        if chatHistoryArray.count == 0 {
        }
        else{
            for i in 0..<chatHistoryArray.count{
                let currNr = chatHistoryArray[i] as NSDictionary
                if currNr.value(forKey: "Message")as! String == ""{
                    
                } else{
                    messageViewModel.messageArray.insert(currNr as! [String : Any], at: 0)
                    arrIndex.insert(4, at: 0)
                }
            }
            if (messageViewModel.messageArray.count == 0) {
               // self.tblView.setEmptyMessageImage("No Data", img: "NoMessage")
                viewMessage.isHidden = false
                arrIndex.removeAll()
            }
            else {
                messageViewModel.messageArray.reverse()
                viewMessage.isHidden = true
                self.tblView.reloadData()
            }
        }
    }
    
    //MARK:- Open Sent Image
    @objc func openSentImageFunc(gesture: UITapGestureRecognizer){
        
        let imageDic = messageViewModel.messageArray[gesture.view!.tag] as NSDictionary
        _ = URL(string: (imageDic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        // DataFile.savefile(imageURL: url!){(result) in
        DispatchQueue.main.async  {
            self.tappedImageView.delegate = self
            let screenSize = UIScreen.main.bounds.size
            self.tappedImageView.frame = CGRect(x: 0, y: BaseController.getStatusBarHeight, width: screenSize.width, height: screenSize.height)
            self.addSubview(self.tappedImageView)
            
            /* if let data = try? Data(contentsOf: url!) {
             DispatchQueue.main.async {
             self.tappedImageView.fullscreenImage.image = UIImage(data: data)
             }
             }*/
            
            self.tappedImageView.fullscreenImage.loadThumbnail(urlSting: (imageDic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (image) in
                
                DispatchQueue.main.async {
                    self.tappedImageView.fullscreenImage.image = image
                }
            }
        }
    }
    
    
    @objc func handleBack(_ sender : UIButton) {
        removeSelf()
    }
    
    @objc func HandleZoomBtn(_ sender : UIButton) {
        if (sender.tag == 0) {
            sizeBackView.isHidden = false
            sender.tag = 1
        }
        else {
            sizeBackView.isHidden = true
            sender.tag = 0
        }
    }
    
    @objc func HandleIncreaseBtn(_ sender : UIButton) {
        let text = (lblSize.text ?? "").replacingOccurrences(of: "%", with: "")
        let count = Int(text) ?? 0
        if (count < 180) {
            let newSize = (lableHeight + 10)/100
            lableHeight = lableHeight + newSize
            lblSize.text = "\(count + 10)%"
            tblView.reloadData()
        }
    }
    
    @objc func HandleDecreaseBtn(_ sender : UIButton) {
        let text = (lblSize.text ?? "").replacingOccurrences(of: "%", with: "")
        let count = Int(text) ?? 0
        if (count > 70) {
            let newSize = (lableHeight - 10)/100
            lableHeight = lableHeight - newSize
            lblSize.text = "\(count - 10)%"
            tblView.reloadData()
        }
    }
    
    @objc func handleOpenLinkBtn(_ sender : UIButton) {
        self.endEditing(true)
        let dic = messageViewModel.messageArray[sender.tag] as NSDictionary
        let link = dic.value(forKey: "Message") as! String
        
        if (UIApplication.shared.canOpenURL(URL(string: link)!)) {
            UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
        }
        else {
            let vc = WebViewVC()
            vc.urlString = link
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func handleOpenVideoLinkBtn(_ sender : UIButton) {
        
        let dic = messageViewModel.messageArray[sender.tag] as NSDictionary
        let link = dic.value(forKey: "Message") as? String ?? ""
        
        let linkArr = link.components(separatedBy: ">")
        
        if (linkArr.count >= 2) {
            let videoLink = linkArr[1].components(separatedBy: "<")
            if (videoLink.count >= 1) {
                if (UIApplication.shared.canOpenURL(URL(string: videoLink[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!)) {
                    UIApplication.shared.open(URL(string: videoLink[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!, options: [:], completionHandler: nil)
                }
                else {
                    let vc = WebViewVC()
                    vc.urlString = videoLink[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }

    
    @objc func handleOpenPDF(_ sender : UIButton) {
        let dic = messageViewModel.messageArray[sender.tag] as NSDictionary
        let link = dic.value(forKey: "FilePath") as! String
        
        let url = URL(string: link)
        FileDownloader.loadFileAsync(url: url!) { (path, error, url)  in
            guard let _ = path else {
                return }
            
            DispatchQueue.main.async {
                self.tblView.reloadData()
                if (sender.titleLabel?.text ?? "") == "Open" {
                    let vc = WebViewVC()
                    vc.urlString = link
                    UIApplication.shared.keyWindow!.rootViewController?.present(vc, animated: true)
                }
            }
        }
    }
    
    @objc func removeSelf() {
        removeFromSuperview()
    }
    
    func setupTableview() {
        tblView.separatorStyle = .none
        tblView.register(UINib(nibName: "SystemMessageCell", bundle: Bundle(for: SystemMessageCell.self)), forCellReuseIdentifier: "SystemMessageCell")
        
        tblView.register(UINib(nibName: "MessageAttachementSendTVC", bundle: Bundle(for: MessageAttachementSendTVC.self)), forCellReuseIdentifier: "MessageAttachementSendTVC")
        tblView.register(UINib(nibName: "MessageAttachementReceiveTVC", bundle: Bundle(for: MessageAttachementReceiveTVC.self)), forCellReuseIdentifier: "MessageAttachementReceiveTVC")
        tblView.register(UINib(nibName: "MessageSend", bundle: Bundle(for: MessageSend.self)), forCellReuseIdentifier: "MessageSend")
        tblView.register(UINib(nibName: "MessageReceive", bundle: Bundle(for: MessageReceive.self)), forCellReuseIdentifier: "MessageReceive")
        tblView.register(LinkCell.self, forCellReuseIdentifier: "LinkCell")
    }
    
    //MARK:- Save Image
    @objc func imageSavingFunction(gesture: UITapGestureRecognizer) {
        let imageDic = messageViewModel.messageArray[gesture.view!.tag] as NSDictionary
        let _ = URL(string: (imageDic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        // DataFile.savefile(imageURL: url!){(result) in
        DispatchQueue.main.async  {
            self.tappedImageView.delegate = self
            let screenSize = UIScreen.main.bounds.size
            self.tappedImageView.frame = CGRect(x: 0, y:BaseController.getStatusBarHeight , width: screenSize.width, height: screenSize.height)
            self.addSubview(self.tappedImageView)
            
            /* if let data = try? Data(contentsOf: url!) {
             DispatchQueue.main.async {
             self.tappedImageView.fullscreenImage.image = UIImage(data: data)
             }
             }*/
            
            self.tappedImageView.fullscreenImage.loadThumbnail(urlSting: (imageDic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (image) in
                
                DispatchQueue.main.async {
                    self.tappedImageView.fullscreenImage.image = image
                }
            }
        }
    }
}

extension ChatHistoryDetailsView : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let newArra : [[String: Any]] = messageViewModel.messageArray
        return newArra.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = (messageViewModel.messageArray[indexPath.row] as NSDictionary)
        let userType = dic.value(forKey: "Type") as! String
        
        if userType == "SYSTEM" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SystemMessageCell", for: indexPath) as! SystemMessageCell
            cell.systemMinHeight = 55
            cell.configureCell(message: (dic.value(forKey: "Message") as! String), Font: lableHeight)
            return cell
        }
        else if userType == "User" {
            //USER TEXT
            if dic.value(forKey: "MessageType") as! String == "TEXT" || dic.value(forKey: "MessageType") as! String == "EventStartCobrowsing" || dic.value(forKey: "MessageType") as! String == "EventEndCobrowsing" {
                
                let cell = MessageSendCell()
                let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                cell.configureCell(message: (dic.value(forKey: "Message") as! String), font: lableHeight, dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, isSent: true)
                cell.lblMessage.numberOfLines = 0
                
                if (arrIndex[indexPath.row] == 0) {
                    cell.lblMessage.numberOfLines = 0
                    cell.btnSeeMore.setTitle("See Less", for: .normal)
                }
                else {
                    cell.lblMessage.numberOfLines = 4
                    cell.btnSeeMore.setTitle("See More", for: .normal)
                }
                
                let numOfLines = cell.lblMessage.calculateMaxLines()
                if (numOfLines >= 4) {
                    cell.btnSeeMore.isHidden = false
                }
                else {
                    cell.btnSeeMore.isHidden = true
                }
                cell.delegate = self
                cell.btnSeeMore.tag = indexPath.row
                
                return cell
            }
            
            else if dic.value(forKey: "MessageType") as! String == "quicklink" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
                cell.size = Double(lableHeight)
                cell.setupUI()
                let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                cell.lblTime.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                cell.btnOpenLink.tag = indexPath.row
                cell.btnOpenLink.addTarget(self, action: #selector(handleOpenLinkBtn(_:)), for: .touchUpInside)
                return cell
            }
            
            else if dic.value(forKey: "MessageType") as! String == "videolink" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
                cell.size = Double(lableHeight)
                cell.setupUI()
                cell.lblAgent.text = "Agent has shared a video link"
                cell.btnOpenLink.setTitle("Open Video Link", for: .normal)
                
                let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                cell.lblTime.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                cell.btnOpenLink.tag = indexPath.row
                cell.btnOpenLink.addTarget(self, action: #selector(handleOpenVideoLinkBtn(_:)), for: .touchUpInside)
                return cell
            }
            
            else{
                //USER Image
                if  dic.value(forKey: "FileType") as! String == "jpg" ||  dic.value(forKey: "FileType") as! String == "png"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageAttachementReceiveTVC", for: indexPath) as! MessageAttachementReceiveTVC
                    cell.minHeightReceiverImage = 200
                    cell.messageReceiveImageView.isUserInteractionEnabled = true
                    let sentImageTapped = UITapGestureRecognizer(target: self, action: #selector(openSentImageFunc))
                    sentImageTapped.numberOfTapsRequired = 1
                    cell.messageReceiveImageView.tag =  indexPath.row
                    cell.messageReceiveImageView.addGestureRecognizer(sentImageTapped)
                    let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                    let keyExists = dic.value(forKey: "FilePath") != nil
                    
                    cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: nil, isSent: true)
                    
                    if keyExists {
                        if (cell.messageReceiveImageView.image == nil) {
                            spinner.center = cell.messageReceiveImageView.center
                            cell.messageReceiveImageView.addSubview(spinner)
                            spinner.isHidden = false
                            spinner.startAnimating()
                        }else{
                            //do nothing
                        }
                        let _ = URL(string: (dic.value(forKey: "FilePath") as! String))
                        cell.messageReceiveImageView.loadThumbnail(urlSting: (dic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") { (image) in
                            self.spinner.isHidden = true
                            self.spinner.stopAnimating()
                            cell.messageReceiveImageView.image = image
                        }
                    }
                    else{
                        //User Attachment
                        let newImageData = Data(base64Encoded: (dic.value(forKey: "Message") as! String))
                        if let newImageData = newImageData {
                            cell.messageReceiveImageView.image = UIImage(data: newImageData)
                            cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: newImageData, isSent: true)
                        }
                    }
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSend", for: indexPath) as! MessageSend
                    cell.selectionStyle = .none
                    cell.minHeightSenderTwo = 140
                    let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                    cell.timeAgoLbl.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                    cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, imageType: (dic.value(forKey: "FileType") as? String)!, isSent: true)
                    
                    let link = dic.value(forKey: "FilePath") as? String ?? ""
                    FileDownloader.checkPathIsAvailable(url: URL(string: link)!) { (path) in
                        if (path) {
                            cell.btnOpen.setTitle("Open", for: .normal)
                        }
                        else {
                            cell.btnOpen.setTitle("Download", for: .normal)
                        }
                    }
                    cell.btnOpen.tag = indexPath.row
                    cell.openButtonPressed = {
                        if (cell.btnOpen?.titleLabel?.text ?? "") == "Download" {
                            cell.spinner.isHidden = false
                            cell.spinner.startAnimating()
                        }
                        
                        let link = dic.value(forKey: "FilePath") as! String
                        let url = URL(string: link)
                        FileDownloader.loadFileAsync(url: url!) { (path, error, url)  in
                            guard let _ = path else {
                                return }
                            
                            DispatchQueue.main.async {
                                cell.spinner.isHidden = true
                                cell.spinner.stopAnimating()
                                
                                self.tblView.reloadData()
                                if (cell.btnOpen?.titleLabel?.text ?? "") == "Open" {
                                    let vc = WebViewVC()
                                    vc.urlString = link
                                    UIApplication.shared.keyWindow!.rootViewController?.present(vc, animated: true)
                                }
                            }
                        }
                    }
                    
                   // cell.btnOpen.addTarget(self, action: #selector(handleOpenPDF(_:)), for: .touchUpInside)
                    return cell
                }
            }
        }
        else{
            if dic.value(forKey: "MessageType") as! String == "TEXT" {
                let cell = MessageReceivedCell()
                cell.selectionStyle = .none
                let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                cell.configureCell(message: (dic.value(forKey: "Message") as! String), font: lableHeight, dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!)
                
                cell.lblMessage.numberOfLines = 0
                if (arrIndex[indexPath.row] == 0) {
                    cell.lblMessage.numberOfLines = 0
                    cell.btnSeeMore.setTitle("See Less", for: .normal)
                }
                else {
                    cell.lblMessage.numberOfLines = 4
                    cell.btnSeeMore.setTitle("See More", for: .normal)
                }
                
                let numOfLines = cell.lblMessage.calculateMaxLines()
                if (numOfLines >= 4) {
                    cell.btnSeeMore.isHidden = false
                }
                else {
                    cell.btnSeeMore.isHidden = true
                }
                cell.delegate = self
                cell.btnSeeMore.tag = indexPath.row
                return cell
            }
            
            else if dic.value(forKey: "MessageType") as! String == "quicklink" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
                cell.size = Double(lableHeight)
                cell.setupUI()
                let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                cell.lblTime.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                cell.btnOpenLink.tag = indexPath.row
                cell.btnOpenLink.addTarget(self, action: #selector(handleOpenLinkBtn(_:)), for: .touchUpInside)
                return cell
            }
            
            else if (dic.value(forKey: "FileType") as? String ?? "") == "jpg" ||  (dic.value(forKey: "FileType") as? String ?? "") == "png" ||  (dic.value(forKey: "FileType") as? String ?? "") == "jpeg"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageAttachementSendTVC", for: indexPath) as! MessageAttachementSendTVC
                cell.minHeightSenderImage = 200
                let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                
                _ = URL(string: (dic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                let tapped = UITapGestureRecognizer(target: self, action: #selector(imageSavingFunction))
                tapped.numberOfTapsRequired = 1
                cell.messageSendImageView.isUserInteractionEnabled = true
                cell.messageSendImageView.tag =  indexPath.row
                cell.messageSendImageView.addGestureRecognizer(tapped)
                
                cell.cellConfigure(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: nil)
                
                cell.activityView.isHidden = false
                cell.activityView.startAnimating()
                
                cell.messageSendImageView.loadThumbnail(urlSting: (dic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") { (image) in
                    cell.activityView.isHidden = true
                    cell.activityView.stopAnimating()
                    cell.messageSendImageView.image = image
                }
                
                
               /* DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            cell.cellConfigure(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: data)
                        }
                    }
                }*/
                return cell
            }
            
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageReceive", for: indexPath) as! MessageReceive
                cell.minHeightReceiver = 140
                let datePassed = DataFile.StringToDateAgo(Date: dic.value(forKey: "DateTime") as! String)
                cell.timeagoLbl.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, imageType: dic.value(forKey: "FileType") as! String)
                
                let link = (dic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlUserAllowed) ?? ""
                FileDownloader.checkPathIsAvailable(url: URL(string: link)!) { (path) in
                    if (path) {
                        cell.downloadBtnAction.setTitle("Open", for: .normal)
                    }
                    else {
                        cell.downloadBtnAction.setTitle("Download", for: .normal)
                    }
                }
                cell.downloadBtnAction.tag = indexPath.row
                cell.openButtonPressed = {
                    if (cell.downloadBtnAction?.titleLabel?.text ?? "") == "Download" {
                        cell.spinner.isHidden = false
                        cell.spinner.startAnimating()
                    }
                    
                    let link = (dic.value(forKey: "FilePath") as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    
                    let url = URL(string: link)
                    FileDownloader.loadFileAsync(url: url!) { (path, error, url)  in
                        guard let _ = path else {
                            return }
                        
                        DispatchQueue.main.async {
                            cell.spinner.isHidden = true
                            cell.spinner.stopAnimating()
                            
                            self.tblView.reloadData()
                            if (cell.downloadBtnAction?.titleLabel?.text ?? "") == "Open" {
                                let vc = WebViewVC()
                                vc.urlString = link
                                UIApplication.shared.keyWindow!.rootViewController?.present(vc, animated: true)
                            }
                        }
                    }
                }
                return cell
            }
        }
    }
    
    public  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dic = messageViewModel.messageArray[indexPath.row] as NSDictionary
        if dic.value(forKey: "MessageType") as! String == "FILE" {
            return 200.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 250
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = messageViewModel.messageArray[indexPath.row] as NSDictionary
        let userType = dic.value(forKey: "Type") as! String
        
        if userType != "SYSTEM"  && userType != "USER" {
            if dic.value(forKey: "MessageType") as! String == "quicklink" || dic.value(forKey: "MessageType") as! String == "TEXT" {
                let temp = LinkDetecter.getLinks(in: dic.value(forKey: "Message") as? String ?? "")
                
                if temp.count > 0 {
                    let strUrl = temp[0].link.absoluteString
                    
                    var url: String = ""
                    
        
                    if (strUrl.hasPrefix("http://")) || (strUrl.hasPrefix("https://")) {
                        url =  strUrl
                    } else {
                        url = "http://" + strUrl
                    }
                    
                    if (UIApplication.shared.canOpenURL(URL(string: url)!)) {
                        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                    }
                    else {
                        let vc = WebViewVC()
                        vc.urlString = url
                        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension ChatHistoryDetailsView : ImageViewDelegate, UITextViewDelegate {
    func didCancelImageViewButtonTapped() {
        self.tappedImageView.removeFromSuperview()
    }
}

extension ChatHistoryDetailsView : ReloadTableHeightPr {
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
