//
//  AgentJoined.swift
//  ChatLib
//
//  Created by Sagar on 06/09/21.
//

import UIKit

class AgentJoined {
    
    static var imageTimer: Timer?
    static var oldImgData = ""
    
    static let window = UIApplication.shared.keyWindow!
    static var transparentView = UIView()
    
    static var endChatView : EndChatView = .fromNib()
    static let height: CGFloat = 250
    
    static func agentJoined() {
        
        self.imageTimer = Timer.scheduledTimer(withTimeInterval: 0.125, repeats: true) { (time) in
            let imageData = imageFucntion.screenShot(userAllowed: "T", showScreen: "T")
            
            if self.oldImgData != imageData {
                
                self.oldImgData = imageData ?? ""
                let data: [String:Any] =  ["base64":imageData ?? "","currentOrientation":"Portrait"]
                
                guard let data1 = UIApplication.jsonData(from: data)else {
                    return
                }
                
                DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
                let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
                DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
                
                let chatStatus = CobrowseSocketHelper.shared.cobrowseSocket?.status
                let status = CobrowseSocketIndividual.shareds.cobrowseSockets?.status
                
                if (chatStatus == .connected) {
                    CobrowseSocketHelper.shared.cobrowseSocketEmit(eventName: "newScreen", arg: encryptedData)
                }
                
                else if (status == .connected) {
                    CobrowseSocketIndividual.shareds.cobrowseSocketEmit(eventName: "newScreen", arg: encryptedData)
                }
            }
        }
    }
    
    static func disconnectTimer() {
        if AgentJoined.imageTimer != nil {
            AgentJoined.imageTimer?.invalidate()
            AgentJoined.imageTimer = nil
        }
    }
    
    
    static func agentDisconnected(AgentSideEndChat : String) {
        
        endChatView.delegate2 = AgentJoined.window
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = UIApplication.shared.keyWindow!.frame
        window.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        window.addSubview(endChatView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.alpha = 0
        
        if AgentSideEndChat == "F" {
            transparentView.addGestureRecognizer(tapGesture)
            endChatView.agentEndChatView.isHidden = true
        }else{
            transparentView.removeGestureRecognizer(tapGesture)
            endChatView.agentEndChatView.isHidden = false
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.endChatView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func onClickTransparentView() {
        endChatCalled()
    }
    
    func endChatCalled() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            AgentJoined.transparentView.alpha = 0
            AgentJoined.endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: AgentJoined.height)
        }, completion:  { (finished: Bool) in
            AgentJoined.transparentView.removeFromSuperview()
            AgentJoined.endChatView.removeFromSuperview()
        })
    }
}


extension UIWindow : EndChatDelegate {
    
    func didCancelButtonTapped() {
        AgentJoined.disconnectTimer()
        CobrowseSocketHelper.shared.disconnect()
        CobrowseSocketIndividual.shareds.disconnect()
        endChatCalled()
    }
    
    func didAgentEndChatButtonTapped() {
        removeSubviewOnendChat()
    }
    
    func closeAgentView() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            AgentJoined.transparentView.alpha = 0
            AgentJoined.endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height:  AgentJoined.height)
        }, completion:  { (finished: Bool) in
            AgentJoined.transparentView.removeFromSuperview()
        })
        
        AgentJoined.disconnectTimer()
        endCobrowseSession()
    }
    
    
    //Supporting Methods
    func endChatCalled() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            AgentJoined.transparentView.alpha = 0
            AgentJoined.endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: AgentJoined.height)
        }, completion:  { (finished: Bool) in
            AgentJoined.transparentView.removeFromSuperview()
            AgentJoined.endChatView.removeFromSuperview()
        })
    }
    
    func didEndChatButtonTapped() {
        
        AgentJoined.endChatView.btnCancel.isHidden = true
        AgentJoined.endChatView.btnEndChat.isHidden = true
        AgentJoined.endChatView.loader.isHidden = false
        AgentJoined.endChatView.loader.startAnimating()
        AgentJoined.transparentView.isUserInteractionEnabled = false
        
        switch CobrowseSocketHelper.shared.cobrowseSocket?.status {
        case .connected, .connecting:
            endCobrowseSession()
        default:
            break
        }
        
        let eventDictionary : [String:Any] = ["eventName":"endChat", "data": DataFile.getConstantDictionary()]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
    }
    
    func endCobrowseSession() {
        
        let messageDictionary : [String:Any] = ["Message": "Cobrowsing ended... Session ID: ", "MessageType" : "TEXT", "Type": "User", "FileType":"text", "DateTime":UserDetails.getCurrentFormattedDate(), "MessageId":UserDetails.messageID]
        
        let dataDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "message": messageDictionary]
        let eventDictionary : [String:Any] = ["eventName":"cobrowseEnded", "data": dataDictionary]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
        
        DispatchQueue.main.async {
            colabView.removeDrawEvent()
        }
    }
    
    func removeSubviewOnendChat() {
        
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            AgentJoined.transparentView.alpha = 0
            AgentJoined.endChatView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: AgentJoined.height)
        }, completion:  { (finished: Bool) in
            AgentJoined.transparentView.removeFromSuperview()
            AgentJoined.endChatView.removeFromSuperview()
           // AgentJoined.statusBar.removeFromSuperview()
            NotificationCenter.default.removeObserver(self)
            AgentJoined.endChatView.removeFromSuperview()
            UserDetails.agentName = ""
        })
        ChatSocketHelper.shared.socketChatCloseConnection()
    }
    
}
