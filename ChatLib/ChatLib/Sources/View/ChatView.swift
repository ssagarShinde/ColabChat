//
//  ChatView.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import UIKit
//import JioMeetSDK



public class ChatView: UIView,UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, BottomSheetDelegate, EndChatDelegate, ZoomInOutDelegate, ImageViewDelegate, chatHistoryDelegate {
    
    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.backgroundColor = Colors.theme
        }
    }
    
    @IBOutlet weak var txtMsg: UITextView!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var OPenCloseBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tblViewCurve: UIView!
    @IBOutlet weak var textLayerView: UIView!
    @IBOutlet weak var noMessageView: UIView!
    @IBOutlet weak var chatStatus: UILabel!
    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var agentImage: UIImageView!
    @IBOutlet weak var backBtnView: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    
    
    @IBOutlet weak var senBtn: UIButton! {
        didSet {
            senBtn.tintColor = .gray
        }
    }
    
    @IBOutlet weak public var btnVideo: UIButton! {
        didSet {
            btnVideo.isHidden = true
        }
    }
    @IBOutlet weak var btnCobrowse: NSLayoutConstraint!
    @IBOutlet weak var btnScreenShares: UIButton!{
        didSet {
            btnScreenShares.isHidden = true
        }
    }
    
    var viewController : UIViewController?
    let statusBar =  UIView()
    var transparentView = UIView()
    var newView = UIView()
    
    var isOpen = "F"
    var isZoomViewOpen = "T"
    var isSent : Bool = false
    
    var lableHeight : Float = 16.0
    let height: CGFloat = 250
    
    var bottomSheetView : BottomSheet = .fromNib()
    var endChatView : EndChatView = .fromNib()
    var zoomInOutView : ZoomInOut = .fromNib()
    var tappedImageView : ImageView = .fromNib()
    var chatHistoryView : chatHistoryView = .fromNib()
    
    var docController:UIDocumentInteractionController!
    let spinner = UIActivityIndicatorView(style: .gray)
    
    weak var imageTimer: Timer?
    var oldImgData = ""
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableview()
        zoomInOutView.backgroundColor = Colors.theme
        print("New Commit Test")
        statusBar.frame = UIApplication.shared.statusBarFrame
        statusBar.backgroundColor = Colors.theme
        UIApplication.shared.windows.first?.addSubview(statusBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTableView(_:)), name: NSNotification.Name(rawValue: "updateMessage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAttachement(_:)), name: NSNotification.Name(rawValue: "updateAttachmentString"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.messageSuccess(_:)), name: NSNotification.Name(rawValue: "messageSuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateChatHistory(_:)), name: NSNotification.Name(rawValue: "chatHistory"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPreviousHistory(_:)), name: NSNotification.Name(rawValue: "PreviousChatList"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.endChatSuccess(_:)), name: NSNotification.Name(rawValue: "EndChatSuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.agentTyping(_:)), name: NSNotification.Name(rawValue: "AgentTyping"), object: nil)
        
        
        //COBROWSE Notification Handle New
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.configCobrowse(_:)), name: NSNotification.Name(rawValue: "Configcobrowse"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.agentJoined(_:)), name: NSNotification.Name(rawValue: "AgentJoined"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showPermission(_:)), name: NSNotification.Name(rawValue: "ShowPermission"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.cobrowseEndSuccess(_:)), name: NSNotification.Name(rawValue: "CobrowseEndSuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        HoverBtn.shared.delegate = self
        switch (ChatSocketHelper.shared.chatSocket?.status) {
        case .notConnected, .disconnected :
            
            if (ChatSocketHelper.shared.chatSocket!.status != .connected || ChatSocketHelper.shared.chatSocket!.status != .connecting) {
                ChatSocketHelper.shared.socketChatCloseConnection()
                ChatSocketHelper.shared.chatSocketEstablishConnection(type: "Chat")
            }
            
            Messaging.shared.obj.removeAll()
            SeenModel.shared.arrSeen.removeAll()
            
            chatStatus.isHidden = false
            self.txtMsg.delegate = self
            self.txtMsg.text = "Send a message"
            self.txtMsg.textColor = UIColor.lightGray
            setupTableview()
            break
            
        default :
            
            HoverBtn.shared.hoverView = MessageVM.shared.hover
            HoverBtn.shared.hoverView.isHidden = MessageVM.shared.isHoverShowing
            agentName.text = UserDetails.agentName
            
            self.btnVideo.isHidden = MessageVM.shared.btnVideo
            self.btnScreenShares.isHidden = MessageVM.shared.btnScreenshare
            
            chatStatus.isHidden = true
            self.txtMsg.delegate = self
            self.txtMsg.text = "Send a message"
            self.txtMsg.textColor = UIColor.lightGray
            
            if (Messaging.shared.obj.count > 0) {
                
            }
            else {
                noMessageView.isHidden = false
            }
            
            break
        }
        
        setupTableview()
        tblChat.dataSource = self
        tblChat.delegate = self
        tblChat.reloadData()
    }
    
    func endCobrowseSession() {
        
        let messageDictionary : [String:Any] = ["Message": "Cobrowsing ended... Session ID: ", "MessageType" : "TEXT", "Type": "User", "FileType":"text", "DateTime":UserDetails.getCurrentFormattedDate(), "MessageId":UserDetails.messageID]
        
        let dataDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "message": messageDictionary]
        let eventDictionary : [String:Any] = ["eventName":"cobrowseEnded", "data": dataDictionary]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    
    //MARK:- On disconnect Timer
    public func disconnectTimer() {
        if self.imageTimer != nil {
            self.imageTimer?.invalidate()
            self.imageTimer = nil
        }
    }
    
    //MARK:- Notification Functions
    @objc func keyboardWasShown(notification: NSNotification)
    {
        if let newFrame = (notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            if Messaging.shared.obj.count != 0 {
                self.tblChat.scrollToBottom(animated: false)
            }
            
            else{
                
            }
            bottomViewConstraint.constant = newFrame.height
        }
    }
    
    @objc func appMovedToBackground() {
        let eventDictionary : [String:Any] = ["eventName":"offline", "data": DataFile.getConstantDictionary()]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    @objc func appCameToForeground() {
        let eventDictionary : [String:Any] = ["eventName":"online", "data": DataFile.getConstantDictionary()]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    @objc func messageSuccess(_ notification: NSNotification) {
        let dict = notification.userInfo!
        
        if let msgId = dict["messageId"] as? String {
            let param = Seen(msgIDs: msgId, values: true)
            SeenModel.shared.arrSeen.append(param)
            self.tblChat.reloadData()
        }
    }
    
    @IBAction func HandleMenuBtn(_ sender: Any) {
        let popup = Menu()
        popup.frame = self.bounds
        popup.delegates = self
        guard let frame = tblViewCurve.viewFrame else {
            return
        }
        popup.createUI(y: frame.origin.y)
        self.window?.addSubview(popup)
    }
    
    //MARK:- Send Btn Action
    @IBAction func sendBtnAction(_ sender: Any) {
        if ((txtMsg.text ?? "") == "") {
            return
        }
        if ((txtMsg.text ?? "") == "Send a message"){
            return
        }
        else {
            dataAppendInBaseArray(messageString: txtMsg.text!, msgType: "TEXT", filetype: "Text", fileName: "",fileSize: "", filePath: "")
            txtMsg.text = ""
            senBtn.tintColor = .gray
        }
    }
    
    //MARK:- Bottom Sheet Action
    @IBAction func attachmentBtnAction(_ sender: Any) {
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        self.layoutIfNeeded()
        
        if isOpen == "F" {
            OPenCloseBtn.setImage(UIImage(named: "close", in: Bundle(for: type(of:self)), compatibleWith: nil), for: .normal)
            bottomSheetView.delegate = self
            bottomSheetView.frame = CGRect(x: 0, y: bottomView.frame.origin.y - 55, width: (UIScreen.main.bounds.width), height: 100)
            self.addSubview(bottomSheetView)
            self.bottomViewHeightConstraint?.constant = 230
            self.bottomView.layoutIfNeeded()
            isOpen = "T"
        }
        else{
            OPenCloseBtn.setImage(UIImage(named: "colabAttachment", in: Bundle(for: type(of:self)), compatibleWith: nil), for: .normal)
            bottomSheetView.removeFromSuperview()
            self.bottomViewHeightConstraint?.constant = 120
            self.bottomView.layoutIfNeeded()
            isOpen = "F"
        }
    }
    
    fileprivate func closeAttachment() {
        OPenCloseBtn.setImage(UIImage(named: "colabAttachment", in: Bundle(for: type(of:self)), compatibleWith: nil), for: .normal)
        bottomSheetView.removeFromSuperview()
        self.bottomViewHeightConstraint?.constant = 120
        self.bottomView.layoutIfNeeded()
        isOpen = "F"
    }
    
    //MARK:- Bottom Sheet Delegates
    func didCameraButtonTapped() {
        AttachmentHandler.shared.authorisationStatus(attachmentTypeEnum: AttachmentHandler.AttachmentType.camera, vc: self)
    }
    
    func didGalleryButtonTapped() {
        AttachmentHandler.shared.authorisationStatus(attachmentTypeEnum: AttachmentHandler.AttachmentType.photoLibrary, vc: self)
    }
    
    
    func didDocumentBtnTapped() {
        AttachmentHandler.shared.documentPicker(view: self)
    }
    
    //MARK:- EndChat Delegates
    @IBAction func cancelBtn(_ sender: Any) {
        
        if ((ChatSocketHelper.shared.chatSocket?.status != .connected) || (ChatSocketHelper.shared.chatSocket?.status == .disconnected) ){
            self.removeSubviewOnendChat()
        }
        else {
            self.endEditing(true)
            bottomViewConstraint.constant = 0
            self.endChatEvent(AgentSideEndChat: "F")
        }
    }
    
    @IBAction func startVideoBtnTapped(_ sender: Any) {
        
        let chatInitialize : [String:Any] = ["token": UserDetails.token,
                                             "sessionId" : UserDetails.sessionID,
                                             "userId":SocketHelper.userID,
                                             "userName": SocketHelper.userName,
                                             "userNumber" : SocketHelper.mobileNumber,
                                             "chatInteractionId" : UserDetails.chatInteractionID,
                                             "channelSource": "VIDEO",
                                             "initialMsg" : "",
                                             "customParam1" : "",
                                             "customParam2" : ""
        ]
        let eventNameDict : [String:Any] = ["eventName":"initializeProcess","data":chatInitialize]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventNameDict)
    }
    
    
    //MARK:- Handle Screen Sharing Button
    
    @IBAction func screenShareBtn(_ sender: Any) {
        
        switch  CobrowseSocketHelper.shared.cobrowseSocket?.status {
        case .notConnected, .disconnected:
            let chatInitialize : [String:Any] = ["token": UserDetails.token, "sessionId" : UserDetails.sessionID, "channelSource": "COBROWSE","userName": SocketHelper.userName,"userId":SocketHelper.userID]
            let eventNameDict : [String:Any] = ["eventName":"initializeProcess","data":chatInitialize]
            ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventNameDict)
            
            self.endEditing(true)
            bottomViewConstraint.constant = 0
            let popup = ScreenSharePopup()
            popup.frame = self.bounds
            popup.createUI(btnTag: 0)
            popup.delegate = self
            self.window?.addSubview(popup)
            break
        
            
        case .connected :
            self.endEditing(true)
            bottomViewConstraint.constant = 0
            let popup = ScreenSharePopup()
            popup.frame = self.bounds
            popup.createUI(btnTag: 1)
            popup.delegate = self
            self.window?.addSubview(popup)
            break
            
            
        case .connecting :
            self.toastView(msg: "initialising...")
            break
            
        default:
            break
        }
    }
    
    
    
    //MARK:- Previous Chat History Delegate
    @IBAction func previousChatHAction(_ sender: Any) {
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        getPreviousChatHistory()
    }
    
    
    func getPreviousChatHistory() {
        let dict : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "sessionId": UserDetails.sessionID, "userName": SocketHelper.userName,"userId":SocketHelper.userID, "dateTime":UserDetails.getCurrentFormattedDate()]
        
        let eventDictionary : [String:Any] = ["eventName":"previousChatList", "data": dict]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    @objc func getPreviousHistory(_ notification: NSNotification) {
        let dict = notification.userInfo! as NSDictionary
        let data = dict.value(forKey: "data") as! [[String:Any]]
        
        for v in (self.window!.subviews) {
            if v.isKind(of: PreviousChatHistory.self) {
                return 
            }
        }
        
        DispatchQueue.main.async {
            let popup = PreviousChatHistory()
            popup.frame =  UIScreen.main.bounds
            popup.data = data
            popup.createUI()
            popup.delegate = self
            self.window?.addSubview(popup)
        }
    }
    
    @objc func endChatSuccess(_ notification: NSNotification) {
        
        endChatView.btnCancel.isHidden = false
        endChatView.btnEndChat.isHidden = false
        endChatView.loader.isHidden = true
        endChatView.loader.stopAnimating()
        ChatSocketHelper.shared.chatSocket!.disconnect()
        CobrowseSocketHelper.shared.disconnect()
        ChatSocketHelper.shared.chatSocket?.didDisconnect(reason: "Disconnect")
        CobrowseSocketHelper.shared.cobrowseSocket?.didDisconnect(reason: "Disconnect")
        
        Feedback.openFeedback()
        self.removeSubviewOnendChat()
    }
    
    
    @objc func agentTyping(_ notification: NSNotification) {
        chatStatus.text  = UserDetails.agentName + " \("is typing...")"
        chatStatus.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.chatStatus.isHidden = true
            self.chatStatus.text = "Connecting"
        }
    }
    
    @objc func onChatHistoryTransparentView() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.chatHistoryView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion:  { (finished: Bool) in
            self.transparentView.removeFromSuperview()
            self.chatHistoryView.removeFromSuperview()
        })
    }
    
    //MARK:- Previous End Chat Delegate
    @IBAction func backBtn(_ sender: Any) {
        
        if let hView = HoverBtn.shared.hoverView {
            MessageVM.shared.hover = hView
            MessageVM.shared.isHoverShowing = hView.isHidden
        }
        
        MessageVM.shared.btnVideo = self.btnVideo.isHidden
        MessageVM.shared.btnScreenshare = self.btnScreenShares.isHidden
        
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        self.statusBar.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
    
    func endChatEvent(AgentSideEndChat : String) {
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        
        endChatView.delegate = self
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = UIApplication.shared.keyWindow!.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window?.addSubview(endChatView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.alpha = 0
        
        if AgentSideEndChat == "F" {
            transparentView.addGestureRecognizer(tapGesture)
            endChatView.agentEndChatView.isHidden = true
        }else{
            transparentView.removeGestureRecognizer(tapGesture)
            endChatView.agentEndChatView.isHidden = false
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.endChatView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    func endChatEvent2(AgentSideEndChat : String) {
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        
        endChatView.delegate2 = self
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = UIApplication.shared.keyWindow!.frame
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window?.addSubview(endChatView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.alpha = 0
        
        if AgentSideEndChat == "F" {
            transparentView.addGestureRecognizer(tapGesture)
            endChatView.agentEndChatView.isHidden = true
        }else{
            transparentView.removeGestureRecognizer(tapGesture)
            endChatView.agentEndChatView.isHidden = false
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.endChatView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func onClickTransparentView() {
        endChatCalled()
    }
    
    func didCancelButtonTapped() {
        AgentJoined.disconnectTimer()
        CobrowseSocketHelper.shared.disconnect()
        endChatCalled()
    }
    
    func endChatCalled() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion:  { (finished: Bool) in
            self.transparentView.removeFromSuperview()
            self.endChatView.removeFromSuperview()
        })
    }
    
    func didEndChatButtonTapped() {
        
        endChatView.btnCancel.isHidden = true
        endChatView.btnEndChat.isHidden = true
        endChatView.loader.isHidden = false
        endChatView.loader.startAnimating()
        transparentView.isUserInteractionEnabled = false
        
        switch CobrowseSocketHelper.shared.cobrowseSocket?.status {
        case .connected, .connecting:
            endCobrowseSession()
        default:
            break
        }
        let eventDictionary : [String:Any] = ["eventName":"endChat", "data": DataFile.getConstantDictionary()]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    func closeAgentView() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion:  { (finished: Bool) in
            self.transparentView.removeFromSuperview()
        })
        AgentJoined.disconnectTimer()
        endCobrowseSession()
    }
    
    func didAgentEndChatButtonTapped() {
        Feedback.openFeedback()
        DispatchQueue.main.async {
            self.removeSubviewOnendChat()
        }
    }
    
    func removeSubviewOnendChat() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion:  { (finished: Bool) in
            self.transparentView.removeFromSuperview()
            self.endChatView.removeFromSuperview()
            self.statusBar.removeFromSuperview()
            NotificationCenter.default.removeObserver(self)
            self.removeFromSuperview()
            UserDetails.agentName = ""
        })
        ChatSocketHelper.shared.socketChatCloseConnection()
    }
    
    //MARK:- TEXTView Methods
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (isOpen == "T") {
            closeAttachment()
        }
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        senBtn.setImage(UIImage(named: "colabSend", in: Bundle(for: type(of:self)), compatibleWith: nil), for: .normal)
        let eventDictionary : [String:Any] = ["eventName":"typingStart", "data": DataFile.getConstantDictionary()]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Send a message"
            textView.textColor = UIColor.lightGray
            senBtn.setImage(UIImage(named: "colabLike", in: Bundle(for: type(of:self)), compatibleWith: nil), for: .normal)
        }
        
        let eventDictionary : [String:Any] = ["eventName":"typingStop", "data": DataFile.getConstantDictionary()]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return textViewShouldInteractWithURL(URL: URL)
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return textViewShouldInteractWithURL(URL: URL)
    }
    
    func textViewShouldInteractWithURL(URL: URL) -> Bool {
        UIApplication.shared.canOpenURL(URL)
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if ((textView.text?.count ?? 0) == 0) {
            senBtn.tintColor = .gray
            senBtn.isEnabled = false
        }
        else {
            senBtn.tintColor = Colors.theme
            senBtn.isEnabled = true
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            bottomViewConstraint.constant = 0
            return false
        }
        return true
    }
    
    //MARK: Update Table Array
    @objc func updateAttachement(_ notification: NSNotification) {
        let dic = notification.userInfo as NSDictionary?
        dataAppendInBaseArray(messageString: dic?.value(forKey: "messageString") as! String, msgType: dic?.value(forKey: "messageType") as! String, filetype: dic?.value(forKey: "FileType") as! String, fileName: dic?.value(forKey: "fileName") as! String,fileSize: dic?.value(forKey: "fileSize") as! String,filePath : (dic?.value(forKey: "FilePath") as? String ?? ""))
    }
    
    func dataAppendInBaseArray(messageString: String, msgType : String, filetype : String, fileName : String, fileSize: String, filePath : String) {
        let msgID = UserDetails.messageID
        
        let messageDictionary : [String:Any] = ["Message": messageString, "MessageType" : msgType, "Type": "User", "FileType":filetype, "DateTime":UserDetails.getCurrentFormattedDate(), "MessageId": msgID, "fileName": fileName, "fileSize": fileSize, "FilePath" : filePath]
        
        let dataDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "message": messageDictionary]
        let eventDictionary : [String:Any] = ["eventName":"newMessage", "data": dataDictionary]
        
        
        let message = Messages(dateTime: UserDetails.getCurrentFormattedDate(), filePath: filePath, fileType: filetype, message: messageString, messageID: msgID, messageType: msgType, type: "User", agentData: AgentData(agentLoginID: "", agentProfilePic: "", agentRole: "", name: ""), event: "")
        Messaging.shared.obj.append(message)
        
        if Messaging.shared.obj.count == 0 {
            noMessageView.isHidden = false
        }
        else{
            noMessageView.isHidden = true
        }
        self.tblChat.reloadData()
        self.tblChat.scrollToBottom(animated: false)
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    @objc func updateChatHistory(_ notification: NSNotification){
        chatStatus.isHidden = true
        
        let dicts = notification.userInfo as NSDictionary?
        print(dicts as Any)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dicts!, options: [])
        do {
            let data = try JSONDecoder().decode(MessagingModel.self, from: jsonData!)
            if (data.data?.chatHistory ?? []).count == 0 {
                noMessageView.isHidden = false
            }
            else {
                
                print("Data From", data.from ?? "")
                
                if (data.from ?? "") != "chatHistorySuccess" {
                    Messaging.shared.obj.removeAll()
                    SeenModel.shared.arrSeen.removeAll()
                }
                
                for i in 0..<(data.data?.chatHistory?.count ?? 0) { //
                    if (data.data?.chatHistory?[i].message ?? "") == "" {
                        
                    }
                    else {
                        if (data.from ?? "") == "chatHistorySuccess" {
                            
                            let msgId = data.data?.chatHistory?[i].messageID ?? ""
                            if  (data.data?.chatHistory?.count ?? 0) > 0 {
                                data.data?.chatHistory?.remove(at: 0)
                                SeenModel.shared.arrSeen.remove(at: 0)
                            }
                            
                            let param = Seen(msgIDs: msgId, values: true)
                            SeenModel.shared.arrSeen.insert(param, at: 0)
                            Messaging.shared.obj.insert((data.data?.chatHistory?[i])!, at: 0)
                            self.tblChat.reloadData()
                            
                        }else {
                            
                            let msgId = data.data?.chatHistory?[i].messageID ?? ""
                            let param = Seen(msgIDs: msgId, values: true)
                            SeenModel.shared.arrSeen.append(param)
                            Messaging.shared.obj.append((data.data?.chatHistory?[i])!)
                            self.tblChat.reloadData()
                            self.tblChat.scrollToBottom(animated: false)
                        }
                    }
                }
                noMessageView.isHidden = true
            }
        }
        
        catch let error {
            print("Error updateChatHistory", error)
        }
    }
    
    
    @objc func updateTableView(_ notification: NSNotification) {
        let dict = notification.userInfo as NSDictionary?
        print(dict as Any)
        let jsonData = try? JSONSerialization.data(withJSONObject: dict!, options: [])
        do {
            let data = try JSONDecoder().decode(Messages.self, from: jsonData!)
            if (data.message) == "" {
                if (data.event ?? "") == "typing" {
                     chatStatus.isHidden = false
                     chatStatus.text = "\(UserDetails.agentName) is typing..."
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                         chatStatus.isHidden = true
                         chatStatus.text = "Connecting"
                     }
                 }
                
                 else if (data.event ?? "") == "endchat" {
                     self.endChatEvent(AgentSideEndChat: "T")
                 }
                 
                 else if (data.event ?? "") == "agentJoined" {
                     agentName.text = UserDetails.agentName
                     agentImage.image = UIImage(named: "colabSender", in: Bundle(for: type(of:self)), compatibleWith: nil)
                     btnVideo.isHidden = false
                     btnScreenShares.isHidden = false
                 }
             }
             else {
                 Messaging.shared.obj.append(data)
                 self.tblChat.reloadData()
                 self.tblChat.scrollToBottom(animated: false)
             }
        }
        
        catch let error {
            print("Error updateTableView", error)
        }
    }
    
    //MARK : ZoomInOut Button Action
    @IBAction func zoomInBtnAction(_ sender: Any) {
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        zoomInOutView.delegate = self
        
        if isZoomViewOpen == "T" {
            self.addSubview(zoomInOutView)
            tableTopConstraint.constant = 80
            self.zoomInOutView.frame = CGRect(x: 0, y: self.backBtnView.frame.origin.y + self.backBtnView.frame.size.height + 10, width: self.frame.width, height: 30)
            isZoomViewOpen = "F"
        }
        else{
            zoomInOutView.removeFromSuperview()
            tableTopConstraint.constant = 50
            isZoomViewOpen = "T"
        }
    }
    
    //MARK : Zoom Out
    func didIncreaseButtonTapped() {
        let text = (zoomInOutView.ZoomPer.text ?? "").replacingOccurrences(of: "%", with: "")
        let count = Int(text) ?? 0
        if (count < 180) {
            let newSize = (lableHeight + 10)/100
            lableHeight = lableHeight + newSize
            zoomInOutView.ZoomPer.text = "\(count + 10)%"
            tblChat.reloadData()
        }
    }
    
    
    //MARK : Zoom In
    func didDecreaseButtonTapped() {
        let text = (zoomInOutView.ZoomPer.text ?? "").replacingOccurrences(of: "%", with: "")
        let count = Int(text) ?? 0
        if (count > 70) {
            let newSize = (lableHeight - 10)/100
            lableHeight = lableHeight - newSize
            zoomInOutView.ZoomPer.text = "\(count - 10)%"
            tblChat.reloadData()
        }
    }
    
    @objc func handleOpenLinkBtn(_ sender : UIButton) {
        
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        
        let dic = Messaging.shared.obj[sender.tag]
        let link = dic.message ?? ""
        
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
        
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        
        let dic = Messaging.shared.obj[sender.tag]
        let link = dic.message ?? ""
        
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
    
    
    @objc func handleOpenDoccuments(_ sender : UIButton) {
        
        self.endEditing(true)
        bottomViewConstraint.constant = 0
        
        let dic = Messaging.shared.obj[sender.tag]
        let link = dic.filePath ?? ""
        let _ = dic.fileType ?? ""
        let vc = WebViewVC()
        vc.urlString = link
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK: Setup TableView
    func setupTableview() {
        tblChat.separatorStyle = .none
        tblChat.register(UINib(nibName: "SystemMessageCell", bundle: Bundle(for: SystemMessageCell.self)), forCellReuseIdentifier: "SystemMessageCell")
        
        tblChat.register(UINib(nibName: "MessageAttachementSendTVC", bundle: Bundle(for: MessageAttachementSendTVC.self)), forCellReuseIdentifier: "MessageAttachementSendTVC")
        tblChat.register(UINib(nibName: "MessageAttachementReceiveTVC", bundle: Bundle(for: MessageAttachementReceiveTVC.self)), forCellReuseIdentifier: "MessageAttachementReceiveTVC")
        tblChat.register(UINib(nibName: "MessageSend", bundle: Bundle(for: MessageSend.self)), forCellReuseIdentifier: "MessageSend")
        tblChat.register(UINib(nibName: "MessageReceive", bundle: Bundle(for: MessageReceive.self)), forCellReuseIdentifier: "MessageReceive")
        tblChat.register(UINib(nibName: "LinksCell", bundle: Bundle(for: MessageReceive.self)), forCellReuseIdentifier: "LinksCell")
        
        tblChat.register(LinkCell.self, forCellReuseIdentifier: "LinkCell")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messaging.shared.obj.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = Messaging.shared.obj[indexPath.row]
        let userType = dic.type ?? ""
        
        if userType == "SYSTEM" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SystemMessageCell", for: indexPath) as! SystemMessageCell
            cell.systemMinHeight = 55
            cell.configureCell(message: (dic.message ?? ""), Font: lableHeight)
            return cell
        }
        
        else if userType == "User" {
            //USER TEXT
            
            if (dic.messageType ?? "") == "TEXT" || (dic.messageType ?? "") == "EventStartCobrowsing" || (dic.messageType ?? "") == "EventEndCobrowsing" {
                let cell = MessageSendCell()
                let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                
                let msgId = dic.messageID ?? ""
                var isSend = false
                
                if SeenModel.shared.arrSeen.contains(where: {$0.msgID == msgId}) {
                    isSend = true
                } else {
                    isSend = false
                }
                
                cell.configureCell(message: (dic.message ?? ""), font: lableHeight, dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, isSent: isSend)
                
                cell.lblMessage.numberOfLines = 0
                cell.btnSeeMore.isHidden = true
                
                if (dic.showMore == 0) {
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
            
            else if (dic.messageType ?? "") == "quicklink" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
                cell.size = Double(lableHeight)
                cell.setupUI()
                let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                cell.lblTime.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                cell.btnOpenLink.tag = indexPath.row
                cell.btnOpenLink.addTarget(self, action: #selector(handleOpenLinkBtn(_:)), for: .touchUpInside)
                return cell
            }
            
            else {
                //USER Image
                if  (dic.fileType ?? "") == "jpg" ||  (dic.fileType ?? "") == "png" || (dic.fileType ?? "") == "jpge" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageAttachementReceiveTVC", for: indexPath) as! MessageAttachementReceiveTVC
                    cell.minHeightReceiverImage = 230
                    cell.messageReceiveImageView.isUserInteractionEnabled = true
                    
                    let sentImageTapped = UITapGestureRecognizer(target: self, action: #selector(openSentImageFunc))
                    sentImageTapped.numberOfTapsRequired = 1
                    cell.messageReceiveImageView.tag =  indexPath.row
                    cell.messageReceiveImageView.addGestureRecognizer(sentImageTapped)
                    
                    let msgId = dic.messageID ?? ""
                    var isSend = false
                    
                    if SeenModel.shared.arrSeen.contains(where: {$0.msgID == msgId}) {
                        isSend = true
                    } else {
                        isSend = false
                    }
                    
                    let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                    let keyExists = dic.fileType != nil
                    if keyExists {
                        if (cell.messageReceiveImageView.image == nil) {
                            spinner.center = cell.messageReceiveImageView.center
                            cell.messageReceiveImageView.addSubview(spinner)
                            spinner.startAnimating()
                        }else{
                            //do nothing
                        }
                        let url = URL(string: (dic.filePath ?? ""))
                        if (url == nil) {
                            if let msgStr = dic.message {
                                if let data = Data(base64Encoded: msgStr, options: .ignoreUnknownCharacters) {
                                    DispatchQueue.main.async {
                                        self.spinner.stopAnimating()
                                        self.spinner.isHidden = true
                                        cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: data, isSent: isSend)
                                        self.spinner.removeFromSuperview()
                                    }
                                }
                            }
                        }
                        else {
                            DispatchQueue.global().async {
                                if let data = try? Data(contentsOf: url!) {
                                    DispatchQueue.main.async {
                                        self.spinner.stopAnimating()
                                        self.spinner.isHidden = true
                                        cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: data, isSent: isSend)
                                        self.spinner.removeFromSuperview()
                                    }
                                }
                            }
                        }
                    } else {
                        //User Attachment
                        let newImageData = Data(base64Encoded: (dic.message ?? ""))
                        if let newImageData = newImageData {
                            cell.messageReceiveImageView.image = UIImage(data: newImageData)
                            cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: newImageData, isSent: isSend)
                        }
                    }
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSend", for: indexPath) as! MessageSend
                    cell.selectionStyle = .none
                    cell.minHeightSenderTwo = 140
                    let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                    
                    let msgId = dic.messageID ?? ""
                    var isSend = false
                    
                    if SeenModel.shared.arrSeen.contains(where: {$0.msgID == msgId}) {
                        isSend = true
                    } else {
                        isSend = false
                    }
                    
                    cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, imageType: (dic.fileType ?? ""), isSent: isSend)
                    
                    cell.btnOpen.tag = indexPath.row
                    
                    let link = dic.filePath ?? ""
                    let newURl = URL(string: ("file://\(link)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    
                    FileDownloader.checkPathIsAvailable(url: URL(string: newURl!.absoluteString)!) { (path) in
                        if (path) {
                            cell.btnOpen.setTitle("Open", for: .normal)
                        }
                        else {
                            cell.btnOpen.setTitle("Open", for: .normal)
                        }
                    }
                    cell.btnOpen.tag = indexPath.row
                    cell.openButtonPressed = {
                        if (cell.btnOpen?.titleLabel?.text ?? "") == "Download" {
                            cell.spinner.isHidden = false
                            cell.spinner.startAnimating()
                        }
                        
                        guard let link = dic.filePath else { return }
                        
                        if (link.hasPrefix("http://")) || (link.hasPrefix("https://")) {
                            FileDownloader.loadFileAsync2(url: URL(string: link)!, folder: .documentSent) { (path, error, url)  in
                                guard let paths = path else {
                                    return }
                                
                                DispatchQueue.main.async {
                                    self.tblChat.reloadData()
                                    cell.spinner.isHidden = true
                                    cell.spinner.stopAnimating()
                                    
                                    if (cell.btnOpen?.titleLabel?.text ?? "") == "Open" {
                                        
                                        guard let newURl = URL(string: ("file://\(paths)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
                                        
                                        let vc = WebViewVC()
                                        vc.url = newURl
                                        UIApplication.shared.keyWindow!.rootViewController?.present(vc, animated: true)
                                    }
                                }
                            }
                        }
                        else {
                            let pathNew = FileDownloader.checkPathIsAvailable2(folder: .documentSent, url: URL(string: link)!)
                            if (pathNew != nil) {
                                guard let newURl = pathNew else {return }
                                let vc = WebViewVC()
                                vc.url = newURl.absoluteURL
                                DispatchQueue.main.async {
                                    UIApplication.shared.keyWindow!.rootViewController?.present(vc, animated: true)
                                }
                            }
                        }
                    }
                    return cell
                }
            }
        }
        else {
            if dic.messageType ?? "" == "TEXT" {
                let cell = MessageReceivedCell()
                cell.selectionStyle = .none
                let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                cell.configureCell(message: (dic.message ?? ""), font: lableHeight, dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!)
                
                cell.lblMessage.numberOfLines = 0
                cell.btnSeeMore.isHidden = true
                
                if (dic.showMore == 0) {
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
            
            else if dic.messageType ?? "" == "quicklink" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
                cell.size = Double(lableHeight)
                cell.setupUI()
                let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                cell.lblTime.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                cell.btnOpenLink.tag = indexPath.row
                cell.btnOpenLink.addTarget(self, action: #selector(handleOpenLinkBtn(_:)), for: .touchUpInside)
                return cell
            }
            
            else if dic.messageType ?? "" == "videolink" {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
                cell.size = Double(lableHeight)
                cell.setupUI()
                cell.lblAgent.text = "Agent has shared a video link"
                cell.btnOpenLink.setTitle("Open Video Link", for: .normal)
                
                let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                cell.lblTime.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                cell.btnOpenLink.tag = indexPath.row
                cell.btnOpenLink.addTarget(self, action: #selector(handleOpenVideoLinkBtn(_:)), for: .touchUpInside)
                return cell
            }
            
            else {
                if dic.fileType ?? "" == "jpg" ||  dic.fileType ?? "" == "png" ||  dic.fileType ?? "" == "jpeg" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageAttachementSendTVC", for: indexPath) as! MessageAttachementSendTVC
                    cell.minHeightSenderImage = 230
                    let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                    let _ = URL(string: (dic.filePath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                    
                    cell.messageSendImageView.isUserInteractionEnabled = true
                    let tapped = UITapGestureRecognizer(target: self, action: #selector(imageSavingFunction))
                    tapped.numberOfTapsRequired = 1
                    cell.messageSendImageView.tag =  indexPath.row
                    cell.messageSendImageView.addGestureRecognizer(tapped)
                    
                    cell.cellConfigure(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, image: nil)
                    cell.activityView.isHidden = false
                    cell.activityView.startAnimating()
                    
                    cell.messageSendImageView.loadThumbnail(urlSting: (dic.filePath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") { (image) in
                        cell.activityView.isHidden = true
                        cell.activityView.stopAnimating()
                        cell.messageSendImageView.image = image
                    }
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MessageReceive", for: indexPath) as! MessageReceive
                    cell.minHeightReceiver = 140
                    let datePassed = DataFile.StringToDateAgo(Date: dic.dateTime ?? "")
                    cell.timeagoLbl.text = DataFile.timeAgoStringFromDate(date: datePassed)!
                    
                    cell.configureCell(dateAgoLbl: DataFile.timeAgoStringFromDate(date: datePassed)!, imageType: dic.fileType ?? "")
                    
                    cell.downloadBtnAction.tag = indexPath.row
                    let link = (dic.filePath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
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
                        
                        let link = (dic.filePath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        let url = URL(string: link)
                        
                        FileDownloader.loadFileAsync(url: url!) { (path, error, url)  in
                            guard let paths = path else {
                                return }
                            
                            
                            DispatchQueue.main.async {
                                self.tblChat.reloadData()
                                cell.spinner.isHidden = true
                                cell.spinner.stopAnimating()
                                
                                if (cell.downloadBtnAction?.titleLabel?.text ?? "") == "Open" {
                                    
                                    guard let newURl = URL(string: ("file://\(paths)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
                                    
                                    let vc = WebViewVC()
                                    vc.url = newURl
                                    UIApplication.shared.keyWindow!.rootViewController?.present(vc, animated: true)
                                }
                            }
                        }
                    }
                    return cell
                }
            }
        }
    }
    
    public  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dic =  Messaging.shared.obj[indexPath.row]
        if dic.messageType ?? "" == "FILE" {
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
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        //            if indexPath.row == 0 {
        //                let dic = self.messageViewModel.messageArray[0] as NSDictionary
        //                let constantDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "sessionId": UserDetails.sessionID, "userName": SocketHelper.userName,"userId":SocketHelper.userID, "dateTime" : dic.value(forKey: "DateTime") as! String]
        //                let eventDictionary : [String:Any] = ["eventName":"chatHistory", "data": constantDictionary]
        //                ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
        //            }
        //        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = Messaging.shared.obj[indexPath.row]
        let userType = dic.type ?? ""
        
        if userType != "SYSTEM"  && userType != "USER" {
            if dic.messageType ?? "" == "quicklink" || dic.messageType ?? "" == "TEXT" {
                let temp = LinkDetecter.getLinks(in: dic.message ?? "")
                
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
    
    
    //MARK:- Open Sent Image
    @objc func openSentImageFunc(gesture: UITapGestureRecognizer){
        let imageDic = Messaging.shared.obj[gesture.view!.tag]
       
        let keyExists = imageDic.filePath != nil
        tappedImageView.delegate = self
        let screenSize = UIScreen.main.bounds.size
        tappedImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.tappedImageView.backgroundColor = .white
        self.addSubview(tappedImageView)
        if keyExists {
            let url = URL(string: (imageDic.filePath ?? ""))
            if (url == nil) {
                DispatchQueue.global().async {
                    let newImageData = Data(base64Encoded: (imageDic.message ?? ""))
                    DispatchQueue.main.async {
                        if let newImageData = newImageData {
                            self.tappedImageView.fullscreenImage.image = UIImage(data: newImageData)
                        }
                    }
                }
            }
            else {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            self.tappedImageView.fullscreenImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }else{
            let newImageData = Data(base64Encoded: (imageDic.message ?? ""))
            if let newImageData = newImageData {
                self.tappedImageView.fullscreenImage.image = UIImage(data: newImageData)
            }
        }
    }
    
    func didCancelImageViewButtonTapped(){
        self.tappedImageView.removeFromSuperview()
    }
    
    //MARK:- Save Image
    @objc func imageSavingFunction(gesture: UITapGestureRecognizer) {
        
        self.tappedImageView.backgroundColor = .white
        self.tappedImageView.fullscreenImage.image = UIImage()
        
        let imageDic = Messaging.shared.obj[gesture.view!.tag]
        let _ = URL(string: (imageDic.filePath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        // DataFile.savefile(imageURL: url!){(result) in
        DispatchQueue.main.async  {
            self.tappedImageView.delegate = self
            let screenSize = UIScreen.main.bounds.size
            self.tappedImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
            self.addSubview(self.tappedImageView)
            
            self.tappedImageView.fullscreenImage.loadThumbnail(urlSting: (imageDic.filePath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) { (image) in
                
                DispatchQueue.main.async {
                    self.tappedImageView.fullscreenImage.image = image
                }
            }
        }
    }
}
extension UIView {
    public class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension ChatView : ChatHistoryClickedProtocol {
    func clicked(chatInteractionId: String) {
        let popup = ChatHistoryDetailsView()
        popup.chatInteractionId = chatInteractionId
        popup.frame =  UIScreen.main.bounds
        popup.setupUI()
        self.window?.addSubview(popup)
        
        let dict : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": chatInteractionId, "token": UserDetails.token, "sessionId": UserDetails.sessionID, "userName": SocketHelper.userName,"userId":SocketHelper.userID, "dateTime":UserDetails.getCurrentFormattedDate()]
        
        let eventDictionary : [String:Any] = ["eventName":"previousChatHistory", "data": dict]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
}

extension ChatView : ReloadTableHeightPr {
    func HandleHeight(index: Int) {
        if (Messaging.shared.obj[index].showMore == 0) {
            Messaging.shared.obj[index].showMore = 4
        }
        else {
            Messaging.shared.obj[index].showMore = 0
        }
        self.tblChat.reloadData()
    }
}

extension  ChatView: UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}


extension ChatView {
    
    //MARK:- Config Cobrowse
    @objc func configCobrowse(_ notification: NSNotification) {
        
        HoverBtn.shared.hoverView.isHidden = false
        
        let messageDictionary : [String:Any] = ["Message": "Cobrowsing initiated... Session ID: ", "MessageType" : "TEXT", "Type": "User", "FileType":"text", "DateTime":UserDetails.getCurrentFormattedDate(), "MessageId":UserDetails.messageID]
        
        let dataDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "message": messageDictionary]
        let eventDictionary : [String:Any] = ["eventName":"cobrowseStarted", "data": dataDictionary]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
        
        dataAppendInBaseArray(messageString: "\(UserDetails.shareCoBrowseURL)\(UserDetails.chatInteractionID)", msgType: "TEXT", filetype: "Text", fileName: "",fileSize: "", filePath: "")
        
        let messageDictionary1 : [String:Any] = ["Message": "Cobrowsing initiated... Session ID: ", "MessageType" : "TEXT", "Type": "User", "FileType":"text", "DateTime":UserDetails.getCurrentFormattedDate(), "MessageId":UserDetails.messageID]
         
         let dataDictionary1 : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "message": messageDictionary1]
         let eventDictionary1 : [String:Any] = ["eventName":"newMessage", "data": dataDictionary1]
         ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary1)
         dataAppendInBaseArray(messageString: "\(UserDetails.shareCoBrowseURL)\(UserDetails.chatInteractionID)", msgType: "TEXT", filetype: "Text", fileName: "",fileSize: "", filePath: "")
    }
    
    //MARK:- Handle AgentJoined
    @objc func agentJoined(_ notification: NSNotification) {
        self.imageTimer = Timer.scheduledTimer(withTimeInterval: 0.125, repeats: true) { [weak self] _ in
            let imageData = imageFucntion.screenShot(userAllowed: "T", showScreen: "T")
            
            if self?.oldImgData != imageData {
                
                self?.oldImgData = imageData ?? ""
                let data: [String:Any] =  ["base64":imageData ?? "","currentOrientation":"Portrait"]
                
                guard let data1 = UIApplication.jsonData(from: data)else {
                    return
                }
                
                DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
                let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
                DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
                CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "newScreen", arg: encryptedData)
            }
        }
    }
    
    //MARK:- Handle Permission
    @objc func showPermission(_ notification: NSNotification) {
        if let dic = notification.userInfo as NSDictionary? {
            
            let window = UIApplication.shared.keyWindow!
            
            for v in (window.subviews) {
                if v.isKind(of: PermissionPopup.self) {
                    v.removeFromSuperview()
                }
            }
            
            let message = dic["message"] as? String ?? ""
            let permissionFor = dic["permissionFor"] as? String ?? ""
            let title = dic["title"] as? String ?? ""
            
            let popup = PermissionPopup()
            popup.frame = self.bounds
            popup.createUI(title: title, msg: message, permissionFor: permissionFor)
            popup.delegate = self
            window.addSubview(popup)
        }
    }
    
    @objc func cobrowseEndSuccess(_ notification: NSNotification) {
        if let dic = notification.userInfo as NSDictionary? {
            if let _ = dic["eventName"] as? String {
                self.toastView(msg: "CoBrowse session closed")
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    HoverBtn.shared.hoverView.isHidden = true
                    HoverBtn.shared.hoverView.removeFromSuperview()
                    AgentJoined.disconnectTimer()
                    CobrowseSocketHelper.shared.disconnect()
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                }
            }
        }
    }
}

extension ChatView : ShareScreenPr {
    public func value(tag: Int) {
        if (tag == 1) {
            self.endCobrowseSession()
        }
    }
}

extension ChatView : PermissionPopupPr {
    func handleStartBtn(permissionFor: String) {
        switch permissionFor {
        case "lazerAccess" :
            let data: [String:Any] =  ["lazerAccess": "true"]
            guard let data1 = UIApplication.jsonData(from: data)else {
                return
            }
            
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "permissionResponse", arg: encryptedData)
            
        case "drawAccess" :
            let data: [String:Any] =  ["drawAccess": "true"]
            guard let data1 = UIApplication.jsonData(from: data)else {
                return
            }
            
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "permissionResponse", arg: encryptedData)
            
        case "remoteAccess" :
            let data: [String:Any] =  ["remoteAccess": "true"]
            guard let data1 = UIApplication.jsonData(from: data)else {
                return
            }
            
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "permissionResponse", arg: encryptedData)
            
        default :
            break
        }
    }
    
    func handleCancelBtn(permissionFor: String) {
        
        switch permissionFor {
        case "lazerAccess" :
            let data: [String:Any] =  ["lazerAccess": "false"]
            guard let data1 = UIApplication.jsonData(from: data)else {
                return
            }
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "permissionResponse", arg: encryptedData)
            break
            
        case "drawAccess" :
            let data: [String:Any] =  ["drawAccess": "false"]
            guard let data1 = UIApplication.jsonData(from: data)else {
                return
            }
            
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "permissionResponse", arg: encryptedData)
            
        case "remoteAccess" :
            let data: [String:Any] =  ["remoteAccess": "false"]
            guard let data1 = UIApplication.jsonData(from: data)else {
                return
            }
            
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "permissionResponse", arg: encryptedData)
            
        default :
            break
        }
    }
}


struct DetectedLinkData {
    
    var link: URL
    var range: Range<String.Index>
    init(link: URL, range: Range<String.Index>) {
        self.link = link
        self.range = range
    }
}

class LinkDetecter {
    
    static func getLinks(in string: String) -> [DetectedLinkData] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }
        var result: [DetectedLinkData] = []
        let matches = detector.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count) )
        for match in matches {
            guard let range = Range(match.range, in: string),
                  let url = URL(string: String(string[range]) )
            else {
                continue
            }
            result.append(DetectedLinkData(link: url, range: range))
        }
        return result
    }
}


extension ChatView : HoverBtnPr {
    func handleDisconnect() {
        self.endCobrowseSession()
    }
}

extension ChatView : MenuPr {
    func value(text: String) {
        
        let btn = UIButton()
        switch text {
        case "Home":
            backBtn(btn)
            break
            
        case "Video Call":
            startVideoBtnTapped(btn)
            break
            
        case "Feedback":
            self.endEditing(true)
            bottomViewConstraint.constant = 0
            Feedback.openFeedback()
            break
            
        case "Chat With Agent":
            break
            
        case "End Conversation":
            cancelBtn(btn)
            break
            
        case "Co-Browsing":
            screenShareBtn(btn)
            break
        
        default:
            break
        }
    }
}


