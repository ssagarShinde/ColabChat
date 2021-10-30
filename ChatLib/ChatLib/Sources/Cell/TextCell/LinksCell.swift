//
//  LinksCell.swift
//  ChatLib
//
//  Created by Sagar on 26/08/21.
//

import UIKit

class LinksCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var receiveStatusView1: UIView!
    @IBOutlet weak var receiveStatusView2: UIView!

    @IBOutlet weak var receiveDateAgoLbl: UILabel!
    @IBOutlet weak var messageReceiveLBL: UITextView! {
        didSet {
            //messageReceiveLBL.contentInset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        }
    }
    
    var minHeight: CGFloat?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        self.messageReceiveLBL.delegate = self
        self.messageReceiveLBL.isUserInteractionEnabled = false
        self.messageReceiveLBL.isEditable = false
        messageReceiveLBL.layer.cornerRadius = 10.0
        messageReceiveLBL.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //set the values for top,left,bottom,right margins
        let margins = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = minHeight else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
    func configureCell(message : String, font: Float, dateAgoLbl: String){
        self.messageReceiveLBL.font = UIFont.systemFont(ofSize: CGFloat(font))
        self.messageReceiveLBL.text = message
        self.receiveDateAgoLbl.text = dateAgoLbl
    }
}
