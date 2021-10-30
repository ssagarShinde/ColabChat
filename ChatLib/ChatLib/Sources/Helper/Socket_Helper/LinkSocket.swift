//
//  LinkSocket.swift
//  ChatLib
//
//  Created by Sagar on 04/10/21.
//

import Foundation

import SocketIO
public class LinkSocket: NSObject {
    
    static public let shared = LinkSocket()
    
    public var linkManagers: SocketManager?
    public var linkSocket: SocketIOClient?
    
    public override init() {
        super.init()
        configureSocketClient(receivedURL: UserDetails.linkURL)
    }
    
    public func configureSocketClient(receivedURL: String) {
        print("Link Socket URL : \(UserDetails.linkURL)")
        
        guard let url = URL(string: UserDetails.linkURL) else {
            return
        }
        linkManagers = SocketManager(socketURL: url, config: [.log(false), .compress,.forceNew(false),.reconnects(false),.reconnectWait(1000),.reconnectWaitMax(5000),.reconnectAttempts(99999), .path(UserDetails.linkPath),.connectParams(["EIO": "3"])])
        
        guard let manager = linkManagers else {
            return
        }
        linkSocket = manager.socket(forNamespace: "/**********")
    }
    
    public func establishConnections(replyEmailTo : String, description : String, subject: String, priority : String, status : String, requestType : String, sourceChannel : String, userType : String, businessHours : String, source : String, sourceId : String, UploadFileNames : String, contactNo : String,emailTo : String) {
        
        linkSocket = linkManagers?.defaultSocket
        linkSocket?.on(clientEvent: .connect) { [self] data, ack in
        print("Link Socket Connection",linkSocket?.status ?? false)
            
            let mainDict : [String:Any] = [
                "userID": SocketHelper.userID,
                "name": SocketHelper.userName,
                "number": contactNo,
                "emailID": emailTo,
                "contactNo": contactNo,
                "replyEmailTo": emailTo,
                "emailTo": emailTo,
                "requestType": "Complaint",
                "location": "MobCast Innovations Pvt. Ltd 505 Tanishka, 5th Floor Nr Growels 101 Mall, Akurli Rd, Kandivali, Akurli Industry Estate, Kandivali East, Mumbai, Maharashtra 400101, India",
                "priority": "Normal",
                "subject": subject,
                "description": description,
                "status": "Open"
            ]
            print(mainDict)
            let eventNameDict : [String:Any] = ["eventName":"createCase","data":mainDict]
            linkSocketEmit(eventName: "req", arg: eventNameDict)
        }
        linkSocket?.connect()
        listenOtherEvents()
        
    }
    
    
    public func fetchHistory(status : [String]) {
        
        linkSocket = linkManagers?.defaultSocket
        linkSocket?.on(clientEvent: .connect) { [self] data, ack in
            print("Link Socket Connection",linkSocket?.status ?? false)
            let mainDict  = [ "status" : status ]
            let eventNameDict : [String:Any] = ["eventName":"caseList","data":mainDict]
            linkSocketEmit(eventName: "req", arg: eventNameDict)
        }
        linkSocket?.connect()
        listenOtherEvents()
    }
    
    func linkSocketEmit(eventName: String, arg: Any){
        print(arg)
        guard let data = UIApplication.jsonData(from: arg) else {
            return
        }
        let encryptedData = DataFile.encryptedData(Payload: data, attachePublicKey: true)
        linkSocket?.emit(eventName,encryptedData)
    }
    

    func listenOtherEvents() {
        linkSocket?.on("res") { data,ack  in
            print(data)
            let AuthDataDict = self.decryptData(data: data)
            guard let eventName = AuthDataDict?["eventName"] else  { return }
            print(eventName)
            
            switch (eventName as? String ?? "") {
            case "caseCreatedSuccess" :
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CaseCreatedSuccess"), object: nil, userInfo: AuthDataDict as? [AnyHashable : Any])
                break
                
            case "caseListSuccess" :
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CaseListSuccess"), object: nil, userInfo: AuthDataDict as? [AnyHashable : Any])
                break
            default :
                break
            }
        }
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
}


