//
//  ChatSocketHelper.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import UIKit
import SocketIO
public class ChatSocketHelper: NSObject {
    
    static public let shared = ChatSocketHelper()
    
    public var chatmanager: SocketManager?
    public var chatSocket: SocketIOClient?
    var chatDataDict = NSDictionary()
    
    public override init() {
        super.init()
        configureSocketClient(receivedURL: UserDetails.chatURL)
    }
    
    public func configureSocketClient(receivedURL: String) {
        guard let url = URL(string: receivedURL) else {
            return
        }
        //
        
        chatmanager = SocketManager(socketURL: url, config: [.log(false), .compress,.forceNew(false),.reconnects(true),.reconnectWait(100000),.reconnectWaitMax(150000),.reconnectAttempts(99999),.path(UserDetails.chatPath),.connectParams(["EIO": "3"])])
        
        guard let manager = chatmanager else {
            return
        }
        chatSocket = manager.socket(forNamespace: "/**********")
    }
    
    public  func chatSocketEstablishConnection(type:String) {
        chatSocket = chatmanager?.defaultSocket
        chatSocket?.on(clientEvent: .connect) { [self] data, ack in
            
            print("Chat Status \(self.chatSocket?.status as Any)")
            let chatInitialize : [String:Any] = ["token": UserDetails.token, "sessionId" : UserDetails.sessionID, "channelSource": "CHAT","userName": SocketHelper.userName,"userId":SocketHelper.userID]
            let eventNameDict : [String:Any] = ["eventName":"initializeProcess","data":chatInitialize]
            chatSocketEmit(eventName: "req", arg: eventNameDict)
        }
        
        chatSocket?.connect()
        listenOtherEvents()
    }
    
    public  func startCOBROWSE(type:String) {
        
        chatSocket = chatmanager?.defaultSocket
        chatSocket!.on(clientEvent: .connect) { [self] data, ack in
            
            print("Chat Status \(self.chatSocket?.status as Any)")
            let chatInitialize : [String:Any] = ["token": UserDetails.token, "sessionId" : UserDetails.sessionID, "channelSource": "COBROWSE","userName": SocketHelper.userName,"userId":SocketHelper.userID]
            let eventNameDict : [String:Any] = ["eventName":"initializeProcess","data":chatInitialize]
            chatSocketEmit(eventName: "req", arg: eventNameDict)
        }
        
        chatSocket?.connect()
        listenOtherEvents()
    }
    
    func listenOtherEvents() {
        chatSocket!.on("res") { data,ack  in
            
            var aString = String()
            var decryptedString = String()
            var AuthDataDict = NSDictionary()
            for i in 0..<data.count {
                aString = data[i] as! String
                decryptedString = DataFile.decryptedData(encrypted: aString)
                let data = decryptedString.convertToDictionary() as NSDictionary?
                if let tempData = data {
                    AuthDataDict = tempData
                }
                else {
                    return
                }
            }
            let eventName = AuthDataDict["eventName"] as! String
            print(eventName)
            
            debugPrint(eventName)
            
            DispatchQueue.main.async {
                
                switch eventName {
                case "newMessage":
                    let chatDictionary : [String:Any] = AuthDataDict["data"] as! [String : Any]
                    let dict = chatDictionary as NSDictionary?
                    let agentDetails = dict!.value(forKey: "agentData") as! NSDictionary
                    let keyExists = agentDetails.value(forKey: "name") != nil
                    if keyExists {
                        UserDetails.agentName = agentDetails.value(forKey: "name") as! String
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMessage"), object: nil, userInfo: chatDictionary)
                    break
                    
                case "initializeSuccess":
                    let chatID = AuthDataDict["data"] as? NSDictionary
                    UserDetails.chatInteractionID = chatID?.value(forKey: "chatInteractionId") as! String
                    let chatHistoryDict:[String: Any] = ["From": "chatHistory","ChatID":chatID! as NSDictionary ]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatHistory"), object: nil, userInfo: chatHistoryDict )
                    break
                    
                case "messageSuccess":
                    let data = AuthDataDict["data"] as! [String : Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "messageSuccess"), object: nil, userInfo: data)
                    break
                    
                    
                case "agentTyping":
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AgentTyping"), object: nil, userInfo: nil)
                    break
                    
                case "chatHistorySuccess":
                    let chatID = AuthDataDict["data"] as? NSDictionary
                    let chatHistorySuccessDict:[String: Any] = ["From": "chatHistorySuccess","ChatID":chatID! as NSDictionary ]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatHistory"), object: nil, userInfo: chatHistorySuccessDict )
                    break
                    
                case "successPreviousChatList":
                    
                    let data : [String:Any] = AuthDataDict as! [String:Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PreviousChatList"), object: nil, userInfo: data)
                    break
                    
                case "successPreviousChatHistory":
                    let data : [String:Any] = AuthDataDict as! [String:Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PreviousChatHistory"), object: nil, userInfo: data)
                    break
                    
                case "endChatSuccess":
                    let data : [String:Any] = AuthDataDict as! [String:Any]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EndChatSuccess"), object: nil, userInfo: data)
                    
                    DispatchQueue.main.async {
                        AgentJoined.disconnectTimer()
                    }
                    
                    break
                    
                // COBROWSE Cases
                case "cobrowseInitializeSuccess":
                    let data : [String:Any] = AuthDataDict as! [String:Any]
                    if let datas = data["data"] as? [String:Any] {
                        
                        UserDetails.coBrowsechatInteractionId = datas["chatInteractionId"] as? String ?? ""
                        UserDetails.cobrowseSessionId = datas["cobrowseSessionId"] as? String ?? ""
                        print("chatInteractionId->", UserDetails.coBrowsechatInteractionId)
                    }
                    
                case "cobrowseEndSuccess":
                    let _ : [String:Any] = AuthDataDict as! [String:Any]
                    DispatchQueue.main.async {
                        CobrowseEndModel.endCobrowseSucess()
                    }
                    
                // Jio Video Case
                case "videoInitializeSuccess":
                    let data : [String:Any] = AuthDataDict as! [String:Any]
                    if let _ = data["data"] as? [String:Any] {
                        //VideoModel.getData(data: dic)
                    }
                    break
                    
                default:
                    print("No response")
                }
            }
        }
    }
    
    func chatSocketEmit(eventName: String, arg: [String: Any]) {
        print(arg)
        guard let data = UIApplication.jsonData(from: arg) else {
            return
        }
        let encryptedData = DataFile.encryptedData(Payload: data, attachePublicKey: true)
        chatSocket?.emit(eventName,encryptedData)
    }
    
    public func socketChatCloseConnection() {
        chatSocket?.removeAllHandlers()
        chatSocket?.didDisconnect(reason: "Disconnect")
    }
}
