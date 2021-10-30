//
//  MessageAttachementSendTVC.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 20/03/21.
//

import UIKit

class MessageAttachementSendTVC: UITableViewCell {

    @IBOutlet weak var messageSendImageView: UIImageView!
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var sendTimeago: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView! {
        didSet {
            activityView.isHidden = false
        }
    }
    
    
    var minHeightSenderImage: CGFloat?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderView.layer.cornerRadius = 15.0
        senderView.clipsToBounds = true
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
          let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
          guard let minHeight = minHeightSenderImage else { return size }
          return CGSize(width: size.width, height: max(size.height, minHeight))
      }
    
    func cellConfigure(dateAgoLbl: String, image : Data?){
        sendTimeago.text = dateAgoLbl
        guard let data = image else {return}
        messageSendImageView.image = UIImage(data: data)
    }
}
