//
//  LinkManager.swift
//  ChatLib
//
//  Created by Sagar on 11/10/21.
//

import UIKit

public class LinkManager {
    public static let shared = LinkManager()
    public var view : UIView?
    
    public static func joinChat () {
        if ((SocketHelper.shared.socket?.status ?? .notConnected) == .connected)  {
            DispatchQueue.main.async {
                ChatManager.shared.setupUI()
            }
        }
        else {
            SocketHelper.shared.establishConnection { status in
                DispatchQueue.main.async {
                    ChatManager.shared.setupUI()
                }
            }
        }
    }
    
    func setupUI() {
        DispatchQueue.main.async {
            
        }
    }
}
