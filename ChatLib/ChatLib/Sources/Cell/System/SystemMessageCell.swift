//
//  SystemMessageCell.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 08/04/21.
//

import UIKit

class SystemMessageCell: UITableViewCell {
    
    @IBOutlet weak var systemMessageLbl: PaddingLabel!
    
    var systemMinHeight: CGFloat?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        systemMessageLbl.layer.cornerRadius = 15.0
        systemMessageLbl.clipsToBounds = true
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        guard let minHeight = systemMinHeight else { return size }
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
    func configureCell(message: String, Font : Float){
        systemMessageLbl.font = UIFont.systemFont(ofSize: CGFloat(Font))
        systemMessageLbl.text = message
    }
}
