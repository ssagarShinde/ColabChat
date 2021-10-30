//
//  CobrowseHelper.swift
//  ChatLib
//
//  Created by Sagar on 04/09/21.
//

import UIKit

public enum CobrowseStatus {
    
    case connected
    case connecting
    case notconnected
    case notAvailable
    case disconnected
    case notConnected
}

public class CobrowseHelper {
    
    static public var delegate : UIViewController?
    static public func startCobrowse() -> CobrowseStatus {
        
        let chatStatus = ChatSocketHelper.shared.chatmanager?.status
        let status = CobrowseSocketIndividual.shareds.cobrowseSockets?.status
        
        if chatStatus == .connected {
            if (status != .connected && status != .connecting) {
                return .disconnected
            }
            else {
                return .notAvailable
            }
        }
        
        else if status == .connected {
            return .connected
        }
        
        else if status == .connecting {
            return .connecting
        }
        
        else if status == .disconnected {
            CobrowseSocketIndividual.shareds.disconnect()
            ChatSocketHelper.shared.startCOBROWSE(type: "")
            return .disconnected
        }
        
        else if status == .notConnected {
            CobrowseSocketIndividual.shareds.disconnect()
            ChatSocketHelper.shared.startCOBROWSE(type: "")
            return .disconnected
        }
        else {
            CobrowseSocketIndividual.shareds.disconnect()
            ChatSocketHelper.shared.startCOBROWSE(type: "")
            return .notconnected
        }
    }
    
    static private func initiatesCobrowse() {
        let chatInitialize : [String:Any] = ["token": UserDetails.token, "sessionId" : UserDetails.sessionID, "channelSource": "COBROWSE","userName": SocketHelper.userName,"userId":SocketHelper.userID]
        let eventNameDict : [String:Any] = ["eventName":"initializeProcess","data":chatInitialize]
       // CobrowseSocketIndividual.shareds.chatSocketEmits(eventName: "req", arg: eventNameDict)
        ChatSocketHelper.shared.chatSocketEmit(eventName: "req", arg: eventNameDict)
    }
    
    static public func showScreen(view : UIView) {
        let popup = ScreenSharePopup()
        popup.frame = view.bounds
        popup.createUI(btnTag: 0)
        popup.delegate = delegate as? ShareScreenPr
        view.window?.addSubview(popup)
    }
    
    
    static public func handleCancelBtn( ) {
        
        let messageDictionary : [String:Any] = ["Message": "Cobrowsing ended... Session ID: ", "MessageType" : "TEXT", "Type": "User", "FileType":"text", "DateTime":UserDetails.getCurrentFormattedDate(), "MessageId":UserDetails.messageID]
        
        let dataDictionary : [String:Any] = ["ChannelSource":"CHAT", "chatInteractionId": UserDetails.chatInteractionID, "token": UserDetails.token, "message": messageDictionary]
        let eventDictionary : [String:Any] = ["eventName":"cobrowseEnded", "data": dataDictionary]
        
        CobrowseSocketIndividual.shareds.cobrowseSocketEmit(eventName: "req", arg: eventDictionary)
        
        DispatchQueue.main.async {
            colabView.removeDrawEvent()
        }
    }
    
}
