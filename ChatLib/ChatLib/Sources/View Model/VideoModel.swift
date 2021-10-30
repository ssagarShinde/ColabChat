//
//  VideoModel.swift
//  ChatLib
//
//  Created by Sagar on 08/09/21.
//

import Foundation



//import JioMeetSDK

/*class VideoModel {
    
    static var manager: JioMeetManager?
    let window = UIApplication.shared.keyWindow!
    
    static internal func getData (data : [String:Any]) {
        
        if let dic = data as? [String:Any] {
            let  jiomeetId = dic["jiomeetId"] as? String ?? ""
            let  roomPIN = dic["roomPIN"] as? String ?? ""
            
            manager = JioMeetManager.shared()
            manager?.delegate = window
            
            let meetingId = jiomeetId
            let pin = roomPIN
            let name = SocketHelper.userName
            
            let flowParams = [
                "jiomeetId": meetingId,
                "roomPIN": pin,
                "name": name
            ]
            
            JioMeetManager.shared().joinVideoConference(withCallFlowPramas: flowParams) { result, viewController in
                if result {
                    viewController.view.frame = weakSelf?.view.frame ?? CGRect.zero
                    weakSelf?.view.addSubview(viewController.view)
                }
            }
        }
    }
}

extension UIWindow : JMVideoViewControllerProtocol {
    
    
}*/

