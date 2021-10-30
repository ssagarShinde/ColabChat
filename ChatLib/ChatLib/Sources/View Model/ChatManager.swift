//
//  ChatManager.swift
//  ChatLib
//
//  Created by Sagar on 09/10/21.
//

import UIKit

public class ChatManager {
    public static let shared = ChatManager()
    public var view : UIView?
    
    public static func joinChat () {
        if ((ChatSocketHelper.shared.chatSocket?.status ?? .notConnected) == .connected || (ChatSocketHelper.shared.chatSocket?.status ?? .notConnected) == .connecting) {
            DispatchQueue.main.async {
                ChatManager.shared.setupUI()
            }
        }
        else {
            
            if ((SocketHelper.shared.socket?.status ?? .notConnected) == .connected) {
                ChatManager.shared.setupUI()
            }
            else {
                SocketHelper.shared.establishConnection { status in
                    if (status ?? false) {
                        ChatManager.shared.setupUI()
                    }
                }
            }
        }
    }
    
    func setupUI() {
        DispatchQueue.main.async {
            let ChattingView: ChatView = .fromNib()
            guard let subView = ChatManager.shared.view else {return}
            subView.addSubview(ChattingView)
            
            ChattingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                [
                    ChattingView.topAnchor.constraint(equalTo: subView.topAnchor, constant: BaseController.getStatusBarHeight),
                    ChattingView.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
                    ChattingView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
                    ChattingView.trailingAnchor.constraint(equalTo: subView.trailingAnchor)
                ]
            )
        }
    }
}
