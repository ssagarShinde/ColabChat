//
//  CobrowseSocketIndividual.swift
//  ChatLib
//
//  Created by Sagar on 04/09/21.
//

import Foundation

import SocketIO
public class CobrowseSocketIndividual: NSObject {
    
    static public let shareds = CobrowseSocketIndividual()
    public var standalone = false
    
    public var cobrowsemanagers: SocketManager?
    public var cobrowseSockets: SocketIOClient?
    
    public static var userName = ""
    public static var userID = ""
    public static var mobileNumber = ""
    public static var emialId = ""
    
    weak var imageTimer: Timer?
    private var hoverView =  HoverBtn()
    
    var cobrowseDataDict = NSDictionary()
    
    public override init() {
        super.init()
        configureSocketClient(receivedURL: UserDetails.cobrowseURL)
    }
    
    public func configureSocketClient(receivedURL: String) {
        print("Cobrowse URL :http://mobapp.unfyd.com:3006/")
        
        guard let url = URL(string: "http://mobapp.unfyd.com:3006/") else {
            return
        }
        cobrowsemanagers = SocketManager(socketURL: url, config: [.log(false), .compress,.forceNew(false),.reconnects(true),.reconnectWait(1000),.reconnectWaitMax(5000),.reconnectAttempts(99999), .path(UserDetails.browsePath),.connectParams(["EIO": "3"])])
        
        guard let manager = cobrowsemanagers else {
            return
        }
        cobrowseSockets = manager.socket(forNamespace: "/**********")
    }
    
    public func establishConnections(type:String) {
        
        cobrowseSockets = cobrowsemanagers?.defaultSocket
        cobrowseSockets!.on(clientEvent: .connect) { [self] data, ack in
            print("Cobrowse Connection",cobrowseSockets?.status ?? false)
            
            let appDetails : [String:Any] =    ["platform":"iOS",
                                                "verticalAccuracy":"0",
                                                "horizontalAccuracy":"0",
                                                "appBuild":1,
                                                "osVersion":"",
                                                "timeZone":"Asia/Kolkata",
                                                "latitude":"0.0",
                                                "longitude":"0.0",
                                                "appVersion": UserDetails.appVersion,
                                                "appName":UserDetails.buildVersion,
                                                "rtt":"",
                                                "imei":"",
                                                "device_name": UserDetails.modelNumber,
                                                "user_email":"",
                                                "user_id":SocketHelper.userID]
            
            
            let deviceDetail : [String: Any] = ["platform":"ios",
                                                "uniqueID":UserDetails.udid,
                                                "packageName":Bundle.main.bundleIdentifier!,
                                                "versionName":UserDetails.appVersion,
                                                "versionCode":UserDetails.buildVersion,
                                                "sdkVersion":UserDetails.appVersion,
                                                "model":UserDetails.modelNumber,
                                                "apiLevel":"13",
                                                "screenResolution":UserDetails.screenResolution,
                                                "screenDensity":"3.0",
                                                "product":UserDetails.modelNumber,
                                                "manufacturer": "Apple",
                                                "board": "QEMU",
                                                "appState":"foreground",
                                                "memoryFree": DiskStatus.usedDiskSpace,
                                                "totalMemory":DiskStatus.totalDiskSpace,
                                                "cpuInfo":"0",
                                                "batteryInfo":"\(UserDetails.batteryLevel * 100)%",
                                                "isCharging":"false",
                                                "mockLocation":false,
                                                "statusBarHeight": "",
                                                "navBarHeight": "",
                                                "density": "",
                                                "densityDpi": "",
                                                "screenWidth": screenWidth,
                                                "screenHeight": screenHeight,
                                                "scaledDensity":"",
                                                "xdpi":"",
                                                "ydpi":"",
                                                "imei":""]
            
            let mainDict : [String:Any] = ["interactionId" : UserDetails.coBrowsechatInteractionId,
                                           "sessionId" : UserDetails.cobrowseSessionId,
                                           "token" : UserDetails.token,
                                           "platform" : "ios",
                                           "appDetail" : appDetails,
                                           "deviceDetail" : deviceDetail]
            print(mainDict)
            guard let data1 = UIApplication.jsonData(from: mainDict)else {
                return
            }
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: true)
            DataFile.updateKeyIV(passwordString: UserDetails.privateKey)
            cobrowseSocketEmit(eventName: "addMobile", arg: encryptedData)
        }
        cobrowseSockets!.connect()
        listenOtherEvents()
    }
    
    func listenOtherEvents() {
        cobrowseSockets!.on("res") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            let _ = AuthDataDict?["eventName"] as! String
        }
        
        cobrowseSockets!.on("shareMobile") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            if let data = AuthDataDict?["data"] as? [String:Any] {
                DispatchQueue.main.async {
                    
                    HoverBtn.shared.setup()
                    HoverBtn.shared.hoverView.isHidden = false
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Configcobrowse"), object: nil, userInfo: data)
                }
            }
        }
        
        cobrowseSockets!.on("config") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            if let data = AuthDataDict?["data"] as? [String:Any] {
                if let configObj = data["configObj"] as? [String:Any] {
                    if let dic = configObj["data"] as? [String:Any] {
                        print(dic)
                    }
                }
            }
        }
        
        cobrowseSockets!.on("joinedAgent") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            if let data = AuthDataDict?["data"] as? [String:Any] {
                let agentId = data["agentID"] as? String ?? ""
                let agentName = data["agentName"] as? String ?? ""
                let joinMessage = data["joinMessage"] as? String ?? ""
                AgentModel.shared.saveData(agentId: agentId, agentName: agentName, joinMessage: joinMessage)
                DispatchQueue.main.async {
                    AgentJoined.agentJoined()
                }
            }
        }
        
        cobrowseSockets!.on("permissionRequest") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            if let data = AuthDataDict?["data"] as? [String:Any] {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowPermission"), object: nil, userInfo: data)
                }
            }
        }
        
        cobrowseSockets!.on("disconnectByNoActivity") { data,ack  in
            let _ = self.decryptData(data: data)
        }
        
        cobrowseSockets!.on("disconnectByTimeout") { data,ack  in
            let _ = self.decryptData(data: data)
        }
        
        cobrowseSockets!.on("agentDisconnect") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            if let _ = AuthDataDict?["data"] as? [String:Any] {
                DispatchQueue.main.async {
                    AgentJoined.agentDisconnected(AgentSideEndChat: "T")
                    
                }
            }
        }
        
        cobrowseSockets!.on("userDisconnect") { data,ack  in
            let _ = self.decryptData(data: data)
        }
        
        cobrowseSockets!.on("laserEvent") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            DispatchQueue.main.async {
                if let dic = AuthDataDict as NSDictionary? {
                    if let data = dic["data"] as? [String:Any] {
                        DispatchQueue.main.async {
                            colabView.colabLaserEvent(data: [data])
                        }
                    }
                }
            }
        }
        
        cobrowseSockets!.on("drawEvent") { data,ack  in
            let AuthDataDict = self.decryptData(data: data)
            DispatchQueue.main.async {
                if let dic = AuthDataDict as NSDictionary? {
                    if let data = dic["data"] as? [String:Any] {
                        DispatchQueue.main.async {
                            colabView.colabDrawEvent(data: [data])
                        }
                    }
                }
            }
        }
        
        cobrowseSockets!.on("removeDrawEvent") { data,ack  in
            let _ = self.decryptData(data: data)
            DispatchQueue.main.async {
                colabView.removeDrawEvent()
            }
        }
    }
    
    func cobrowseSocketEmit(eventName: String, arg: Any){
        cobrowseSockets?.emit(eventName,arg as! SocketData)
    }
    
    
    func decryptData(data : [Any]) -> NSDictionary? {
        var aString = String()
        var decryptedString = String()
        var AuthDataDict = NSDictionary()
        for i in 0..<data.count{
            aString = data[i] as? String ?? ""
            decryptedString = DataFile.decryptedData(encrypted: aString)
            let data = decryptedString.convertToDictionary() as NSDictionary?
            if let tempData = data {
                AuthDataDict = tempData
            }
            else {
            }
        }
        return AuthDataDict
    }
    
    public func disconnect() {
        cobrowseSockets!.removeAllHandlers()
        cobrowseSockets!.disconnect()
    }
}
