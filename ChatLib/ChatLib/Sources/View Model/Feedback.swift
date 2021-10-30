//
//  Feedback.swift
//  ChatLib
//
//  Created by Sagar on 25/09/21.
//

import UIKit

class Feedback {
    static func openFeedback() {
        
        let vc = WebViewVC()
        vc.urlString = "\(UserDetails.pollUrl)?UserID=\(SocketHelper.userID)&Name=\(SocketHelper.userName)&Number=\(SocketHelper.mobileNumber)&EmailID=\(SocketHelper.emialId)"
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        } else {
            
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
}
