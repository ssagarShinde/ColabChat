//
//  HoverBtn.swift
//  ChatLib
//
//  Created by Sagar on 04/09/21.
//

import UIKit

protocol HoverBtnPr {
    func handleDisconnect()
}


class  HoverBtn : UIView {
    
    static let shared = HoverBtn()
    
    var hoverView : HoverView!
    var delegate : HoverBtnPr?
    
    func setup () {
        hoverView = HoverView(with: HoverConfiguration(image:  UIImage(named: "colabMobile", in: Bundle(for: type(of:self)), compatibleWith: nil), color: .gradient(top: UIColor(red: 20/255, green: 59/255, blue: 97/255, alpha: 1), bottom: UIColor(red: 20/255, green: 59/255, blue: 97/255, alpha: 1))),
                              items: [HoverItem(title: "Disconnect", image: UIImage(named: "colabDisconnect", in: Bundle(for: type(of:self)), compatibleWith: nil)) {
                                
                                CobrowseEndModel.endCobrowseSession()
                                //self.delegate?.handleDisconnect()
                                //self.endCobrowseSession()
                              },
                              HoverItem(title: "Remove", image: UIImage(named: "colabClear", in: Bundle(for: type(of:self)), compatibleWith: nil)) {
                                colabView.removeDrawEvent()
                              },
                              HoverItem(title: "Copy Url", image: UIImage(named: "colabPin", in: Bundle(for: type(of:self)), compatibleWith: nil)) {
                                UIPasteboard.general.string = "\(UserDetails.shareCoBrowseURL)\(UserDetails.chatInteractionID)"
                                self.toastView(msg: "WebURL copied to clipboard")
                              },
                              
                              HoverItem(title: "Edit", image: UIImage(named: "edit", in: Bundle(for: type(of:self)), compatibleWith: nil)) { },
                              
                              HoverItem(title: "Cancel", image: UIImage(named: "cancel", in: Bundle(for: type(of:self)), compatibleWith: nil)) {  },
                              ])
        
        let selfs =  UIApplication.shared.keyWindow!
        UIApplication.shared.keyWindow!.addSubview(hoverView!)
        //self.addSubview()
        hoverView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                hoverView!.topAnchor.constraint(equalTo: selfs.topAnchor),
                hoverView!.bottomAnchor.constraint(equalTo: selfs.bottomAnchor),
                hoverView!.leadingAnchor.constraint(equalTo: selfs.leadingAnchor),
                hoverView!.trailingAnchor.constraint(equalTo: selfs.trailingAnchor)
            ]
        )
    }
    
    
    func removeHover() {
        self.hoverView.removeFromSuperview()
    }
    
}
