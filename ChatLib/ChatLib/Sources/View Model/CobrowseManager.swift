//
//  CobrowseManager.swift
//  ChatLib
//
//  Created by Sagar on 11/10/21.
//

import UIKit

public class CobrowseManager {
    public static let shared = CobrowseManager()
    public var view : UIView?
    private var status : CobrowseStatus?
    
    
    public static func joinChat (completion: @escaping (_ status: CobrowseStatus) -> Void) {
        if ((SocketHelper.shared.socket?.status ?? .notConnected) == .connected)  {
            let status = CobrowseHelper.startCobrowse()
            completion(status)
        }
        else {
            SocketHelper.shared.establishConnection { status in
                let status = CobrowseHelper.startCobrowse()
                completion(status)
            }
        }
    }
    
     public static func setupUI(tag : Int, view : UIView?) {
        guard let subView = view else {return }
        DispatchQueue.main.async {
            let popup = ScreenSharePopup()
            popup.frame = subView.bounds
            popup.createUI(btnTag: tag) //1 For Start button
            popup.delegate = self as? ShareScreenPr
            subView.window?.addSubview(popup)
        }
    }
}

extension CobrowseManager : ShareScreenPr {
    public func value(tag: Int) {
        if (tag == 1) {
            CobrowseHelper.handleCancelBtn()
        }
    }
}

