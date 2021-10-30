//
//  MessageReceive.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 17/05/21.
//

import UIKit

class MessageReceive: UITableViewCell {

    
    @IBOutlet weak var attchmentReceiveView: UIView!
    
    @IBOutlet weak var attachmentType: UIImageView!
    @IBOutlet weak var timeagoLbl: UILabel!
    @IBOutlet weak var downloadBtnAction: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.isHidden = true
        }
    }
    
    var minHeightReceiver: CGFloat?
    
    var openButtonPressed : (() -> ()) = {}
    
    @objc func openButtonAction(_ sender: Any) {
        openButtonPressed()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        downloadBtnAction.addTarget(self, action: #selector(openButtonAction(_:)), for: .touchUpInside)
        attchmentReceiveView.layer.cornerRadius = 15
        attchmentReceiveView.clipsToBounds = true
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeightReceiver else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
    func configureCell (dateAgoLbl: String, imageType : String){
        timeagoLbl.text = dateAgoLbl
        switch imageType {
        
        case "txt", "doc", "docx":
            if #available(iOS 13.0, *) {
                attachmentType.image = UIImage.init(named: "colabDocx", in: Bundle(for: type(of:self)), with: nil)
            } else {
                attachmentType.image = UIImage(named: "colabDocx", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        case "pdf":
            if #available(iOS 13.0, *) {
                attachmentType.image = UIImage.init(named: "colabPDF", in: Bundle(for: type(of:self)), with: nil)
            } else {
                attachmentType.image = UIImage(named: "colabPDF", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        case "ppt", "pptx":
            if #available(iOS 13.0, *) {
                attachmentType.image = UIImage.init(named: "colabPPT", in: Bundle(for: type(of:self)), with: nil)
            } else {
                attachmentType.image = UIImage(named: "colabPPT", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        case "xlsx", "xls":
            if #available(iOS 13.0, *) {
                attachmentType.image = UIImage.init(named: "colabXLS", in: Bundle(for: type(of:self)), with: nil)
            } else {
                attachmentType.image = UIImage(named: "colabXLS", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
            
        default:
            if #available(iOS 13.0, *) {
                attachmentType.image = UIImage.init(named: "colabOther", in: Bundle(for: type(of:self)), with: nil)
            } else {
                attachmentType.image = UIImage.init(named: "colabOther", in: Bundle(for: type(of:self)), compatibleWith: nil)
            }
        }
    }
}
