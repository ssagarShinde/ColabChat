//
//  MessageAttachementReceiveTVC.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 20/03/21.
//

import UIKit

class MessageAttachementReceiveTVC: UITableViewCell {

    @IBOutlet weak var messageReceiveImageView: UIImageView! {
        didSet {
            messageReceiveImageView.layer.cornerRadius = 20
            messageReceiveImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var ReceiverView: UIView!
    @IBOutlet weak var ivImage: UIImageView!
    
    @IBOutlet weak var timeagoLbl: UILabel!
    
    var minHeightReceiverImage: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell (dateAgoLbl: String, image : Data?, isSent: Bool){
        timeagoLbl.text = dateAgoLbl
        
        if isSent == true {
            ivImage.image = UIImage(named: "colabDone", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivImage.tintColor = Colors.green
        }
        else{
            ivImage.image = UIImage(named: "colabDoneSingle", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            ivImage.tintColor = Colors.green
        }
        guard let data = image else {return}
        messageReceiveImageView.image = UIImage(data: data)
    }
}
