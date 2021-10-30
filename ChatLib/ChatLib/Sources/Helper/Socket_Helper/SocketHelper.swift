//
//  SocketHelper.swift
//  ChatLib
//
//  Created by SmartConnect Technologies on 05/04/21.
//

import UIKit
import SocketIO

public class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    
    var manager: SocketManager?
    var socket: SocketIOClient?
    
    public static var userName = ""
    public static var userID = ""
    public static var mobileNumber = ""
    public static var emialId = ""
    
    let cobroswseSdk = CobrowseSocketHelper()

   public override init() {
        super.init()
        configureSocketClient()
    }
    //http://mobchat.unfyd.com:3000/
    //http://mobchat.unfyd.com:5000/
    //http://103.249.134.81:5000/
    //http://40.75.8.74/
    // http://mobcai.unfyd.com:5000/
    //"http://104.211.7.80:3000/"
    
    
    public func configureSocketClient() {
        guard let url = URL(string: "http://mobapp.unfyd.com:3000/") else {
            return
        }
        
        manager = SocketManager(socketURL: url, config: [.log(false), .compress,.reconnects(true),.reconnectWait(100000),.reconnectWaitMax(150000),.reconnectAttempts(99999), .forceNew(false), .path("/auth/socket.io"),.connectParams(["EIO": "3"])])
        
        guard let manager = manager else {
            return
        }
        socket = manager.socket(forNamespace: "/**********")
    }
    
    public func establishConnection(completion: @escaping (_ status: Bool?) -> Void) {
        socket = manager?.defaultSocket
        socket?.on(clientEvent: .connect) { [self] data, ack in
            
            print("Auth Socket Status \(self.socket!.status as Any)")
            let userDetail : [String:Any] = ["userName": SocketHelper.userName, "userId" : SocketHelper.userID, "userEmail": SocketHelper.emialId , "userLatitude":"0.0", "userLongitude":"0.0", "userNumber" : SocketHelper.mobileNumber]
            
            let deviceDetail : [String: Any] = ["platform":"ios","uniqueID":UserDetails.udid, "packageName" :Bundle.main.bundleIdentifier!, "versionName": UserDetails.appVersion, "versionCode": UserDetails.buildVersion,"sdkVersion": UserDetails.appVersion,"model": UserDetails.modelNumber,"apiLevel": "13","screenResolution": UserDetails.screenResolution,"screenDensity": "3.0","product": UserDetails.modelNumber,"manufacturer": "Apple","board": "QEMU","appState": true,"memoryFree": DiskStatus.usedDiskSpace,"totalMemory": DiskStatus.totalDiskSpace,"cpuInfo": "0","batteryInfo": "\(UserDetails.batteryLevel * 100)%","isCharging": "false","mockLocation": false,"statusBarHeight": "","navBarHeight": "","density": "","densityDpi": "","screenWidth": UIScreen.main.bounds.width,"screenHeight": UIScreen.main.bounds.height,"scaledDensity": "","xdpi": "","ydpi": ""]
            
            let mainDict : [String:Any] = ["userDetail":userDetail, "deviceDetail": deviceDetail]
            print(mainDict)
            guard let data1 = UIApplication.jsonData(from: mainDict)else {
                return
            }
            DataFile.updateKeyIV(passwordString:"\(UserDetails.buildVersion+UserDetails.appVersion)")
            let encryptedData = DataFile.encryptedData(Payload: data1, attachePublicKey: false)
            DataFile.updateKeyIV(passwordString: UserDetails.udid)
            emitForSocket(eventName: "ConfigRequest", arg: encryptedData)
        }
        socket?.connect()
        socket!.on("ConfigResponse") { data,ack  in
            var aString = String()
            var decryptedString = String()
            var AuthDataDict = NSDictionary()
            for i in 0..<data.count{
                aString = data[i] as! String
                decryptedString = DataFile.decryptedData(encrypted: aString)
                if let datas = decryptedString.convertToDictionary() as NSDictionary? {
                    AuthDataDict = datas
                }
                else {
                    completion(false)
                    return
                }
                print(AuthDataDict)
                UserDetails.token = AuthDataDict.value(forKey: "Token") as! String
                UserDetails.sessionID = AuthDataDict.value(forKey: "SessionId") as! String
                UserDetails.chatURL = AuthDataDict.value(forKey: "ChatLib") as! String
                UserDetails.cobrowseURL = AuthDataDict.value(forKey: "BrowseLib") as! String
                UserDetails.videoURL = AuthDataDict.value(forKey: "VideoLib") as! String
                UserDetails.publicKey = AuthDataDict.value(forKey: "publicKey") as! String
                UserDetails.privateKey = AuthDataDict.value(forKey: "privateKey") as! String
                UserDetails.chatPath = AuthDataDict.value(forKey: "ChatPath") as! String
                UserDetails.browsePath = AuthDataDict.value(forKey: "BrowsePath") as! String
                UserDetails.shareCoBrowseURL = AuthDataDict.value(forKey: "ShareCoBrowseURL") as! String
                UserDetails.pollUrl = AuthDataDict.value(forKey: "PollUrl") as! String
                UserDetails.linkURL = AuthDataDict.value(forKey: "LinkURL") as! String
                UserDetails.linkPath = AuthDataDict.value(forKey: "LinkPath") as! String
                
                DataFile.getconfigDict(data: AuthDataDict)
                DataFile.updateKeyIV(passwordString:AuthDataDict.value(forKey: "privateKey") as! String)
            
                completion(true)
            }
        }
    }
    
    public func closeConnection() {
        socket?.removeAllHandlers()
        socket?.didDisconnect(reason: "Disconnect")
    }
    
    public func emitForSocket(eventName: String, arg: Any){
        socket?.emit(eventName, arg as! SocketData)
    }
    
    func getMessage(completion: @escaping (_ messageInfo: NSDictionary) -> Void) {
        
        
    }
}
