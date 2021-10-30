//
//  CobrowseEndModel.swift
//  ChatLib
//
//  Created by Sagar on 06/09/21.
//

import Foundation

class CobrowseEndModel  {
    
    static internal func endCobrowseSession() {
        let messageDictionary : [String:Any] = ["Message": "Cobrowsing ended... Session ID: ", "MessageType" : "TEXT", "Type": "User", "FileType":"text", "DateTime":UserDetails.getCurrentFormattedDate(), "MessageId":UserDetails.messageID]
        
        let dataDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "message": messageDictionary]
        let eventDictionary : [String:Any] = ["eventName":"cobrowseEnded", "data": dataDictionary]
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventDictionary)
        
        DispatchQueue.main.async {
            colabView.removeDrawEvent()
        }
    }
    
    
    static internal func endCobrowseSucess() {
        toastView(msg: "CoBrowse session closed")
        if (CobrowseSocketHelper.shared.cobrowseSocket!.status == .connected || CobrowseSocketHelper.shared.cobrowseSocket!.status == .connecting) {
            CobrowseSocketHelper.shared.cobrowseSocket!.disconnect()
            
            CobrowseSocketHelper.shared.disconnect()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                HoverBtn.shared.hoverView.isHidden = true
                HoverBtn.shared.hoverView.removeFromSuperview()
                AgentJoined.disconnectTimer()
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                HoverBtn.shared.hoverView.isHidden = true
                HoverBtn.shared.hoverView.removeFromSuperview()
                AgentJoined.disconnectTimer()
                CobrowseSocketIndividual.shareds.disconnect()
            }
        }
    }
}




