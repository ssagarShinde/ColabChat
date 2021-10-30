//
//  CreateTicketVC.swift
//  ChatLib
//
//  Created by Sagar on 22/09/21.
//

import UIKit

public class CreateTicketVC: BaseController {
    
    let scrollViewMain = CustomeScrollView()
    let viewBack = UIView()

    let btnSingleSelection = UIButton()
    let btnMultipleSelection = UIButton()
    
    let tfUserId = UITextField()
    let tfName = UITextField()
    let tfMobile = UITextField()
    let tfEmail = UITextField()
    let tfComplaintCat = UITextField()
    let tfLocation = UITextField()
    let tfPriority = UITextField()
    let tfSubject = UITextField()
    let textViews = UITextView()
    
    var selectedIndex = [Int]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(self.caseCreatedSuccess(_:)), name: NSNotification.Name(rawValue: "CaseCreatedSuccess"), object: nil)
        
        setupUI()
        setupTextData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        createNavigationBarWithBack("Customer Services")
    }
    
    fileprivate func setupUI() {
        
        let viewMain = UIView()
        viewMain.clipsToBounds = true
        viewMain.backgroundColor = .white
        viewMain.layer.cornerRadius = 16
        viewMain.addShadow()
        view.addSubview(viewMain)
        viewMain.enableAutolayout()
        viewMain.topMargin(BaseController.getStatusBarHeight + (self.navigationController?.navigationBar.frame.size.height ?? 0.0) + 30)
        viewMain.bottomMargin(30)
        viewMain.leadingMargin(20)
        viewMain.trailingMargin(20)
        
        let ivLogo = UIImageView()
        ivLogo.clipsToBounds = true
        ivLogo.layer.cornerRadius = 8
        ivLogo.image = UIImage(named: "colabClipboard", in: Bundle(for: type(of: self)), compatibleWith: nil)
        viewMain.addSubview(ivLogo)
        ivLogo.enableAutolayout()
        ivLogo.topMargin(20)
        ivLogo.leadingMargin(30)
        ivLogo.fixWidth(40)
        ivLogo.fixHeight(40)
        
        let lblText = UILabel()
        lblText.adjustsFontSizeToFitWidth = true
        lblText.text = "Please Enter Below Detials"
        lblText.font = UIFont(name: Fonts.HelveticaNeueMedium, size: 22)
        lblText.textColor = Colors.theme
        viewMain.addSubview(lblText)
        lblText.enableAutolayout()
        lblText.topMargin(16)
        lblText.fixHeight(30)
        lblText.add(toRight: 8, of: ivLogo)
        lblText.trailingMargin(8)
        
        let lblSubText = UILabel()
        lblSubText.numberOfLines = 0
        lblSubText.text = "Lorem Ipsum is simply dummy text of the printing"
        lblSubText.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 14)
        lblSubText.textColor = Colors.sendTime
        viewMain.addSubview(lblSubText)
        lblSubText.enableAutolayout()
        lblSubText.belowView(4, to: lblText)
        lblSubText.flexibleHeightGreater(30)
        lblSubText.add(toRight: 8, of: ivLogo)
        lblSubText.trailingMargin(8)
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        viewMain.addSubview(separator)
        separator.enableAutolayout()
        separator.belowView(20, to: lblSubText)
        separator.fixHeight(1)
        separator.leadingMargin(0)
        separator.trailingMargin(0)
    
        scrollViewMain.backgroundColor = UIColor.white
        scrollViewMain.bounces = true
        scrollViewMain.isScrollEnabled = true
        scrollViewMain.showsVerticalScrollIndicator = true
        viewMain.addSubview(scrollViewMain)
        scrollViewMain.enableAutolayout()
        scrollViewMain.leadingMargin(0)
        scrollViewMain.trailingMargin(0)
        scrollViewMain.belowView(8, to: separator)
        scrollViewMain.bottomMargin(8)
        
        // Main View Under Scroll View
        viewBack.backgroundColor = .white
        scrollViewMain.addSubview(viewBack)
        viewBack.enableAutolayout()
        viewBack.centerX()
        viewBack.fixWidth(screenWidth - 60)
        viewBack.topMargin(8)
        viewBack.bottomMargin(8)
        viewBack.flexibleHeightGreater(10)
        
        // TextFiled
        
        tfUserId.setProperties()
        tfUserId.delegate = self
        tfUserId.tag = 100
        tfUserId.placeholder = "User ID"
        viewBack.addSubview(tfUserId)
        tfUserId.enableAutolayout()
        tfUserId.topMargin(20)
        tfUserId.leadingMargin(16)
        tfUserId.trailingMargin(16)
        tfUserId.fixHeight(45)
        
        tfName.setProperties()
        tfName.delegate = self
        tfName.tag = 101
        tfName.placeholder = "Your Full Name"
        viewBack.addSubview(tfName)
        tfName.enableAutolayout()
        tfName.belowView(20, to: tfUserId)
        tfName.leadingMargin(16)
        tfName.trailingMargin(16)
        tfName.fixHeight(45)
        
        tfMobile.setProperties()
        tfMobile.delegate = self
        tfMobile.tag = 102
        tfMobile.placeholder = "Contact Number"
        viewBack.addSubview(tfMobile)
        tfMobile.enableAutolayout()
        tfMobile.belowView(20, to: tfName)
        tfMobile.leadingMargin(16)
        tfMobile.trailingMargin(16)
        tfMobile.fixHeight(45)
        
        tfEmail.setProperties()
        tfEmail.delegate = self
        tfEmail.tag = 103
        tfEmail.placeholder = "Email ID"
        viewBack.addSubview(tfEmail)
        tfEmail.enableAutolayout()
        tfEmail.belowView(20, to: tfMobile)
        tfEmail.leadingMargin(16)
        tfEmail.trailingMargin(16)
        tfEmail.fixHeight(45)
        
         // Single Selection
        btnSingleSelection.tag = 200
        btnSingleSelection.clipsToBounds = true
        btnSingleSelection.titleLabel?.numberOfLines = 0
        btnSingleSelection.contentHorizontalAlignment = .left
        btnSingleSelection.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        btnSingleSelection.setImage(UIImage(named: "Shape"), for: .normal)
        btnSingleSelection.setTitle("Complaint Category", for: .normal)
        if #available(iOS 13.0, *) {
            btnSingleSelection.setTitleColor(UIColor.placeholderText, for: .normal)
        } else {
            btnSingleSelection.setTitleColor(UIColor.lightGray, for: .normal)
        }
        btnSingleSelection.layer.cornerRadius = 5
        btnSingleSelection.layer.borderWidth = 1
        btnSingleSelection.layer.borderColor = Colors.sendTime.cgColor
        btnSingleSelection.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        btnSingleSelection.addTarget(self,action:#selector(handleSingleSelection(_:)),for:.touchUpInside)
        viewBack.addSubview(btnSingleSelection)
        btnSingleSelection.enableAutolayout()
        btnSingleSelection.belowView(20, to: tfEmail)
        btnSingleSelection.flexibleHeightGreater(45)
        btnSingleSelection.leadingMargin(16)
        btnSingleSelection.trailingMargin(16)
        
         let downArrow = UIImageView()
         downArrow.clipsToBounds = true
         downArrow.contentMode = .scaleAspectFit
         downArrow.image = UIImage(named: "colabDown", in: Bundle(for: type(of: self
         )), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
         downArrow.tintColor = UIColor.gray
         btnSingleSelection.addSubview(downArrow)
         downArrow.enableAutolayout()
         downArrow.fixHeight(20)
         downArrow.fixWidth(20)
         downArrow.trailingMargin(16)
         downArrow.centerY()
        
        
        tfLocation.setProperties()
        tfLocation.delegate = self
        tfLocation.tag = 104
        tfLocation.placeholder = "Location"
        viewBack.addSubview(tfLocation)
        tfLocation.enableAutolayout()
        tfLocation.belowView(20, to: btnSingleSelection)
        tfLocation.leadingMargin(16)
        tfLocation.trailingMargin(16)
        tfLocation.fixHeight(45)
        
        btnMultipleSelection.tag = 201
        btnMultipleSelection.sizeToFit()
        btnMultipleSelection.clipsToBounds = true
        btnMultipleSelection.titleLabel?.numberOfLines = 0
        btnMultipleSelection.contentHorizontalAlignment = .left
        btnMultipleSelection.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        btnMultipleSelection.setImage(UIImage(named: "Shape"), for: .normal)
        btnMultipleSelection.setTitle("Priority", for: .normal)
        if #available(iOS 13.0, *) {
            btnMultipleSelection.setTitleColor(UIColor.placeholderText, for: .normal)
        } else {
            btnMultipleSelection.setTitleColor(UIColor.lightGray, for: .normal)
        }
        btnMultipleSelection.layer.cornerRadius = 5
        btnMultipleSelection.layer.borderWidth = 1
        btnMultipleSelection.layer.borderColor = Colors.sendTime.cgColor
        btnMultipleSelection.titleEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btnMultipleSelection.addTarget(self,action:#selector(handleMultipleSelection(_:)),for:.touchUpInside)
        viewBack.addSubview(btnMultipleSelection)
        btnMultipleSelection.enableAutolayout()
        btnMultipleSelection.belowView(20, to: tfLocation)
        btnMultipleSelection.flexibleHeightGreater(45)
        btnMultipleSelection.leadingMargin(16)
        btnMultipleSelection.trailingMargin(16)
        
        let downArrow1 = UIImageView()
        downArrow1.clipsToBounds = true
        downArrow1.contentMode = .scaleAspectFit
        downArrow1.image = UIImage(named: "colabDown", in: Bundle(for: type(of: self
        )), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        downArrow1.tintColor = UIColor.gray
        btnMultipleSelection.addSubview(downArrow1)
        downArrow1.enableAutolayout()
        downArrow1.fixHeight(20)
        downArrow1.fixWidth(20)
        downArrow1.trailingMargin(16)
        downArrow1.topMargin(10)
        
        tfSubject.setProperties()
        tfSubject.delegate = self
        tfSubject.tag = 105
        tfSubject.placeholder = "Subject"
        viewBack.addSubview(tfSubject)
        tfSubject.enableAutolayout()
        tfSubject.belowView(20, to: btnMultipleSelection)
        tfSubject.leadingMargin(16)
        tfSubject.trailingMargin(16)
        tfSubject.fixHeight(45)
        
        
        // TextView
        textViews.delegate = self
        let toolbar = UIToolbar().ToolbarPiker(mySelect: #selector(handToolBar), title: "Done")
        textViews.inputAccessoryView = toolbar
        textViews.setProperties()
        textViews.textColor = Colors.sendTime
        textViews.text = "Enter comments"
        textViews.tag = 106
        viewBack.addSubview(textViews)
        textViews.enableAutolayout()
        textViews.belowView(20, to: tfSubject)
        textViews.leadingMargin(16)
        textViews.trailingMargin(16)
        textViews.fixHeight(100)
        
        let btnSave = UIButton()
        btnSave.backgroundColor = Colors.theme
        btnSave.contentHorizontalAlignment = .center
        btnSave.titleLabel?.font = UIFont(name: Fonts.HelveticaNeueRegular, size: 16)
        btnSave.setTitle("SUBMIT", for: .normal)
        btnSave.setTitleColor(.white, for: .normal)
        btnSave.layer.cornerRadius = 25
        btnSave.addTarget(self,action:#selector(handleSave(_:)),for:.touchUpInside)
        viewBack.addSubview(btnSave)
        btnSave.enableAutolayout()
        btnSave.belowView(30, to: textViews)
        btnSave.fixHeight(50)
        btnSave.leadingMargin(16)
        btnSave.trailingMargin(16)
        btnSave.bottomMargin(30)
    }
    
    fileprivate func setupTextData() {
        tfName.text = SocketHelper.userName
        tfUserId.text = SocketHelper.userID
        tfEmail.text = SocketHelper.emialId
        tfMobile.text = SocketHelper.mobileNumber
    }
    
    @objc public override func handToolBar() {
        view.endEditing(true)
    }
    
    @objc fileprivate func handleSave(_ sender : UIButton) {
        view.endEditing(true)
    
        if (tfUserId.text ?? "" == "") {
            toastView(msg: "Enter User Id")
            return
        }
        
        if (tfName.text ?? "" == "") {
            toastView(msg: "Enter User Name")
            return
        }
        
        if ((LinkSocket.shared.linkSocket?.status ?? .notConnected) == .connected) {
            
            let mainDict : [String:Any] = [
                "userID": SocketHelper.userID,
                "name": SocketHelper.userName,
                "number": tfMobile.text!,
                "emailID": tfEmail.text!,
                "contactNo": tfMobile.text!,
                "replyEmailTo": tfEmail.text!,
                "emailTo": tfEmail.text!,
                "requestType": "Complaint",
                "location": "MobCast Innovations Pvt. Ltd 505 Tanishka, 5th Floor Nr Growels 101 Mall, Akurli Rd, Kandivali, Akurli Industry Estate, Kandivali East, Mumbai, Maharashtra 400101, India",
                "priority": "Normal",
                "subject": tfSubject.text ?? "",
                "description": description,
                "status": "Open"
            ]
            let eventNameDict : [String:Any] = ["eventName":"createCase","data":mainDict]
            LinkSocket.shared.linkSocketEmit(eventName: "req", arg: eventNameDict)
            
        }
        else {
            LinkSocket.shared.establishConnections(replyEmailTo:  tfEmail.text!, description: textViews.text!, subject: tfSubject.text!, priority: btnMultipleSelection.titleLabel!.text!, status: "true", requestType: "", sourceChannel: "", userType: "", businessHours: "", source: "", sourceId: "", UploadFileNames: "", contactNo: tfMobile.text!, emailTo: tfEmail.text!)
        }
    }
    
    
    @objc func handleMultipleSelection(_ sender : UIButton) {
        self.view.endEditing(true)
        /*let popup = MultiSliderPopup()
        popup.isMultiSelect = false
        popup.delegateMulti = self
        popup.frame = view.bounds
        popup.createUI(title: "Select Option", arrOption: ["Low", "Medium", "High", "Critical"], isMulti: true, text: (btnMultipleSelection.titleLabel?.text ?? ""), selectedArr: self.selectedIndex, tags: sender.tag)
        UIApplication.shared.keyWindow?.addSubview(popup)*/
        
        self.view.endEditing(true)
        let popup = SliderPopup()
        popup.tags = sender.tag
        popup.delegate = self
        popup.frame = view.bounds
        popup.createUI(title: "Select Single Option", arrOption:["Low", "Medium", "High", "Critical"], tag: sender.tag)
        UIApplication.shared.keyWindow?.addSubview(popup)
        
    }
    
    @objc func handleSingleSelection(_ sender : UIButton) {
        self.view.endEditing(true)
        let popup = SliderPopup()
        popup.tags = sender.tag
        popup.delegate = self
        popup.frame = view.bounds
        popup.createUI(title: "Select Single Option", arrOption: ["Data Validation", "QC", "Query", "Request", "Complaint", "Feedback"], tag: sender.tag)
        UIApplication.shared.keyWindow?.addSubview(popup)
    }
}


//MARK: Handle Event
extension CreateTicketVC {
    @objc func caseCreatedSuccess(_ notification: NSNotification) {
        let dict = notification.userInfo as NSDictionary?
        if let data = dict?["data"] as? [String:Any] {
            let msg = data["data"] as? String ?? ""
            let caseID = data["caseid"] as? String ?? ""
            
            DispatchQueue.main.async {
                let popup = LinkSuccessPopup()
                popup.frame = self.view.bounds
                popup.createUI(msg: msg, ticketId: caseID)
                UIApplication.shared.keyWindow?.addSubview(popup)
            }
        }
    }
}

extension CreateTicketVC : MultiSelectionDelegate, SelectionDelegate {
    func multipleSelectedOption(_ selectedIndexes: [Int], _ multiText: String, _ tag: Int) {
        if let btnSender = self.view.viewWithTag(tag) as? UIButton {
            btnSender.setTitle(multiText, for: .normal)
            btnSender.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    func SelectedText(tag: Int, text: String, index: Int) {
        if let btnSender = self.view.viewWithTag(tag) as? UIButton {
            btnSender.setTitle(text, for: .normal)
            btnSender.setTitleColor(UIColor.black, for: .normal)
        }
    }
}

extension CreateTicketVC : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder :UIResponder  = textField.superview?.viewWithTag(nextTag) as UIResponder? {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension CreateTicketVC : UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter comments"{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter comments"
            textView.textColor = Colors.sendTime
        }
    }
}
