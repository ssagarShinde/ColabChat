//
//  MessageSend.swift
//  ChatApp
//
//  Created by SmartConnect Technologies on 31/03/21.
//

import UIKit

class MessageSend: UITableViewCell {
    
    @IBOutlet weak var attachmentView: UIView! {
        didSet {
            attachmentView.layer.cornerRadius = 20
            attachmentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        }
    }
    
    
    @IBOutlet weak var fileTypeImage: UIImageView!
    @IBOutlet weak var timeAgoLbl: UILabel!
    @IBOutlet weak var btnOpen: UIButton!
    
    @IBOutlet weak var ivSeen: UIImageView! {
        didSet {
            ivSeen.tintColor = Colors.green
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.isHidden = true
        }
    }
    
    var minHeightSenderTwo: CGFloat?
    var openButtonPressed : (() -> ()) = {}
    
    @objc func openButtonAction(_ sender: Any) {
        openButtonPressed()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        btnOpen.addTarget(self, action: #selector(openButtonAction(_:)), for: .touchUpInside)
        attachmentView.layer.cornerRadius = 15.0
        attachmentView.clipsToBounds = true
        attachmentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeightSenderTwo else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
    func configureCell (dateAgoLbl: String, imageType : String, isSent : Bool){
        timeAgoLbl.text = dateAgoLbl
        switch imageType {
        
        case "txt", "doc", "docx":
            if #available(iOS 13.0, *) {
                fileTypeImage.image = UIImage.init(named: "colabDocx", in: Bundle(for: type(of:self)), with: nil)
            } else {
                fileTypeImage.image = UIImage(named: "colabDocx", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        case "pdf":
            if #available(iOS 13.0, *) {
                fileTypeImage.image = UIImage.init(named: "colabPDF", in: Bundle(for: type(of:self)), with: nil)
            } else {
                fileTypeImage.image = UIImage(named: "colabPDF", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        case "ppt", "pptx":
            if #available(iOS 13.0, *) {
                fileTypeImage.image = UIImage.init(named: "colabPPT", in: Bundle(for: type(of:self)), with: nil)
            } else {
                fileTypeImage.image = UIImage(named: "colabPPT", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        case "xlsx", "xls":
            if #available(iOS 13.0, *) {
                fileTypeImage.image = UIImage.init(named: "colabXLS", in: Bundle(for: type(of:self)), with: nil)
            } else {
                fileTypeImage.image = UIImage(named: "colabXLS", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        default:
            if #available(iOS 13.0, *) {
                fileTypeImage.image = UIImage.init(named: "colabOther", in: Bundle(for: type(of:self)), with: nil)
            } else {
                fileTypeImage.image = UIImage.init(named: "colabOther", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
        }
        
        if isSent == true {
            ivSeen.image = UIImage(named: "colabDone", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivSeen.tintColor = Colors.green
        }
        else {
            ivSeen.image = UIImage(named: "colabDoneSingle", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivSeen.tintColor = Colors.green
        }
    }
}
